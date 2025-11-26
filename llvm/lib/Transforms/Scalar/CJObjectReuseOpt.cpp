//===- CJObjectReuseOpt.cpp - -----------------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file provides interface to "Cangjie Object Reuse Optimization" pass.
//
// This pass will optimize the scene where intra-function heap objects are 
// non-overlappping live range and no escaping. Reuse the allocated memory
// of dead object to reduce the frequency of memory management overhead.
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Scalar/CJObjectReuseOpt.h"

#include "llvm/ADT/Triple.h"
#include "llvm/ADT/GraphTraits.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/CFG.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/IR/SafepointIRVerifier.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/Pass.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/Analysis/CaptureTracking.h"
#include "llvm/Transforms/Scalar/CJFillMetadata.h"
#include "llvm/Transforms/Utils/CJSimpleGraphColoring.h"
#include "llvm/Support/Debug.h"

#include <set>
#include <queue>

using namespace llvm;

#define DEBUG_TYPE "CJObjectReuseOpt"

void CJObjectReuseOpt::clearMap() {
  ReuseHeapVarMap.clear();
  ReuseStackVarMap.clear();
  HeapCJVarToLiveInterval.clear();
  StackCJVarToLiveInterval.clear();
}

bool CJObjectReuseOpt::runImpl(Function &F, FunctionVarLifeTimeResult &LifeTimeResult, AliasAnalysis &AA, MemorySSA &MSSA, DominatorTree &DT, LoopInfo &LI) {
  clearMap();
  CandidateReuseMap BitSizeToNoEscapeVals;
  SmallPtrSet<const Value *, 32> EphValues;
  EarliestEscapeInfo EI(DT, LI, EphValues);
  BatchAAResults BatchAA(AA, &EI);

  collectNoEscapeValue(F, BitSizeToNoEscapeVals);
  adjustForReuseByLiveInterval(F, BitSizeToNoEscapeVals, LifeTimeResult, BatchAA, MSSA);
  bool Changed = transformForMemReuse(DT, LifeTimeResult);
#ifndef NDEBUG
  if (Changed) {
    LLVM_DEBUG({
      llvm::dbgs() << "CJObjectReuseOpt changed in : " << F.getName().str() << "\n";
    });
  }
#endif
  return Changed;
}

PreservedAnalyses CJObjectReuseOpt::run(Function &F, FunctionAnalysisManager &FAM) {
  auto &LifeTimeResult = FAM.getResult<CJFunctionVarLifeTime>(F);
  auto &MSSA = FAM.getResult<MemorySSAAnalysis>(F).getMSSA();
  auto &AA = FAM.getResult<AAManager>(F);
  auto &DT = FAM.getResult<DominatorTreeAnalysis>(F);
  auto &LI = FAM.getResult<LoopAnalysis>(F);
  if (runImpl(F, LifeTimeResult, AA, MSSA, DT, LI)) {
    return PreservedAnalyses::none();
  }
  return PreservedAnalyses::all();
}

bool CJObjectReuseOpt::isHeapZoneValue(Value *Val) {
  static SmallDenseMap<Value *, bool, 4> CacheAnalysis;
  if (CacheAnalysis.count(Val)) {
      return CacheAnalysis[Val];
  }
  assert(Val->getType()->isPointerTy() && "illegal val in CJObjectReuseOpt::isHeapZoneValue.");
  Value *Addr = Val;
  // check whether the origin def comes from addrspace(0)
  // currently we only process addrspacecast scene, more scene can be complemented
  // false positive is fine for it only misses optimazition
  while (auto* Inst = dyn_cast<AddrSpaceCastInst>(Addr)) {
    unsigned AddrSpace = Inst->getSrcAddressSpace();
    if (AddrSpace == 0) {
      CacheAnalysis[Val] = false;
      return false;
    }
    Addr = Inst->getPointerOperand();
  }
  CacheAnalysis[Val] = true;
  return true;
}

inline static bool isPointerCastFamily(Value *Val) {
  auto *Instr = dyn_cast<Instruction>(Val);
  if (Instr == nullptr) {
    return false;
  }
  if (Instr->getOpcode() == Instruction::AddrSpaceCast ||
      Instr->getOpcode() == Instruction::BitCast ||
      Instr->getOpcode() == Instruction::PtrToInt ||
      Instr->getOpcode() == Instruction::IntToPtr) {
        return true;
    }
  return false;
}

inline static bool isCJMallocObj(Value *V) {
  if(auto *CB = dyn_cast<CallBase>(V)) {
    return CB->getIntrinsicID() == Intrinsic::cj_malloc_object;
  }
  return false;
}

static bool isDefChainConsistOfCastOrPHI(Value *V) {
  if(auto *Instr = dyn_cast<Instruction>(V)) {
    // we assume the source is the cj.malloc.object or alloc
    while(Instr && !(isa<AllocaInst>(Instr) || isCJMallocObj(Instr))) {
      if (const Argument *Arg = dyn_cast<Argument>(Instr)) {
        return false;
      }
      if (isPointerCastFamily(Instr)) {
        Instr = dyn_cast<Instruction>(Instr->getOperand(0));
      }
       else if (auto *PHI = dyn_cast<PHINode>(Instr); PHI &&
        PHI->getNumIncomingValues() == 1) {
        Instr = dyn_cast<Instruction>(PHI->getIncomingValue(0));
      }
      else {
        return false;
      }
    }
    return (isa<AllocaInst>(Instr) || isCJMallocObj(Instr));
  }
  return false;
}

void CJObjectReuseOpt::collectNoEscapeValue(Function &F, CandidateReuseMap &BitSizeToNoEscapeVals) {
  constexpr StringRef CONSTRUCTOR_KEY_WORD = "<init>";
  constexpr unsigned BYTE_BIT_WIDTH = 8;
  for (auto &I : instructions(F)) {
    if (auto *CB = dyn_cast<CallBase>(&I)) {
      Function *Callee = CB->getCalledFunction();
      if (Callee && Callee->getName().contains(CONSTRUCTOR_KEY_WORD)) {
        Value *Addr = CB->getArgOperand(0);
        if (!isDefChainConsistOfCastOrPHI(Addr)) {
          continue;
        }
        auto *GV = dyn_cast<GlobalVariable>(CB->getArgOperand(CB->arg_size() - 1));
        if (!GV || !GV->hasInitializer() || !GV->hasAttribute("NotModifiableClass")) {
          continue;
        }
        auto &DL = F.getParent()->getDataLayout();
        auto *ClassInfo = GV->getInitializer();
        if (ClassInfo->getNumOperands() < ClassInfoFieldType::CIT_SIZE) {
          continue;
        }
        uint64_t BitSize = dyn_cast<Constant>(ClassInfo->getOperand(ClassInfoFieldType::CIT_SIZE))
                          ->getUniqueInteger().getZExtValue() * BYTE_BIT_WIDTH;
        if (BitSize == 0) {
          continue;
        }

        if (!isHeapZoneValue(Addr) || !PointerMayBeCaptured(Addr, true, true)) {
          BitSizeToNoEscapeVals[BitSize].push_back(CB);
#ifndef NDEBUG
          LLVM_DEBUG({
              llvm::dbgs() << "CJObjectReuseOpt no escape CB: " << *CB << "\n";
          });
#endif
        }
      }
    }
  }
}

void CJObjectReuseOpt::adjustForReuseByLiveInterval(Function &F, CandidateReuseMap &BitSizeToNoEscapeVals, FunctionVarLifeTimeResult &LifeTimeResult, BatchAAResults &AARes, MemorySSA &MSSA) {
  CandidateReuseMap HeapVars;
  CandidateReuseMap StackVar;

  for (auto &[BitSize, VarArr] : BitSizeToNoEscapeVals) {
    for (auto *CB : VarArr) {
      if (isHeapZoneValue(CB->getArgOperand(0))) {
        HeapVars[BitSize].push_back(CB);
      } else {
        StackVar[BitSize].push_back(CB);
      }
    }
  }

  // Note in SSA form, one CJ var can map to multiple SSA vars
  auto CalculateLiveIntervalForCJVar = [this, &F, &LifeTimeResult, &AARes, &MSSA] (CandidateReuseMap &InputMap) -> CJVarToLiveIntervalMap {
    CJVarToLiveIntervalMap CJVarToLiveInterval;
    for (auto &[BitSize, VarArr] : InputMap) {
      std::set<CallBase *> SkipCB;
      for (auto *CJVar : VarArr) {
        bool AddToCJVarToLiveIntervalMap = true;
        FunctionVarLifeTimeResult::LiveInterval CJVarLiveInterval = LifeTimeResult.SSAVarToLiveInterval[CJVar->getArgOperand(0)];
        MemoryLocation CJVarLoc = MemoryLocation(CJVar->getArgOperand(0), LocationSize::precise(BitSize));
        for (auto &Instr : instructions(F)) {
          if (!Instr.getType()->isPointerTy()) {
            continue;
          }
          if (&Instr != CJVar) {
            AliasResult AliasRes = AARes.alias(CJVarLoc, MemoryLocation::getAfter(&Instr));
            // MayAlias means we couldn't decide whether to replace mem or not,
            // PartialAlias means we should replace mem partly, currently not support.
            if (AliasRes == AliasResult::MayAlias || AliasRes == AliasResult::PartialAlias) {
              AddToCJVarToLiveIntervalMap = false;
              SkipCB.insert(CJVar);
              break;
            }
            if (AliasRes == AliasResult::MustAlias) {
              this->CJVarToMemEquivalenceVars[CJVar].insert(&Instr);
              CJVarLiveInterval = FunctionVarLifeTimeResult::combineLifeInterval(CJVarLiveInterval, LifeTimeResult.SSAVarToLiveInterval[&Instr]); 
            }
          }
        }
        if (!AddToCJVarToLiveIntervalMap) {
          continue;
        }

        // extra analysis for CJVar by Instr: 
        // e.g cast instr, getElementPtr instr, Phi
        // mimic llvm::getUnderlyingObject for collecting instr
        std::queue<Value*> UseQueue;
        std::set<Value*> HavePushed;
        UseQueue.push(CJVar->getArgOperand(0));
        HavePushed.insert(CJVar->getArgOperand(0));
        auto CollectMemEquivalenceVar = [&UseQueue, &HavePushed, &AddToCJVarToLiveIntervalMap, &SkipCB, &CJVar] (Value *Val, bool defInstrAnalysis) {
          auto *Instr = dyn_cast<Instruction>(Val);
          // currently not support partly replace.
          if (Instr->getOpcode() == Instruction::GetElementPtr) {
            AddToCJVarToLiveIntervalMap = false;
            SkipCB.insert(CJVar);
          }
          if (isPointerCastFamily(Val)) {
            auto *Target = defInstrAnalysis ? Instr->getOperand(0) : Val;
            if (HavePushed.count(Target) == 0) {
              UseQueue.push(Target);
              HavePushed.insert(Target);
            }
          }
          if (auto *PHI = dyn_cast<PHINode>(Val); PHI &&
            PHI->getNumIncomingValues() == 1) {
            auto *Target = defInstrAnalysis ? PHI->getIncomingValue(0) : Val;
            if (HavePushed.count(Target) == 0) {
              UseQueue.push(Target);
              HavePushed.insert(Target);
            }
          }
        };
        while(!UseQueue.empty()) {
          Value *Elem = UseQueue.front();
          UseQueue.pop();
          // def instr analysis
          CollectMemEquivalenceVar(Elem, true);
          if (!AddToCJVarToLiveIntervalMap) {
            continue;
          }
          // use list analysis
          for (User *U : Elem->users()) {
            CollectMemEquivalenceVar(U, false);
            if (!AddToCJVarToLiveIntervalMap) {
              break;
            }
          }
          if (!AddToCJVarToLiveIntervalMap) {
            break;
          }
        }
        if (!AddToCJVarToLiveIntervalMap) {
          continue;
        }
        for(auto *E : HavePushed) {
          if (!E->getType()->isVoidTy()) {
            CJVarLiveInterval = FunctionVarLifeTimeResult::combineLifeInterval(CJVarLiveInterval, LifeTimeResult.SSAVarToLiveInterval[E]);
            this->CJVarToMemEquivalenceVars[CJVar].insert(E);
          }
        }
        CJVarLiveInterval.first = LifeTimeResult.InstrsToIndex[CJVar];
        CJVarToLiveInterval[CJVar] = CJVarLiveInterval;
#ifndef NDEBUG
        LLVM_DEBUG({
          llvm::dbgs() << *CJVar << "\n";
          llvm::dbgs() << "CJVarLiveInterval = {" << std::to_string(CJVarLiveInterval.first) << ", " << std::to_string(CJVarLiveInterval.second) << "}" << "\n";
        });
#endif
      }
      // remove skip CB in candidateReuseMap
      for (auto *CB: SkipCB) {
        std::remove(VarArr.begin(), VarArr.end(), CB);
      }
    }
    return CJVarToLiveInterval;
  };

  HeapCJVarToLiveInterval = CalculateLiveIntervalForCJVar(HeapVars);
  StackCJVarToLiveInterval = CalculateLiveIntervalForCJVar(StackVar);

  auto SplitNonOverlappingCJVar = [] (CandidateReuseMap &InputMap, ReuseMultiMap &OutputMap, CJVarToLiveIntervalMap &CJVarToLiveInterval) {
    // split the CJ var in the fixed bitsize VarArr by non-Overlapping live interval
    for (auto &[BitSize, VarArr] : InputMap) {
      bool AllCJVarsHaveLiveInterval = true;
      for (auto *CB: VarArr) {
        if (CJVarToLiveInterval.count(CB) == 0) {
          AllCJVarsHaveLiveInterval = false;
          break;
        }
      }
      if (!AllCJVarsHaveLiveInterval) {
        continue;
      }
      InstrLiveIntervalConflictGraph ILICG = InstrLiveIntervalConflictGraph(VarArr, CJVarToLiveInterval);
      SimpleGraphColoring<InstrLiveIntervalConflictGraph *> GraphColoring(&ILICG);
      GraphColoring.color();
      std::vector<SmallVector<CallBase *, 4>> Temp(GraphColoring.getColorNum(), SmallVector<CallBase *, 4>{});
      for (auto &[Node, Color] : GraphColoring.getColorMapRes()) {
        Temp[Color-1].push_back(dyn_cast<CallBase>(Node->getInstr()));
      }
      for(auto &ReuseGroup : Temp) {
        if (ReuseGroup.size() > 1) {
          OutputMap.insert({BitSize, ReuseGroup});
        }
      }
    }
  };

  SplitNonOverlappingCJVar(HeapVars, ReuseHeapVarMap, HeapCJVarToLiveInterval);
  SplitNonOverlappingCJVar(StackVar, ReuseStackVarMap, StackCJVarToLiveInterval);
}

bool CJObjectReuseOpt::transformForMemReuse(DominatorTree &DT, FunctionVarLifeTimeResult &LifeTimeResult) {
    bool Changed = false;

  auto ReplaceUseBetweenCJValLifeTime = [&LifeTimeResult] (Value *Replacee, Value *Replacer, CallBase *CJVar, CJVarToLiveIntervalMap &CJVarLifeTimeMap) -> bool {
    bool ResFlag = false;
    Value * FinalReplacer = Replacer;
    if (Replacer->getType() != Replacee->getType()) {
      IRBuilder<> IRB(CJVar);
      FinalReplacer = IRB.CreateBitCast(getUnderlyingObject(Replacer), Replacee->getType());
    }
    Replacee->replaceUsesWithIf(FinalReplacer, [&ResFlag, &LifeTimeResult, &CJVarLifeTimeMap, &CJVar](Use &U) -> bool {
      auto *Instr = dyn_cast<Instruction>(U.getUser());
        ResFlag = LifeTimeResult.InstrsToIndex[Instr] >= CJVarLifeTimeMap[CJVar].first &&
          LifeTimeResult.InstrsToIndex[Instr] <= CJVarLifeTimeMap[CJVar].second;
        return ResFlag;
    });
    return ResFlag;
  };

  auto MemEquivalenceVarsTypeMatch = [this] (CallBase *ReplaceeCB, CallBase *ReplacerCB) -> bool {
    auto &ReplacerMemEquivalence = this->CJVarToMemEquivalenceVars[ReplacerCB];
    auto &BeReplacedMemEquivalence = this->CJVarToMemEquivalenceVars[ReplaceeCB];
    std::set<Type*> ReplacerTypeSet;
    for (auto *E: ReplacerMemEquivalence) {
      ReplacerTypeSet.insert(E->getType());
    }
    for (auto *V: BeReplacedMemEquivalence) {
      if (ReplacerTypeSet.count(V->getType()) == 0 &&
          !CastInst::castIsValid(Instruction::CastOps::BitCast, getUnderlyingObject(ReplacerCB->getArgOperand(0)), V->getType())) {
        return false;
      }
    }
    return true;
  };

  auto ReplaceValueForReuse = [this, &Changed, &DT, &LifeTimeResult, &MemEquivalenceVarsTypeMatch, &ReplaceUseBetweenCJValLifeTime] (ReuseMultiMap &InputMap, CJVarToLiveIntervalMap &CJVarLifeTimeMap) {
    for (auto &[BitSize, VarArr] : InputMap) {
      std::sort(VarArr.begin(), VarArr.end(), [&LifeTimeResult](CallBase *LHS, CallBase * RHS) {
        return LifeTimeResult.InstrsToIndex[LHS] < LifeTimeResult.InstrsToIndex[RHS]; });
      std::set<size_t> HaveBeenReplacedIndex;
      for (size_t ReplacerIndex = 0; ReplacerIndex < VarArr.size() - 1; ++ReplacerIndex) {
        if (HaveBeenReplacedIndex.count(ReplacerIndex) == 0) {
          for (size_t BeReplacedIndex = ReplacerIndex + 1; BeReplacedIndex < VarArr.size(); ++BeReplacedIndex) {
            auto *ReplacerCB = VarArr[ReplacerIndex];
            auto *BeReplacedCB = VarArr[BeReplacedIndex];
            if (DT.dominates(ReplacerCB->getParent(), BeReplacedCB->getParent()) &&
                HaveBeenReplacedIndex.count(ReplacerIndex) == 0) {
              Value *ReuseAddr = ReplacerCB->getArgOperand(0);
              Value *BeReplacedAddr = BeReplacedCB->getArgOperand(0);

              if (MemEquivalenceVarsTypeMatch(BeReplacedCB, ReplacerCB)) {
                ReplaceUseBetweenCJValLifeTime(BeReplacedAddr, ReuseAddr, BeReplacedCB, CJVarLifeTimeMap);
#ifndef NDEBUG
                LLVM_DEBUG({
                  llvm::dbgs() << "ReplacerCB : " << *ReplacerCB << "\n";
                  llvm::dbgs() << "BeReplacedCB : " << *BeReplacedCB << "\n";
                  llvm::dbgs() << "=================================" << "\n";
                });
#endif
                auto &ReplacerMemEquivalence = this->CJVarToMemEquivalenceVars[ReplacerCB];
                auto &BeReplacedMemEquivalence = this->CJVarToMemEquivalenceVars[BeReplacedCB];
                for (auto *V: BeReplacedMemEquivalence) {
                  if (V == BeReplacedAddr) {
                    continue;
                  }
                  Value *SameTypeEquivalence = nullptr;

                  for (auto *E: ReplacerMemEquivalence) {
                    if (E->getType() == V->getType()) {
                      SameTypeEquivalence = E;
                      break;
                    }
                  }
                  bool AddEtractCast = false;
                  if (SameTypeEquivalence == nullptr) {
                    IRBuilder<> IRB(BeReplacedCB);
                    SameTypeEquivalence = IRB.CreateBitCast(getUnderlyingObject(ReplacerCB->getArgOperand(0)), V->getType());
                    AddEtractCast = true;
                  }
                  bool HaveReplacedUse = ReplaceUseBetweenCJValLifeTime(V, SameTypeEquivalence, BeReplacedCB, CJVarLifeTimeMap);
                  if (AddEtractCast && !HaveReplacedUse) {
                    dyn_cast<Instruction>(SameTypeEquivalence)->eraseFromParent();
                  }
                }
                HaveBeenReplacedIndex.insert(BeReplacedIndex);
                Changed = true;
              }
            }
          }
        }
      }
    }
  };

  ReplaceValueForReuse(ReuseHeapVarMap, HeapCJVarToLiveInterval);
  ReplaceValueForReuse(ReuseStackVarMap, StackCJVarToLiveInterval);

  return Changed;
}
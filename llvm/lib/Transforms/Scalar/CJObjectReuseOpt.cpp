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

#include "llvm/ADT/SetVector.h"
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
#include "llvm/Support/CommandLine.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/Analysis/CaptureTracking.h"
#include "llvm/Transforms/Utils/CJSimpleGraphColoring.h"
#include "llvm/Support/Debug.h"

#include <set>
#include <queue>
#include <iostream>

using namespace llvm;
using namespace llvm::cjObjectReuseOpt;

#define DEBUG_TYPE "cjObjectReuseOpt"

void CJObjectReuseOpt::clear() {
  ReuseHeapVarMap.clear();
  ReuseStackVarMap.clear();
  HeapCJVarToLiveInterval.clear();
  StackCJVarToLiveInterval.clear();
}

bool CJObjectReuseOpt::runImpl(Function &F, FunctionVarLifeTimeResult &LifeTimeResult, AliasAnalysis &AA, MemorySSA &MSSA, DominatorTree &DT, LoopInfo &LI) {
  std::set<std::string>  CanbeOptFunctions {
    "_CNax4Body8toTokensHv",

    // "_CNax10ImportList8toTokensHv",
    // "_CNax10LambdaExpr8toTokensHv",
    // "_CNax10VArrayType8toTokensHv",
    // "_CNax5Block8toTokensHv",

    // "_CNax12ConcatTokensixHRNat5RangeIlE",
    // "_CNax12LitConstExpr8toTokensHv",
    // "_CNax13PackageHeader8toTokensHv",
    // "_CNax14createDeclBaseHRNax5TokenECNax19NodeFormat_DeclBaseE",
    // "_CNax28getOperaterKindOrIdentTokensHiRNax19NodeFormat_PositionECNax6TokensE",


    // "_CNax15MacroExpandDecl10identifierpsHRNax5TokenE",
    // "_CNax15MacroExpandDecl14fullIdentifierpsHRNax5TokenE",
    // "_CNax15MacroExpandDecl8toTokensHv",
    // "_CNax15MacroExpandExpr8toTokensHv",
    // "_CNax16createQuoteTokenHCNax15NodeFormat_ExprE",
    // "_CNax16MacroExpandParam10identifierpsHRNax5TokenE",
    // "_CNax16MacroExpandParam14fullIdentifierpsHRNax5TokenE",
    // "_CNax16MacroExpandParam8toTokensHv",
    // "_CNax17FeaturesDirective8toTokensHv",
    // "_CNax20createArgumentTokensHCNax4DeclE"
    };
  
  // if (!CanbeOptFunctions.count(F.getName().str())) {
  //   return false;
  // }

  // if (F.getName().contains("<init>")) {
  //   return false;
  // } 
  // if (F.getName().contains("String")) {
  //   return false;
  // }
  // if (F.getName().contains("Token")) {
  //   return false;
  // }
  // if (F.getName().contains("create")) {
  //   return false;
  // }

  // if (!F.getName().contains("Token")) {
  //   return false;
  // }
  clear();
  CandidateReuseMap BitSizeToNoEscapeVals;
  SmallPtrSet<const Value *, 32> EphValues;
  EarliestEscapeInfo EI(DT, LI, EphValues);
  BatchAAResults BatchAA(AA, &EI);
  // #ifndef NDEBUG
  // std::cout << "CJObjectReuseOpt::runImpl: " << F.getName().str() << std::endl;
  // LifeTimeResult.print();
  // ///*
  // std::cout << "CJObjectReuseOpt::MemoryLocation: " << std::endl;
  // for (auto &Instr : instructions(F)) {
  //   Instr.dump();
  //   if (MemoryLocation::getOrNone(&Instr) != None) {
  //     std::cout << "OK!" << std::endl;
  //   } else {
  //     std::cout << "Noop!" << std::endl;
  //   }
  //   auto *MA = MSSA.getMemoryAccess(&Instr);
  //   if (!MA) {
  //     std::cout << "Noop Memory!" << std::endl;
  //   }

  //   if (MA && dyn_cast<MemoryDef>(MA)) {
  //     std::cout << "MemoryDef!" << std::endl;
  //   }

  //   if (MA && dyn_cast<MemoryUse>(MA)) {
  //     std::cout << "MemoryUse!" << std::endl;
  //   }
  // }
  // #endif
  //*/

  collectNoEscapeValue(F, BitSizeToNoEscapeVals);
  adjustForReuseByLiveInterval(F, BitSizeToNoEscapeVals, LifeTimeResult, BatchAA, MSSA);

  // std::cout << "CJObjectReuseOpt::ReuseHeapVarMap: " << std::endl;
  // printReuseMultiMap(ReuseHeapVarMap);
  // std::cout << "CJObjectReuseOpt::ReuseStackVarMap: " << std::endl;
  // printReuseMultiMap(ReuseStackVarMap);

  bool Changed = transformForMemReuse(DT, LifeTimeResult);
  // if (Changed) {
  //   std::cout << "CJObjectReuseOpt::changed!: " << F.getName().str() << std::endl;
  // }

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

inline uint64_t CJObjectReuseOpt::getBitSizeFromCJTypeInfoValue(Constant *TypeInfoVal) {
    constexpr unsigned BYTE_SIZE_ELEMENT_INDEX = 4;
    constexpr unsigned BYTE_BIT_WIDTH = 8;
    return TypeInfoVal->getAggregateElement(BYTE_SIZE_ELEMENT_INDEX)->getUniqueInteger().getZExtValue() * BYTE_BIT_WIDTH;
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

inline static uint64_t getBitSize(Value *V, const DataLayout &DL) {
  assert(V->getType()->isPointerTy() && "CJObjectReuseOpt::getBitSize should pass pointerType param.");
  constexpr unsigned BYTE_BIT_WIDTH = 8;

  Type *Ty = V->stripPointerCasts()->getType();
  if (Ty->getNumContainedTypes() == 0) {
    return 0;
  }
  if (!Ty->getNonOpaquePointerElementType()->isSized()) {
    return 0;
  }
  return DL.getTypeAllocSize(Ty->getNonOpaquePointerElementType()) * BYTE_BIT_WIDTH;
}

static bool isDefChainConsistOfCastOrMalloc(Value *V) {
  if(auto *Instr = dyn_cast<Instruction>(V)) {
    // we assume the source is the cj.malloc.object or alloc
    while(!(isa<AllocaInst>(Instr) || isCJMallocObj(Instr))) {
      if (isPointerCastFamily(Instr)) {
        if (const Argument *Arg = dyn_cast<Argument>(Instr->getOperand(0))) {
          return false;
        }
        Instr = dyn_cast<Instruction>(Instr->getOperand(0));
      } else {
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
    if (auto *CB = dyn_cast<CallBase>(&I) /*; CB && !isa<InvokeInst>(&I)*/) {
      Function *Callee = CB->getCalledFunction();
      if (Callee && Callee->getName().contains(CONSTRUCTOR_KEY_WORD) /*&& !Callee->getName().contains("Array")*/) {
        Value *Addr = CB->getArgOperand(0);
        // currently we only collect memory define chain which consists of cast famaliy or cj.malloc.object
        if (!isDefChainConsistOfCastOrMalloc(Addr)) {
          continue;
        }
        auto *TypeInfoArg = CB->getArgOperand(CB->arg_size()-1);
        // case like <init>withoutTI, the bitSize is unknown
        if(!isa<Constant>(TypeInfoArg)) {
          continue;
        }
        // case like: @"std.core:StringBuilder.ti" = external global %TypeInfo, !RelatedType !7 #3
        // we could not get the object size
        if (dyn_cast<Constant>(TypeInfoArg)->getNumOperands() == 0) {
          continue;
        }
        auto &DL = F.getParent()->getDataLayout();
        uint64_t BitSize = getBitSize(Addr, DL);
        if (BitSize == 0) {
          continue;
        }
        uint64_t BitSize_1 = getBitSizeFromCJTypeInfoValue(dyn_cast<Constant>(dyn_cast<Constant>(TypeInfoArg)->getOperand(0)));
        // if (BitSize != BitSize_1) {
        //   std::cout << "different size in CJObjectReuseOpt::collectNoEscapeValue " << F.getName().str() << std::endl;
        //   continue;
        // }

        if (!isHeapZoneValue(Addr) || !PointerMayBeCaptured(Addr, true, true)) {
// #ifndef NDEBUG
//           std::cout << "no escape var hit log start." << std::endl;
//           CB->dump();
//           std::cout << "no escape var hit log end." << std::endl;
// #endif
          if (BitSizeToNoEscapeVals.count(BitSize)) {
            BitSizeToNoEscapeVals[BitSize].push_back(CB);
             LLVM_DEBUG({
                llvm::dbgs() << "no escape CB: " << *CB << "\n";
            });
          } else {
            BitSizeToNoEscapeVals[BitSize] = SmallVector<CallBase *, 4>(1, CB);
             LLVM_DEBUG({
                llvm::dbgs() << "no escape CB: " << *CB << "\n";
            });
          }
        }
      }
    }
  }
}

void CJObjectReuseOpt::adjustForReuseByLiveInterval(Function &F, CandidateReuseMap &BitSizeToNoEscapeVals, FunctionVarLifeTimeResult &LifeTimeResult, BatchAAResults &AARes, MemorySSA &MSSA) {
  CandidateReuseMap HeapVars;
  CandidateReuseMap StackVar;

  for (auto &[BitSize, VarArr] : BitSizeToNoEscapeVals) {
    if (isHeapZoneValue(VarArr[0]->getArgOperand(0))) {
      HeapVars[BitSize] = VarArr;
    } else {
      StackVar[BitSize] = VarArr;
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

        // use AA to get liveinterval
// #ifndef NDEBUG
//         std::cout << "AA start: " << std::endl;
//         CJVar->dump();
//         std::cout << "below alias: " << std::endl;
// #endif
        MemoryLocation CJVarLoc = MemoryLocation(CJVar->getArgOperand(0), LocationSize::precise(BitSize));
        for (auto &Instr : instructions(F)) {
          auto *MA = MSSA.getMemoryAccess(&Instr);
          if (MA && (&Instr != CJVar)) {
            Value *Selector = getPointerOperand(&Instr);
            Selector = Selector != nullptr ? Selector : Instr.getOperand(0);
            if (Selector->getType()->isPointerTy()) {
              continue;
            }
            AliasResult AliasRes = AARes.alias(CJVarLoc, MemoryLocation::getAfter(Selector));
// #ifndef NDEBUG
//             std::cout << "may alias start : " << std::endl;
//             if (AliasRes == AliasResult::MayAlias) {
//               Instr.dump();
//             }
//             std::cout << "may alias end : " << std::endl;
// #endif
            // MayAlias means we couldn't decide whether to replace mem or not,
            // PartialAlias means we should replace mem partly, currently not support.
            if (AliasRes == AliasResult::MayAlias || AliasRes == AliasResult::PartialAlias) {
              AddToCJVarToLiveIntervalMap = false;
              SkipCB.insert(CJVar);
              break;
            }
            if (AliasRes == AliasResult::MustAlias && LifeTimeResult.SSAVarToLiveInterval.count(Selector)) {
// #ifndef NDEBUG
//               std::cout << "AA Combine start : " << std::endl;
//               Selector->dump();
//               std::cout << "AA Combine end : " << std::endl;
// #endif
              if (this->CJVarToMemEquivalenceVars.count(CJVar)) {
                this->CJVarToMemEquivalenceVars[CJVar].insert(Selector);
              } else {
                this->CJVarToMemEquivalenceVars[CJVar] = {Selector};
              }
              CJVarLiveInterval = FunctionVarLifeTimeResult::combineLifeInterval(CJVarLiveInterval, LifeTimeResult.SSAVarToLiveInterval[Selector]); 
            }
          }
        }
        if (!AddToCJVarToLiveIntervalMap) {
          continue;
        }

// #ifndef NDEBUG
        // std::cout << "AA end: " << std::endl;
// #endif

        // extra analysis for CJVar by Instr: 
        // e.g cast instr, getElementPtr instr, Phi, call
        // mimic llvm::getUnderlyingObject for collecting instr
        std::queue<Value*> UseQueue;
        std::set<Value*> HavePushed;
        UseQueue.push(CJVar->getArgOperand(0));
        HavePushed.insert(CJVar->getArgOperand(0));
        while(!UseQueue.empty()) {
          Value *Elem = UseQueue.front();
          UseQueue.pop();
          // use list analysis
          for (User *U : Elem->users()) {
            // currently not support partly replace.
            if (dyn_cast<Instruction>(U)->getOpcode() == Instruction::GetElementPtr) {
              AddToCJVarToLiveIntervalMap = false;
              SkipCB.insert(CJVar);
              break;
            }
            if (auto *Call = dyn_cast<CallBase>(U); Call &&
                !Call->getType()->isVoidTy() &&
                getArgumentAliasingToReturnedPointer(Call, false) != nullptr) {
              AddToCJVarToLiveIntervalMap = false;
              SkipCB.insert(CJVar);
              break;
            }
            if (HavePushed.count(U) == 0 && isPointerCastFamily(U) ) {
              UseQueue.push(U);
              HavePushed.insert(U);
            }
            if (auto *PHI = dyn_cast<PHINode>(U); PHI &&
              PHI->getNumIncomingValues() == 1 &&
              HavePushed.count(U) == 0) {
              UseQueue.push(U);
              HavePushed.insert(U);
            }
          }
          if (!AddToCJVarToLiveIntervalMap) {
            break;
          }
          // def instr analysis
          auto *Instr = dyn_cast<Instruction>(Elem);
          if (Instr->getOpcode() == Instruction::GetElementPtr) {
            AddToCJVarToLiveIntervalMap = false;
            SkipCB.insert(CJVar);
            break;
          }
          if (auto *Call = dyn_cast<CallBase>(Elem); Call &&
              !Call->getType()->isVoidTy() &&
              getArgumentAliasingToReturnedPointer(Call, false) != nullptr) {
            AddToCJVarToLiveIntervalMap = false;
            SkipCB.insert(CJVar);
            break;
          }
          if ((isPointerCastFamily(Elem)) &&
              HavePushed.count(Instr->getOperand(0)) == 0) {
            UseQueue.push(Instr->getOperand(0));
            HavePushed.insert(Instr->getOperand(0));
          }
          if (auto *PHI = dyn_cast<PHINode>(Elem); PHI &&
              PHI->getNumIncomingValues() == 1 &&
              HavePushed.count(PHI->getIncomingValue(0)) == 0) {
            UseQueue.push(PHI->getIncomingValue(0));
            HavePushed.insert( PHI->getIncomingValue(0));
          }
        }
// #ifndef NDEBUG
//         std::cout << "CJObjectReuseOpt::adjustForReuseByLiveInterval start: " << std::endl;
// #endif
        if (!AddToCJVarToLiveIntervalMap) {
          continue;
        }
        for(auto *E : HavePushed) {
          if (!E->getType()->isVoidTy()) {
// #ifndef NDEBUG
//             E->dump();
// #endif
            CJVarLiveInterval = FunctionVarLifeTimeResult::combineLifeInterval(CJVarLiveInterval, LifeTimeResult.SSAVarToLiveInterval[E]);
            if (this->CJVarToMemEquivalenceVars.count(CJVar)) {
              this->CJVarToMemEquivalenceVars[CJVar].insert(E);
            } else {
              this->CJVarToMemEquivalenceVars[CJVar] = {E};
            }
          }
        }
        CJVarLiveInterval.first = LifeTimeResult.InstrsToIndex[CJVar];
        CJVarToLiveInterval[CJVar] = CJVarLiveInterval;
// #ifndef NDEBUG
//         std::cout << "CJObjectReuseOpt::adjustForReuseByLiveInterval end: " << std::endl;
//         CJVar->dump();     
//         std::cout << "CJVarLiveInterval = {" << std::to_string(CJVarLiveInterval.first) << ", " << std::to_string(CJVarLiveInterval.second) << "}" << std::endl;
// #endif           
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
    bool Changed = false;
    Value * FinalReplacer = Replacer;
    if (Replacer->getType() != Replacee->getType()) {
      // return false;
      IRBuilder<> IRB(CJVar);
      FinalReplacer = IRB.CreateBitCast(getUnderlyingObject(Replacer), Replacee->getType());
    }
    Replacee->replaceUsesWithIf(FinalReplacer, [&Changed, &LifeTimeResult, &CJVarLifeTimeMap, &CJVar](Use &U) -> bool {
      auto *Instr = dyn_cast<Instruction>(U.getUser());
// #ifndef NDEBUG
//           std::cout << "ReplaceUseBetweenCJValLifeTime Replacee Instr: " << std::endl;
//           Instr->dump();
//           std::cout << "LifeTimeResult.InstrsToIndex[Instr]: " << std::to_string(LifeTimeResult.InstrsToIndex[Instr]) << std::endl;
//           CJVar->dump();
//           std::cout << "CJVarLifeTimeMap[CJVar].first : " << std::to_string(CJVarLifeTimeMap[CJVar].first) << std::endl;
//           std::cout << "CJVarLifeTimeMap[CJVar].second: " << std::to_string(CJVarLifeTimeMap[CJVar].second) << std::endl;
//           std::cout << "=========================" << std::endl;
// #endif
        Changed = LifeTimeResult.InstrsToIndex[Instr] >= CJVarLifeTimeMap[CJVar].first &&
          LifeTimeResult.InstrsToIndex[Instr] <= CJVarLifeTimeMap[CJVar].second;
        return Changed;
    });
    return Changed;
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
                HaveBeenReplacedIndex.count(ReplacerIndex) == 0 
                /* && ReplacerCB->getArgOperand(ReplacerCB->arg_size()-1) == BeReplacedCB->getArgOperand(BeReplacedCB->arg_size()-1) */ ) {
              Value *ReuseAddr = ReplacerCB->getArgOperand(0);
              Value *BeReplacedAddr = BeReplacedCB->getArgOperand(0);

              if (MemEquivalenceVarsTypeMatch(BeReplacedCB, ReplacerCB)) {
                ReplaceUseBetweenCJValLifeTime(BeReplacedAddr, ReuseAddr, BeReplacedCB, CJVarLifeTimeMap);
#ifndef NDEBUG
                std::cout << "ReplacerCB: " << std::endl;
                ReplacerCB->dump();
                std::cout << "BeReplacedCB: " << std::endl;
                BeReplacedCB->dump();
                std::cout << "=========================" << std::endl;
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

class llvm::cjObjectReuseOpt::CJObjectReuseOptLegacyPass : public FunctionPass {

  CJObjectReuseOpt Impl;

public:
  static char ID;

  CJObjectReuseOptLegacyPass() : FunctionPass(ID) {
    initializeCJObjectReuseOptLegacyPassPass(*PassRegistry::getPassRegistry());
  }

  bool runOnFunction(Function &F) override {
    if (skipFunction(F))
      return false;
    // return Impl.runImpl(F); // todo analysis legacy pass
    return false;
  }

  StringRef getPassName() const override { return "CJObjectReuseOpt"; }
};

char CJObjectReuseOptLegacyPass::ID = 0;

FunctionPass *llvm::createCJObjectReuseOptPass() { return new CJObjectReuseOptLegacyPass(); }

INITIALIZE_PASS_BEGIN(CJObjectReuseOptLegacyPass, "CJObjectReuseOpt",
                      "Cangjie Object Reuse optimization", false, false)
INITIALIZE_PASS_END(CJObjectReuseOptLegacyPass, "CJObjectReuseOpt", "Cangjie Object Reuse optimization",
                    false, false)
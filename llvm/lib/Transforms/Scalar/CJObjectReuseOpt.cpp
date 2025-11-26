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
#include "llvm/Analysis/PostDominators.h"
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
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/Analysis/CaptureTracking.h"
#include "llvm/Transforms/Utils/CJSimpleGraphColoring.h"
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
  clear();
  CandidateReuseMap BitSizeToNoEscapeVals;
  SmallPtrSet<const Value *, 32> EphValues;
  EarliestEscapeInfo EI(DT, LI, EphValues);
  BatchAAResults BatchAA(AA, &EI);
  std::cout << "CJObjectReuseOpt::runImpl: " << F.getName().str() << std::endl;
  LifeTimeResult.print();
  ///*
  std::cout << "CJObjectReuseOpt::MemoryLocation: " << std::endl;
  for (auto &Instr : instructions(F)) {
    Instr.dump();
    if (MemoryLocation::getOrNone(&Instr) != None) {
      std::cout << "OK!" << std::endl;
    } else {
      std::cout << "Noop!" << std::endl;
    }
    auto *MA = MSSA.getMemoryAccess(&Instr);
    if (!MA) {
      std::cout << "Noop Memory!" << std::endl;
    }

    if (MA && dyn_cast<MemoryDef>(MA)) {
      std::cout << "MemoryDef!" << std::endl;
    }

    if (MA && dyn_cast<MemoryUse>(MA)) {
      std::cout << "MemoryUse!" << std::endl;
    }
  }
  //*/
  collectNoEscapeValue(F, BitSizeToNoEscapeVals);
  adjustForReuseByLiveInterval(F, BitSizeToNoEscapeVals, LifeTimeResult, BatchAA, MSSA);

  std::cout << "CJObjectReuseOpt::ReuseHeapVarMap: " << std::endl;
  printReuseMultiMap(ReuseHeapVarMap);
  std::cout << "CJObjectReuseOpt::ReuseStackVarMap: " << std::endl;
  printReuseMultiMap(ReuseStackVarMap);

  return transformForMemReuse(LifeTimeResult);
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

void CJObjectReuseOpt::collectNoEscapeValue(Function &F, CandidateReuseMap &BitSizeToNoEscapeVals) {
  constexpr StringRef CONSTRUCTOR_KEY_WORD = "<init>";
  for (auto &I : instructions(F)) {
    if (auto *CB = dyn_cast<CallBase>(&I)) {
      Function *Callee = CB->getCalledFunction();
      if (Callee && Callee->getName().contains(CONSTRUCTOR_KEY_WORD)) {
        Value *Addr = CB->getArgOperand(0);
        auto *TypeInfoArg = CB->getArgOperand(CB->arg_size()-1);
        assert(isa<Constant>(TypeInfoArg));
        Constant *ObjTypeInfo = cast<Constant>(cast<Constant>(TypeInfoArg)->getOperand(0));
        uint64_t BitSize = getBitSizeFromCJTypeInfoValue(ObjTypeInfo);
        std::cout << "CJObjectReuseOpt: " << F.getName().str() << " " <<  std::to_string(BitSize) << std::endl;
        if (!isHeapZoneValue(Addr) || !PointerMayBeCaptured(Addr, true, true)) {
          if (BitSizeToNoEscapeVals.count(BitSize)) {
            BitSizeToNoEscapeVals[BitSize].push_back(CB);
          } else {
            BitSizeToNoEscapeVals[BitSize] = SmallVector<CallBase *, 4>(1, CB);
          }
        }
      }
    }
  }
}

bool CJObjectReuseOpt::isPointerCastFamily(Value *Val) {
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
  auto CalculateLiveIntervalForCJVar = [&F, &LifeTimeResult, &AARes, &MSSA] (CandidateReuseMap &InputMap) -> CJVarToLiveIntervalMap {
    CJVarToLiveIntervalMap CJVarToLiveInterval;
    for (auto &[BitSize, VarArr] : InputMap) {
      for (auto *CJVar : VarArr) {
        FunctionVarLifeTimeResult::LiveInterval CJVarLiveInterval = LifeTimeResult.SSAVarToLiveInterval[CJVar->getArgOperand(0)];

        // use AA to get liveinterval
        std::cout << "AA start: " << std::endl;
        CJVar->dump();
        std::cout << "below alias: " << std::endl;
        MemoryLocation CJVarLoc = MemoryLocation(CJVar->getArgOperand(0), LocationSize::precise(BitSize));
        for (auto &Instr : instructions(F)) {
          auto *MA = MSSA.getMemoryAccess(&Instr);
          if (MA && (&Instr != CJVar)) {
            Value *Selector = dyn_cast<MemoryUse>(MA) ? MA->getMemoryInst() : Instr.getOperand(0);
            assert(Selector->getType()->isPointerTy() && "illegal type for memory asscce selector in CJObjectReuseOpt!");
            AliasResult AliasRes = AARes.alias(CJVarLoc, MemoryLocation::getAfter(Selector));
            std::cout << "may alias start : " << std::endl;
            if (AliasRes == AliasResult::MayAlias) {
              Instr.dump();
            }
            std::cout << "may alias end : " << std::endl;
            if (AliasRes != AliasResult::NoAlias && LifeTimeResult.SSAVarToLiveInterval.count(Selector)) {
              std::cout << "AA Combine start : " << std::endl;
              Selector->dump();
              std::cout << "AA Combine end : " << std::endl;
              CJVarLiveInterval = FunctionVarLifeTimeResult::combineLifeInterval(CJVarLiveInterval, LifeTimeResult.SSAVarToLiveInterval[Selector]); 
            }
          }
        }
        std::cout << "AA end: " << std::endl;

        // extra analysis for CJVar by Instr: 
        // e.g cast instr, getElementPtr instr,
        
        // not mem instr
        std::queue<Value*> UseQueue;
        std::set<Value*> HavePushed;
        UseQueue.push(CJVar->getArgOperand(0));
        HavePushed.insert(CJVar->getArgOperand(0));
        while(!UseQueue.empty()) {
          Value *Elem = UseQueue.front();
          UseQueue.pop();
          for (User *U : Elem->users()) {
            if (HavePushed.count(U) == 0 &&
                (/* U->getType()->isVoidTy() || */
                isPointerCastFamily(U) ||
                dyn_cast<Instruction>(U)->getOpcode() == Instruction::GetElementPtr)) {
              UseQueue.push(U);
              HavePushed.insert(U);
            }
          }
          auto *Instr = dyn_cast<Instruction>(Elem);
          if ((isPointerCastFamily(Elem) ||
              Instr->getOpcode() == Instruction::GetElementPtr) &&
              HavePushed.count(Instr->getOperand(0)) == 0) {
            UseQueue.push(Instr->getOperand(0));
            HavePushed.insert(Instr->getOperand(0));
          }
            /*
            case Instruction::Call: {
              auto *CI = cast<CallBase>(Instr);
              auto IID = CI->getIntrinsicID();
              if ((IID == Intrinsic::memcpy ||
                  IID == Intrinsic::memcpy_inline ||
                  IID == Intrinsic::memcpy_element_unordered_atomic ||
                  IID == Intrinsic::memmove ||
                  IID == Intrinsic::memmove_element_unordered_atomic) &&
                  HavePushed.count(Instr->getOperand(0)) == 0) {
                  UseQueue.push(Instr->getOperand(0));
                  HavePushed.insert(Instr->getOperand(0));
                }
              break;
            }
            */
        }
        std::cout << "CJObjectReuseOpt::adjustForReuseByLiveInterval start: " << std::endl;
        for(auto *E : HavePushed) {
          if (!E->getType()->isVoidTy()) {
            E->dump();
            CJVarLiveInterval = FunctionVarLifeTimeResult::combineLifeInterval(CJVarLiveInterval, LifeTimeResult.SSAVarToLiveInterval[E]);
          }
        }
        CJVarLiveInterval.first = LifeTimeResult.InstrsToIndex[CJVar];
        CJVarToLiveInterval[CJVar] = CJVarLiveInterval;
        std::cout << "CJObjectReuseOpt::adjustForReuseByLiveInterval end: " << std::endl;
        CJVar->dump();
        std::cout << "CJVarLiveInterval = {" << std::to_string(CJVarLiveInterval.first) << ", " << std::to_string(CJVarLiveInterval.second) << "}" << std::endl;
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

bool CJObjectReuseOpt::transformForMemReuse(FunctionVarLifeTimeResult &LifeTimeResult) {
  bool Changed = false;

  auto ReplaceUseBetweenCJValLifeTime = [&LifeTimeResult, &Changed] (Value *Replacee, Value *Replacer, CallBase *CJVar, CJVarToLiveIntervalMap &CJVarLifeTimeMap) {
    for (User *U : Replacee->users()) {
      auto *Instr = dyn_cast<Instruction>(U);
      if (LifeTimeResult.InstrsToIndex[Instr] >= CJVarLifeTimeMap[CJVar].first &&
          LifeTimeResult.InstrsToIndex[Instr] <= CJVarLifeTimeMap[CJVar].second) {
        for (unsigned Index = 0; Index < Instr->getNumOperands(); ++Index) {
          if (Instr->getOperand(Index) == Replacee) {
            Instr->setOperand(Index, Replacer);
            Changed = true;
          }
        }
      }
    }
  };

  auto ReplaceValueForReuse = [&LifeTimeResult, &ReplaceUseBetweenCJValLifeTime] (ReuseMultiMap &InputMap, CJVarToLiveIntervalMap &CJVarLifeTimeMap) {
    for (auto &[BitSize, VarArr] : InputMap) {
      std::sort(VarArr.begin(), VarArr.end(), [&LifeTimeResult](CallBase *LHS, CallBase * RHS) {
        return LifeTimeResult.InstrsToIndex[LHS] < LifeTimeResult.InstrsToIndex[RHS]; });
      auto It = VarArr.begin();
      Value *ReuseAddr = (*It)->getArgOperand(0);
      while (++It != VarArr.end()) {
        Value *BeReplaced = (*It)->getArgOperand(0);
        // need to check whether the addr operand is definded by cast
        // consider {replacer is definded by cast, replacer is definded by cast} pair
        // {true, true}, {true, false}, {false, false}, the transform is allowed
        // while {false, true} is not allowed
        bool ReuseAddrFromCast = isPointerCastFamily(ReuseAddr);
        bool BeReplacedFromCast = isPointerCastFamily(BeReplaced);
        if (!ReuseAddrFromCast && ReuseAddrFromCast) {
          continue;
        } 
        // while {true, true}, extra replace cast instr operand
        if (ReuseAddrFromCast && ReuseAddrFromCast) {
          auto *ReplacerCastOperand = dyn_cast<Instruction>(ReuseAddr)->getOperand(0);
          auto *ReplaceeCastOperand = dyn_cast<Instruction>(BeReplaced)->getOperand(0);
          ReplaceUseBetweenCJValLifeTime(ReplaceeCastOperand, ReplacerCastOperand, *It, CJVarLifeTimeMap);
        }
        ReplaceUseBetweenCJValLifeTime(BeReplaced, ReuseAddr, *It, CJVarLifeTimeMap);
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
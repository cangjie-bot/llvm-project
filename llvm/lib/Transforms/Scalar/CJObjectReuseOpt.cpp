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

bool CJObjectReuseOpt::runImpl(Function &F, FunctionVarLifeTimeResult &LifeTimeResult, CJAAResult &CJAARes) {
  clear();
  CandidateReuseMap BitSizeToNoEscapeVals;
  std::cout << "CJObjectReuseOpt::runImpl: " << F.getName().str() << std::endl;
  LifeTimeResult.print();
  /*
  std::cout << "CJObjectReuseOpt::MemoryLocation: " << std::endl;
  for (auto &Instr : instructions(F)) {
    Instr.dump();
    if (MemoryLocation::getOrNone(&Instr) != None) {
      std::cout << "OK!" << std::endl;
    } else {
      std::cout << "Noop!" << std::endl;
    }
  }
  */
  collectNoEscapeValue(F, BitSizeToNoEscapeVals);
  adjustForReuseByLiveInterval(F, BitSizeToNoEscapeVals, LifeTimeResult, CJAARes);

  std::cout << "CJObjectReuseOpt::ReuseHeapVarMap: " << std::endl;
  printReuseMultiMap(ReuseHeapVarMap);
  std::cout << "CJObjectReuseOpt::ReuseStackVarMap: " << std::endl;
  printReuseMultiMap(ReuseStackVarMap);

  return transformForMemReuse(LifeTimeResult);
}

PreservedAnalyses CJObjectReuseOpt::run(Function &F, FunctionAnalysisManager &FAM) {
  auto &LifeTimeResult = FAM.getResult<CJFunctionVarLifeTime>(F);
  auto &CJAARes = FAM.getResult<CangjieAA>(F);
  if (runImpl(F, LifeTimeResult, CJAARes)) {
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

void CJObjectReuseOpt::adjustForReuseByLiveInterval(Function &F, CandidateReuseMap &BitSizeToNoEscapeVals, FunctionVarLifeTimeResult &LifeTimeResult, CJAAResult &CJAARes) {
  CandidateReuseMap HeapVars;
  CandidateReuseMap StackVar;
  SimpleAAQueryInfo AAQIP;

  for (auto &[BitSize, VarArr] : BitSizeToNoEscapeVals) {
    if (isHeapZoneValue(VarArr[0]->getArgOperand(0))) {
      HeapVars[BitSize] = VarArr;
    } else {
      StackVar[BitSize] = VarArr;
    }
  }

  // Note in SSA form, one CJ var can map to multiple SSA vars
  auto CalculateLiveIntervalForCJVar = [&F, &LifeTimeResult, &CJAARes, &AAQIP] (CandidateReuseMap &InputMap) -> CJVarToLiveIntervalMap {
    CJVarToLiveIntervalMap CJVarToLiveInterval;
    for (auto &[BitSize, VarArr] : InputMap) {
      for (auto *CJVar : VarArr) {
        FunctionVarLifeTimeResult::LiveInterval CJVarLiveInterval = LifeTimeResult.SSAVarToLiveInterval[CJVar->getArgOperand(0)];
        // use AA to get liveinterval
        if (MemoryLocation::getOrNone(dyn_cast<Instruction>(CJVar->getArgOperand(0))) != None) {
          for (auto &Instr : instructions(F)) {
            if (MemoryLocation::getOrNone(&Instr) != None && (&Instr != CJVar)) {
              AliasResult AliasRes = CJAARes.alias(MemoryLocation::get(dyn_cast<Instruction>(CJVar->getArgOperand(0))), MemoryLocation::get(&Instr), AAQIP); // todo we need find the source mem def
              if (AliasRes != AliasResult::NoAlias && getLoadStorePointerOperand(&Instr)) {
                CJVarLiveInterval = FunctionVarLifeTimeResult::combineLifeInterval(CJVarLiveInterval, LifeTimeResult.SSAVarToLiveInterval[getLoadStorePointerOperand(&Instr)]);
              }
            }
          }
        }
        // extra SSA analysis by Instr: 
        // e.g addrspacecast, bitcast, llvm.memcpy
        // TODO: #KEYPOINT# more case should be considered! 
        // we should anlysis the live interval, 
        // missing optimazation chance is better than causing error
        std::queue<Value*> UseQueue;
        std::set<Value*> HavePushed;
        UseQueue.push(CJVar->getArgOperand(0));
        HavePushed.insert(CJVar->getArgOperand(0));
        while(!UseQueue.empty()) {
          Value *Elem = UseQueue.front();
          UseQueue.pop();
          for (User *U : Elem->users()) {
            if (HavePushed.count(U) == 0 &&
                (U->getType()->isVoidTy() ||
                dyn_cast<Instruction>(U)->getOpcode() == Instruction::AddrSpaceCast ||
                dyn_cast<Instruction>(U)->getOpcode() == Instruction::BitCast)) {
              UseQueue.push(U);
              HavePushed.insert(U);
            }
          }
          auto *Instr = dyn_cast<Instruction>(Elem);
          switch(Instr->getOpcode()) {
            case Instruction::AddrSpaceCast: 
            case Instruction::BitCast: {
              if (HavePushed.count(Instr->getOperand(0)) == 0) {
                UseQueue.push(Instr->getOperand(0));
                HavePushed.insert(Instr->getOperand(0));
              }
              break;
            }
            case Instruction::Call: {
              auto *CI = cast<CallBase>(Instr);
              auto IID = CI->getIntrinsicID();
              if (IID == Intrinsic::memcpy &&
                  HavePushed.count(Instr->getOperand(0)) == 0) {
                  UseQueue.push(Instr->getOperand(0));
                  HavePushed.insert(Instr->getOperand(0));
                }
              break;
            }
            default:
              break;
          }
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

  auto ReplaceValueForReuse = [&LifeTimeResult, &Changed] (ReuseMultiMap &InputMap) {
    for (auto &[BitSize, VarArr] : InputMap) {
      std::sort(VarArr.begin(), VarArr.end(), [&LifeTimeResult](CallBase *LHS, CallBase * RHS) {
        return LifeTimeResult.InstrsToIndex[LHS] < LifeTimeResult.InstrsToIndex[RHS]; });
      auto It = VarArr.begin();
      Value *ReuseAddr = (*It)->getArgOperand(0);
      while (++It != VarArr.end()) {
        Value *BeReplaced = (*It)->getArgOperand(0);
        for (User *U : BeReplaced->users()) {
          auto *Instr = dyn_cast<Instruction>(U);
          if (LifeTimeResult.InstrsToIndex[Instr] >= LifeTimeResult.InstrsToIndex[*It]) {
            for (unsigned Index = 0; Index < Instr->getNumOperands(); ++Index) {
              if (Instr->getOperand(Index) == BeReplaced) {
                Instr->setOperand(Index, ReuseAddr);
                Changed = true;
              }
            }
          }
        }
      }
    }
  };

  ReplaceValueForReuse(ReuseHeapVarMap);
  ReplaceValueForReuse(ReuseStackVarMap);
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
//===- CJFunctionVarLifeTime.cpp -
//----------------------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===-----------------------------------------------------------------------------------===//
//
// This file provides interface to "Cangjie intra-function variable life time
// analysis" pass.
//
// Through RPO travel CFG to index insrtruction and analysis the def index and
//  the lastes use index for each SSA var.
//===-----------------------------------------------------------------------------------===//

#include "llvm/Analysis/CJFunctionVarLifeTime.h"

#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"

using namespace llvm;

AnalysisKey CJFunctionVarLifeTime::Key;

FunctionVarLifeTimeResult
CJFunctionVarLifeTime::run(Function &F, FunctionAnalysisManager &FAM) {
  FunctionVarLifeTimeResult Res = FunctionVarLifeTimeResult();
  auto &AA = FAM.getResult<AAManager>(F);
  auto &DT = FAM.getResult<DominatorTreeAnalysis>(F);
  auto &LI = FAM.getResult<LoopAnalysis>(F);
  SmallPtrSet<const Value *, 32> EphValues;
  EarliestEscapeInfo EI(DT, LI, EphValues);
  BatchAAResults BatchAA(AA, &EI);
  linerByRPOT(F, Res);
  analysisLiveInterval(F, Res, BatchAA);
  return Res;
}

void CJFunctionVarLifeTime::linerByRPOT(
    Function &F, FunctionVarLifeTimeResult &LifeTimeResult) {
  BasicBlock *Entry = &F.front();
  ReversePostOrderTraversal<BasicBlock *> RPOT(Entry);
  uint64_t BasicBlockIndex = 0;
  uint64_t InstructionIndex = 0;
  for (BasicBlock *BB : RPOT) {
    LifeTimeResult.BasicBlocksToIndex[BB] = BasicBlockIndex++;
    for (Instruction &Instr : BB->getInstList()) {
      LifeTimeResult.InstrsToIndex[&Instr] = InstructionIndex++;
    }
  }
}

void CJFunctionVarLifeTime::analysisLiveInterval(
    Function &F, FunctionVarLifeTimeResult &LifeTimeResult,
    BatchAAResults &AA) {
  for (auto &Instr : instructions(F)) {
    if (Instr.getType()->isPointerTy()) {
      uint64_t LiveStart = LifeTimeResult.InstrsToIndex[&Instr];
      uint64_t LiveEnd = 0;
      SmallVector<Instruction *, 4> UsesCollected;
      for (User *U : Instr.users()) {
        UsesCollected.push_back(dyn_cast<Instruction>(U));
      }
      std::sort(UsesCollected.begin(), UsesCollected.end(),
                [&LifeTimeResult](Instruction *LHS, Instruction *RHS) {
                  return LifeTimeResult.InstrsToIndex[LHS] <
                         LifeTimeResult.InstrsToIndex[RHS];
                });
      for (int I = UsesCollected.size() - 1; I >= 0; --I) {
        auto MRI = AA.getModRefInfo(UsesCollected[I],
                                    MemoryLocation::getAfter(&Instr));
        if (static_cast<int>(MRI) & static_cast<int>(ModRefInfo::Ref)) {
          LiveEnd = LifeTimeResult.InstrsToIndex[UsesCollected[I]];
          break;
        }
      }
      if (LiveStart < LiveEnd) {
        LifeTimeResult.SSAVarToLiveInterval[&Instr] = {LiveStart, LiveEnd};
      }
    }
  }
}

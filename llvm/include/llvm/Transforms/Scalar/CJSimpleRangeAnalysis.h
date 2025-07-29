//===- CJSimpleRangeAnalysis.h - --------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file provides interface to "CJ Simple Range Analysis" pass.
//
// This pass implements simple range analysis for integers and floats whose
// values are integers, and optimizes CFG based on the analysis result.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_TRANSFORMS_SCALAR_CJSIMPLERANGEANALYSIS_H
#define LLVM_TRANSFORMS_SCALAR_CJSIMPLERANGEANALYSIS_H

#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/ConstantRange.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/PassManager.h"

namespace llvm {
struct CJSimpleRangeAnalysisPass
    : public PassInfoMixin<CJSimpleRangeAnalysisPass> {
  LoopInfo *LI;

  enum ConditionResult : uint64_t { FALSE = 0, TRUE = 1, UNKNOWN = 2 };

  // Record constant range of condition in each BB terminator.
  // pair:
  //  - 0: false branch range
  //  - 1: true branch range
  // Currently, only BBs with a single predecessor are recorded, because of the
  // combinatorial explosion that occurs when there are multiple predecessors
  // and multiple successors.
  struct TermCR {
    ConstantRange TCR = ConstantRange::getFull(64);
    ConstantRange FCR = ConstantRange::getFull(64);
  };
  DenseMap<BasicBlock *, DenseMap<Value *, TermCR>> BBValueCRs;

  struct ConditionState {
    Value *BV;                // base value
    APInt Diff;               // difference from base value
    CmpInst::Predicate Pred;  // cmp predicate
    ConditionResult PredCR;   // cmp predicate result to succ, determine whether
                              // ConstantRage needs to be inverted.
    int64_t CI;               // cmp constant integer compare value
    BasicBlock *BB = nullptr; // BB to which this condition state belongs
  };

  std::pair<bool, int64_t> getValidConstantInteger(Value *V);

  Value *getRangeFromInitValue(Value *V, APInt &APValue,
                               SmallSet<Value *, 8> &Visited);

  std::pair<Value *, int64_t> checkAndGetConditionBaseDiff(BranchInst *BI,
                                                           APInt &Diff);

  ConditionState findMostRecentConditionBr(BasicBlock *BB, BasicBlock *Succ);

  std::pair<ConstantRange, ConstantRange> getCRs(const ConditionState &Prev,
                                                 const ConditionState &Curr);

  void rewriteUses(BasicBlock *BB, BasicBlock *NewBB,
                   DenseMap<Instruction *, Instruction *> &InstMapping);

  void createJumpBB(BasicBlock *Pred, BasicBlock *BB, BasicBlock *Succ);

  ConditionResult getConditionResult(const ConditionState &Prev,
                                     const ConditionState &Curr);

  void updateBBValueCRs(BasicBlock *BB,
                        MapVector<BasicBlock *, ConditionState> &PredInfo,
                        ConditionState &CurrCS);

  bool processBasicBlock(BasicBlock &BB);
  bool simplifyBinaryInst(Function &F);
  bool runImpl(Function &F, LoopInfo &LI, DominatorTree &DT);

  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};
} // namespace llvm

#endif
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
//===-----------------------------------------------------------------------------------===//

#ifndef LLVM_ANALYSIS_CJFUNCTIONVARLIFETIME_H
#define LLVM_ANALYSIS_CJFUNCTIONVARLIFETIME_H

#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"

namespace llvm {

struct FunctionVarLifeTimeResult {
public:
  using LiveInterval = std::pair<uint64_t, uint64_t>;
  FunctionVarLifeTimeResult() = default;
  SmallDenseMap<BasicBlock *, uint64_t, 8> BasicBlocksToIndex;
  SmallDenseMap<Instruction *, uint64_t, 32> InstrsToIndex;
  SmallDenseMap<Value *, LiveInterval, 32> SSAVarToLiveInterval;

  static LiveInterval combineLifeInterval(LiveInterval &LHS,
                                          LiveInterval &RHS) {
    return {std::min(LHS.first, RHS.first), std::max(LHS.second, RHS.second)};
  }

  static bool overlapLifeInterval(LiveInterval &LHS, LiveInterval &RHS) {
    return std::max(LHS.first, RHS.first) < std::min(LHS.second, RHS.second);
  }
};

class CJFunctionVarLifeTime : public AnalysisInfoMixin<CJFunctionVarLifeTime> {
  friend AnalysisInfoMixin<CJFunctionVarLifeTime>;
  static AnalysisKey Key;

public:
  using Result = FunctionVarLifeTimeResult;
  FunctionVarLifeTimeResult run(Function &F, FunctionAnalysisManager &AM);

private:
  void linerByRPOT(Function &F, FunctionVarLifeTimeResult &LifeTimeResult);
  void analysisLiveInterval(Function &F,
                            FunctionVarLifeTimeResult &LifeTimeResult);
};

} // namespace llvm

#endif
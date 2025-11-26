//===- CJObjectReuseOpt.h - -----------------------------------------*- C++ -*-===//
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
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_CJ_OBJECT_REUSE_OPT_H
#define LLVM_TRANSFORMS_CJ_OBJECT_REUSE_OPT_H

#include "llvm/InitializePasses.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/ValueHandle.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/Analysis/MemorySSA.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/CJFunctionVarLifeTime.h"
#include <map>

namespace llvm {

class CJObjectReuseOpt : public PassInfoMixin<CJObjectReuseOpt> {
public:
  CJObjectReuseOpt() = default;
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
private:
  using CandidateReuseMap = SmallDenseMap<uint64_t, SmallVector<CallBase *, 4>>;
  using ReuseMultiMap = std::multimap<uint64_t, SmallVector<CallBase *, 4>>;
  using CJVarToLiveIntervalMap = SmallDenseMap<Value *, FunctionVarLifeTimeResult::LiveInterval, 16>;
  using CJVarToMemEquivalenceVarsMap = SmallDenseMap<Value *, std::set<Value *>>;
  void collectNoEscapeValue(Function &F, CandidateReuseMap &BitSizeToNoEscapeVals);
  void adjustForReuseByLiveInterval(Function &F, CandidateReuseMap &BitSizeToNoEscapeVals, FunctionVarLifeTimeResult &LifeTimeResult, BatchAAResults &AARes, MemorySSA &MSSA);
  bool transformForMemReuse(DominatorTree &DT, FunctionVarLifeTimeResult &LifeTimeResult);
  bool isHeapZoneValue(Value *Val);
  void collectMemEquivalenceVar(Value *Val);
  bool runImpl(Function &F, FunctionVarLifeTimeResult &LifeTimeResult, AliasAnalysis &AA, MemorySSA &MSSA, DominatorTree &DT, LoopInfo &LI);
  void clearMap();

  ReuseMultiMap ReuseHeapVarMap;
  ReuseMultiMap ReuseStackVarMap;
  CJVarToLiveIntervalMap HeapCJVarToLiveInterval;
  CJVarToLiveIntervalMap StackCJVarToLiveInterval;
  CJVarToMemEquivalenceVarsMap CJVarToMemEquivalenceVars;
};

} // end namespace llvm

#endif // LLVM_TRANSFORMS_CJ_OBJECT_REUSE_OPT_H

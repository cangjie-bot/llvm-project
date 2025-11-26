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
//
// This pass will optimize the scene where intra-function heap objects are 
// non-overlappping live range and no escaping. Reuse the allocated memory
// of dead object to reduce the frequency of memory management overhead.
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_CJ_OBJECT_REUSE_OPT_H
#define LLVM_TRANSFORMS_CJ_OBJECT_REUSE_OPT_H

#include "llvm/InitializePasses.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/PassManager.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/IR/ValueHandle.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/Analysis/MemorySSA.h"
#include "llvm/Analysis/CJAliasAnalysis.h"
#include "llvm/Analysis/CJFunctionVarLifeTime.h"
#include <iostream>
#include <vector>
#include <map>

namespace llvm {

namespace cjObjectReuseOpt LLVM_LIBRARY_VISIBILITY {

class CJObjectReuseOptLegacyPass;

} // end namespace cjObjectReuseOpt

class CJObjectReuseOpt : public PassInfoMixin<CJObjectReuseOpt> {
public:
  CJObjectReuseOpt() = default;
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
private:
  friend class cjObjectReuseOpt::CJObjectReuseOptLegacyPass;
  using CandidateReuseMap = SmallDenseMap<uint64_t, SmallVector<CallBase *, 4>, 4>;
  using ReuseMultiMap = std::multimap<uint64_t, SmallVector<CallBase *, 4>>;
  using CJVarToLiveIntervalMap = SmallDenseMap<Value*, FunctionVarLifeTimeResult::LiveInterval, 16>;
  uint64_t getBitSizeFromCJTypeInfoValue(Constant *TypeInfoVal);
  void collectNoEscapeValue(Function &F, CandidateReuseMap &BitSizeToNoEscapeVals);
  void adjustForReuseByLiveInterval(Function &F, CandidateReuseMap &BitSizeToNoEscapeVals, FunctionVarLifeTimeResult &LifeTimeResult, CJAAResult &CJAARes, MemorySSA &MSSA);
  bool transformForMemReuse(FunctionVarLifeTimeResult &LifeTimeResult);
  bool isHeapZoneValue(Value *Val);
  bool runImpl(Function &F, FunctionVarLifeTimeResult &LifeTimeResult, CJAAResult &CJAARes, MemorySSA &MSSA);
  static bool isPointerCastFamily(Value *Val);
  void clear();
  void printReuseMultiMap(ReuseMultiMap &map) {
    for (auto &[Bitsize, Arr] : map) {
      std::cout << "ReuseMultiMap BitSize: " << std::to_string(Bitsize) << " " << std::endl;
      for (auto E : Arr) {
        E->dump();
      }
    }
  }

  ReuseMultiMap ReuseHeapVarMap;
  ReuseMultiMap ReuseStackVarMap;
  CJVarToLiveIntervalMap HeapCJVarToLiveInterval;
  CJVarToLiveIntervalMap StackCJVarToLiveInterval;
};

} // end namespace llvm

#endif // LLVM_TRANSFORMS_CJ_OBJECT_REUSE_OPT_H

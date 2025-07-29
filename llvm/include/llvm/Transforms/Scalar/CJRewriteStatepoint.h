//===- CJRewriteStatepoint.h - ----------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file provides interface to "Cangjie Rewrite Statepoints" pass.
//
// This passe rewrites call/invoke instructions so as to make potential
// relocations performed by the cangjie garbage collector explicit in the IR.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_SCALAR_CJREWRITESTATEPOINT_H
#define LLVM_TRANSFORMS_SCALAR_CJREWRITESTATEPOINT_H

#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/IR/PassManager.h"

namespace llvm {

class DominatorTree;
class PostDominatorTree;
class Function;
class Module;
class TargetTransformInfo;
class TargetLibraryInfo;

struct CJRewriteStatepoint : public PassInfoMixin<CJRewriteStatepoint> {
  CJRewriteStatepoint(unsigned OptLevel = 0) : OptLevel(OptLevel) {};
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);

  bool runOnFunction(Function &F, DominatorTree &, PostDominatorTree &,
                     TargetTransformInfo &, const TargetLibraryInfo &);
  unsigned OptLevel;
};

} // namespace llvm

using namespace llvm;

#endif // LLVM_TRANSFORMS_SCALAR_CJREWRITESTATEPOINT_H
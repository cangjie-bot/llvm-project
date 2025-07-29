//===- CJDevirtualOpt.h - ---------------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file provides interface to "CJ Devirtual Optimization" pass.
//
// This pass converts cj virtual call into direct call if possible.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_TRANSFORMS_SCALAR_CJDEVIRTUALOPT_H
#define LLVM_TRANSFORMS_SCALAR_CJDEVIRTUALOPT_H

#include "llvm/Analysis/CGSCCPassManager.h"
#include "llvm/IR/PassManager.h"
namespace llvm {
class Function;

struct CJDevirtualOpt : public PassInfoMixin<CJDevirtualOpt> {
  PreservedAnalyses run(LazyCallGraph::SCC &C, CGSCCAnalysisManager &AM,
                        LazyCallGraph &CG, CGSCCUpdateResult &UR) const;
};
} // namespace llvm

#endif // LLVM_TRANSFORMS_SCALAR_CJ_DEVIRTUAL_OPT_H

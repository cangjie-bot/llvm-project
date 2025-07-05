//===- CJLoopFloatOpt.h - ---------------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file provides interface to "CJ Loop Float Optimization" pass.
//
// This pass optimizes the scene where a top-level loop only involves
// straightforward floating-point computations.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_TRANSFORMS_SCALAR_CJLOOPFLOATOPT_H
#define LLVM_TRANSFORMS_SCALAR_CJLOOPFLOATOPT_H

#include "llvm/IR/PassManager.h"
namespace llvm {
class Function;

struct CJLoopFloatOpt : public PassInfoMixin<CJLoopFloatOpt> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) const;
};
} // namespace llvm

#endif // LLVM_TRANSFORMS_SCALAR_CJLOOPFLOATOPT_H

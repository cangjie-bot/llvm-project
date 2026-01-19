//===- CJSimpleOpt.h - ------------------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// Some early optimization points of cangjie
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_TRANSFORMS_SCALAR_CJ_EARLY_OPT_H
#define LLVM_TRANSFORMS_SCALAR_CJ_EARLY_OPT_H

#include "llvm/IR/PassManager.h"

namespace llvm {
struct CJSimpleOpt : public PassInfoMixin<CJSimpleOpt> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) const;
};

struct CJAfterInlineSimpleOpt : public PassInfoMixin<CJAfterInlineSimpleOpt> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) const;
};
} // namespace llvm

#endif // LLVM_TRANSFORMS_SCALAR_CJ_EARLY_OPT_H
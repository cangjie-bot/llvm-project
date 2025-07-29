//===- CJBarrierSplit.h - ---------------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file provides interface to "Cangjie Barrier Split" pass.
//
// This pass mainly implements the cangjie barrier splitting optimization.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_SCALAR_CJ_BARRIER_SPLIT_H
#define LLVM_TRANSFORMS_SCALAR_CJ_BARRIER_SPLIT_H

#include "llvm/IR/PassManager.h"

namespace llvm {
class Function;

struct CJBarrierSplit : public PassInfoMixin<CJBarrierSplit> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &) const;
};
} // namespace llvm

#endif // LLVM_TRANSFORMS_SCALAR_CJ_BARRIER_SPLIT_H
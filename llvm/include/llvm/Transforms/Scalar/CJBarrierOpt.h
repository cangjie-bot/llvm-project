//===- CJBarrierOpt.cpp - optimize cangjie write barriers -----------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This pass optimizes cangjie write barriers.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_SCALAR_CJ_BARRIER_OPT_H
#define LLVM_TRANSFORMS_SCALAR_CJ_BARRIER_OPT_H

#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/PassManager.h"

namespace llvm {
struct CJBarrierOpt : public PassInfoMixin<CJBarrierOpt> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &) const;
};
} // namespace llvm

#endif // LLVM_TRANSFORMS_SCALAR_CJ_BARRIER_OPT_H

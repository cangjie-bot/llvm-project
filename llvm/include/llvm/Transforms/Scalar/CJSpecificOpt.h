//===- CJSpecificOpt.h - ----------------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file provides interface to "Cangjie Specific Optimize" pass.
//
// This pass mainly implements the specified optimization of cangjie.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_SCALAR_CANGJIE_SPECIFIC_OPT_H
#define LLVM_TRANSFORMS_SCALAR_CANGJIE_SPECIFIC_OPT_H

#include "llvm/IR/PassManager.h"

namespace llvm {
class Module;

struct CJSpecificOpt : public PassInfoMixin<CJSpecificOpt> {
  CJSpecificOpt(unsigned OptLevel = 0) : OptLevel(OptLevel) {};
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &) const;

  unsigned OptLevel;
};
} // namespace llvm

#endif // LLVM_TRANSFORMS_SCALAR_CANGJIE_SPECIFIC_OPT_H
//===- PlaceSafepoints.h - Place GC Safepoints --------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// Place garbage collection safepoints at appropriate locations in the IR. This
// does not make relocation semantics or variable liveness explicit.  That's
// done by RewriteStatepointsForGC.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_SCALAR_PLACE_SAFE_POINTS_H
#define LLVM_TRANSFORMS_SCALAR_PLACE_SAFE_POINTS_H

#include "llvm/IR/PassManager.h"

namespace llvm {
class Module;

struct PlaceSafepoints : public PassInfoMixin<PlaceSafepoints> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) const;
};
} // namespace llvm

#endif // LLVM_TRANSFORMS_SCALAR_PLACE_SAFE_POINTS_H
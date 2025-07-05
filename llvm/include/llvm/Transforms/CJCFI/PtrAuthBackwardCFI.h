//===---------------------- PtrAuthBackwardCFI.h --------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef PTRAUTH_BACKWARD_CFI_H
#define PTRAUTH_BACKWARD_CFI_H

#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"

namespace llvm {

class PtrAuthBackwardCFI : public PassInfoMixin<PtrAuthBackwardCFI> {
public:
  PtrAuthBackwardCFI() {};
  ~PtrAuthBackwardCFI() {};
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
  static bool isRequired() { return true; }
};

}

#endif
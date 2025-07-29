//===--------------------- PtrAuthBackwardCFI.cpp -------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// The PtrAuth Backward CFI pass.
//
//===----------------------------------------------------------------------===//
#include "llvm/IR/Module.h"
#include "llvm/IR/Constants.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/CJCFI/PtrAuthBackwardCFI.h"

using namespace llvm;

#define DEBUG_TYPE "cj-pac-backward-cfi"

PreservedAnalyses PtrAuthBackwardCFI::run(Module &M,
                                          ModuleAnalysisManager &AM) {
  M.setModuleFlag(Module::ModFlagBehavior::Override, "sign-return-address",
                  ConstantAsMetadata::get(ConstantInt::get(Type::getInt32Ty(M.getContext()), 1)));
  return PreservedAnalyses::all();
}
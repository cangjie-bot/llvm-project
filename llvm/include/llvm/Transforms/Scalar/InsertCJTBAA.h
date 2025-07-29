//===- InsertCJTBAA.h - -----------------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// Insert Cangjie TBAA Metadata for load, store, memcpy, and barrier
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_TRANSFORMS_SCALAR_INSERT_CJ_TBAA_H
#define LLVM_TRANSFORMS_SCALAR_INSERT_CJ_TBAA_H

#include "llvm/IR/PassManager.h"
#include <cstdint>
namespace llvm {

class Function;

struct InsertCJTBAA : public PassInfoMixin<InsertCJTBAA> {
  /// Run the pass over the function.
  PreservedAnalyses run(Function &F, AnalysisManager<Function> &AM) const;
};

bool prepareCJTBAA(const DataLayout &DL, Instruction *I, Value *OP, Type *DstTy,
                   bool IsTBAAStruct = false, uint64_t OriginOff = 0);
bool updateTBAA(const DataLayout &DL, Instruction *I);
Type *getInnerTypeByOffset(const DataLayout &DL, StructType *ST,
                           uint64_t Offset);
bool insertTBAAWithDefiniteType(const DataLayout &DL, Instruction *I,
                                StructType *SrcTy, Type *DstTy, uint64_t Offset,
                                bool Tag = true);
} // namespace llvm

#endif // LLVM_TRANSFORMS_SCALAR_INSERT_CJ_TBAA_H
//===- llvm/IR/CJStructTypeGCInfo.h - gc info utilities ----------*-C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file contains utility functions to generate gc info for llvm types
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_IR_CJStructTypeGCInfo_H
#define LLVM_IR_CJStructTypeGCInfo_H

#include "llvm/IR/Constants.h"
#include "llvm/IR/Module.h"
#include <string>
#include <unordered_map>

namespace llvm {
struct BitMapInfo {
  bool HasRef = false;
  std::string BMStr;
};

struct TypeGCInfo {
  uint32_t ObjSize = 0;
  BitMapInfo BMInfo;
  Type *ElementType = nullptr;
};

struct CommonBitmap {
  explicit CommonBitmap(Module &M) : M(M), DL(M.getDataLayout()) {}
  Constant *insertBitMapU64(const std::string &BMStr, Type *CommonBMType);
  Constant *insertBitMapGV(const std::string &BMStr, Type *CommonBMType,
                           const std::string &BitMapName);
  Constant *getOrInsertBitMap(const std::string &BMStr, Type *CommonBMType,
                              const std::string &BitMapName);

  Module &M;
  const DataLayout &DL;
  std::unordered_map<std::string, Constant *> BitMapStr2Constant;
};

class CJStructTypeGCInfo : public CommonBitmap {
public:
  explicit CJStructTypeGCInfo(Module &Module) : CommonBitmap(Module) {
    PtrSize = DL.getPointerSize();
    assert(PtrSize ==
               DL.getABITypeAlignment(Type::getInt8PtrTy(M.getContext())) &&
           "PtrSize should be equal to PtrAlignment");
  }
  ~CJStructTypeGCInfo() = default;

  TypeGCInfo &getOrInsertTypeGCInfo(StructType *ST, bool IsArrayType = false);

private:
  bool isReferenceType(Type *T) {
    return (T->isPointerTy() && T->getPointerAddressSpace() == 1);
  }

  TypeGCInfo &insertArrayTypeGCInfo(StructType *ST);

  TypeGCInfo &insertNonArrayTypeGCInfo(StructType *ST);

  void getOrInsertArrayTypeGCInfo(ArrayType *AT, BitMapInfo &BMInfo,
                                  uint64_t &CurSize);

  void fillBMInfo(Type *Ty, BitMapInfo &BMInfo, uint64_t &CurSize);

  unsigned PtrSize;
  std::unordered_map<Type *, TypeGCInfo> Type2GCInfo;
};
} // end namespace llvm

#endif // LLVM_IR_CJStructTypeGCInfo_H

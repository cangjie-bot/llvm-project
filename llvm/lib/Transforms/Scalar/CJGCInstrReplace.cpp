//===- CJGCInstrReplace.cpp - -----------------------------------------*- C++
//-*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file provides interface to "Cangjie GC Instruction Replace" pass.
//
// This pass will replace gcread/gcwrite with load/store in pass pipeline
// beginning.
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Scalar/CJGCInstrReplace.h"

#include "llvm/IR/Constant.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Pass.h"
#include "llvm/Transforms/Scalar.h"

using namespace llvm;

#define DEBUG_TYPE "CJGCInstrReplace"

PreservedAnalyses CJGCInstrReplace::run(Function &F,
                                        FunctionAnalysisManager &FAM) {
  if (runImpl(F)) {
    return PreservedAnalyses::none();
  }
  return PreservedAnalyses::all();
}

bool CJGCInstrReplace::runImpl(Function &F) {
#ifndef NDEBUG
  LLVM_DEBUG(dbgs() << "CJGCInstrReplace: " << F.getName().str() << "start."
                    << "\n");
#endif
  initContainer();
  collectGCInstr(F);
  bool changed = changeGCInstrToLSInstr();
#ifndef NDEBUG
  if (changed) {
    LLVM_DEBUG(dbgs() << "CJGCInstrReplace: " << F.getName().str()
                      << " changed." << "\n");
  }
  LLVM_DEBUG(dbgs() << "CJGCInstrReplace: " << F.getName().str() << "end."
                    << "\n");
#endif
  return changed;
}

void CJGCInstrReplace::initContainer() {
  GCInstrDispatchMap.clear();
  GCReadRefs.clear();
  GCWriteRefs.clear();
  GCInstrDispatchMap[Intrinsic::cj_gcread_ref] = &GCReadRefs;
  GCInstrDispatchMap[Intrinsic::cj_gcwrite_ref] = &GCWriteRefs;
}

inline void CJGCInstrReplace::dispatchGCInstr(CallBase *CB) {
  auto IID = CB->getIntrinsicID();
  if (GCInstrDispatchMap.count(IID)) {
    GCInstrDispatchMap[IID]->push_back(CB);
#ifndef NDEBUG
    LLVM_DEBUG(dbgs() << "dispatchGCInstr: " << *CB << "\n");
#endif
  }
}

void CJGCInstrReplace::collectGCInstr(Function &F) {
  for (auto &I : instructions(F)) {
    if (auto *CB = dyn_cast<CallBase>(&I)) {
      dispatchGCInstr(CB);
    }
  }
}

namespace {

void addGCInstrMetadata(Instruction *Inst, CallBase *SourceGCInstr) {
  LLVMContext &Ctx = Inst->getContext();
  auto IID = SourceGCInstr->getIntrinsicID();
  Constant *ConstVal = ConstantInt::get(Type::getInt64Ty(Ctx), uint64_t(IID));
  ConstantAsMetadata *CAM = ConstantAsMetadata::get(ConstVal);
  MDNode *Node = MDNode::get(Ctx, CAM);
  Inst->setMetadata(CJGCInstrReplace::GC_WRITE_REF_IID, Node);
}

bool changeGCReadRef(SmallVector<CallBase *, 4> *GCInstrs) { return false; }

bool changeGCWriteRef(SmallVector<CallBase *, 4> *GCInstrs) {
  bool Changed = false;
  for (auto *GCWriteRef : *GCInstrs) {
    Changed = true;
    IRBuilder<> IRB(GCWriteRef);
    auto AddedStoreInstr = IRB.CreateStore(GCWriteRef->getArgOperand(0),
                                           GCWriteRef->getArgOperand(2));
    SmallVector<std::pair<unsigned, MDNode *>, 4> MDs;
    GCWriteRef->getAllMetadata(MDs);
    for (const auto &MD : MDs) {
        AddedStoreInstr->setMetadata(MD.first, MD.second);
    }
    addGCInstrMetadata(AddedStoreInstr, GCWriteRef);
  }
  for (auto *GCWriteRef : *GCInstrs) {
    GCWriteRef->eraseFromParent();
  }
  return Changed;
}

} // namespace

bool CJGCInstrReplace::changeGCInstrToLSInstr() {
  bool Changed = false;
  for (auto [IID, GCInstrs] : GCInstrDispatchMap) {
    switch (IID) {
    case Intrinsic::cj_gcread_ref:
      Changed |= changeGCReadRef(GCInstrs);
      break;
    case Intrinsic::cj_gcwrite_ref:
      Changed |= changeGCWriteRef(GCInstrs);
      break;
    default:
      break;
    }
  }
  return Changed;
}

//===- CJStackPointerInserter.h -- Cangjie Stack Pointer Inserter ---------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
// This file implements the CJStackPointerInserter pass.  For each statepoint
// machine instruction in the function, this pass implements live variable
// analysis of stack pointers, computes stack pointers that are alive at the
// call point, include in the register or spilled on the stack, and rewrites
// statepoints machine instructions to record them.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CODEGEN_CJSTACKPOINTERINSERTER_H
#define LLVM_CODEGEN_CJSTACKPOINTERINSERTER_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/StackMaps.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/InitializePasses.h"
#include "llvm/PassRegistry.h"

namespace llvm {

// a stack slot: <stack frame index, offset>
using SlotInfo = std::pair<int, int>;
// Structure of the stack pointer record of the statepoint
struct CJStackLives {
  SetVector<SlotInfo> Slots;
  SetVector<unsigned> Regs;

  bool empty() { return Regs.empty() && Slots.empty(); }

  void insertSlot(SlotInfo Slot) { Slots.insert(Slot); }

  void insertRegs(SetVector<unsigned> &Data) {
    Regs.insert(Data.begin(), Data.end());
  }
};

// Record the function args of pointer type.
struct FuncArgPointers {
  std::vector<MCPhysReg> Regs;
  std::vector<int> FIs;
};

// map a statepoint MI to its liveset.
using StatepointLives = MapVector<MachineInstr *, CJStackLives>;

class CJStackPointerInserter : public MachineFunctionPass {
public:
  static char ID; // Pass identification, replacement for typeid
  CJStackPointerInserter() : MachineFunctionPass(ID) {
    initializeCJStackPointerInserterPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;
  void getAnalysisUsage(AnalysisUsage &AU) const override;

private: // Intermediate data structures
  bool needRewriteCall(MachineInstr &MI);
  // Filter out the part of the gc pointer from the recorded regs and stacks.
  void filterGCPointer(MachineInstr &MI, StatepointOpers &SO,
                       SmallSetVector<unsigned, 16> &Regs,
                       SmallSetVector<SlotInfo, 16> &Slots);
  void recordArgStackPtrs(SmallSetVector<unsigned, 16> &Regs,
                          SmallSetVector<SlotInfo, 16> &Slots,
                          FuncArgPointers &ArgPtrs);

  // Rewrite the statepoint MI based on the live stack pointers.
  bool rewriteStatepoint(MachineFunction &MF, MachineInstr &MI,
                         CJStackLives &RecordLives, FuncArgPointers &ArgPtrs);
};

} // namespace llvm

#endif

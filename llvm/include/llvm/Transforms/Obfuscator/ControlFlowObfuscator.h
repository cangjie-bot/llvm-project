//===---------------------- ControlFlowObfuscator.h -----------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef CANGJIE_CONTROLFLOW_OBFUSCATOR_H
#define CANGJIE_CONTROLFLOW_OBFUSCATOR_H

#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"
#include "llvm/Analysis/ObfConfigAnalysis.h"

namespace llvm {

class ControlFlowObfuscator : public PassInfoMixin<ControlFlowObfuscator> {
public:
  ControlFlowObfuscator() {}
  ~ControlFlowObfuscator();
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);

private:
  std::vector<BasicBlock *> BlockVec;
  std::vector<uint32_t> BlockSet;
  std::vector<uint32_t> MapTagVec;
  std::vector<uint32_t> MapValueVec;
  std::vector<uint32_t> BlockFlagVec;
  std::vector<bool> PredisFlagVec;

  void doBcfObfuse(Module &M);
  void doIndBrObfuse(Module &M);
  void doFltObfuse(Module &M);

  unsigned int getRandNum() const;
  void renameOperand(ValueToValueMapTy &TV, BasicBlock &TB);
  BasicBlock *createAlterBasicBlock(BasicBlock &B, const Twine &N, Function &F);
  bool createBrForBasicBlock(Type &GT, BasicBlock &Father, BasicBlock &LChild,
                             BasicBlock &RChild);
  void createBasicBlock(BasicBlock &B, Function &F);
  void sortBasicBlock(Function &F);
  void insertBranches(Function &F);
  void insertBogusBlocks(Instruction &I);
  void handleFloatCmp(Instruction &I);
  void handleBinaryCmp(Instruction &I);
  void handleFloatInstruction(Instruction &I);
  void handleBinaryInstruction(Instruction &I);
  bool isFloatOpcode(unsigned int OP) const;
  bool isBinaryOpcode(unsigned int OP) const;
  void findBrInstWithType(std::vector<Instruction *> &InstVec,
                          std::vector<Instruction *> &CondVec, Function &F,
                          uint32_t Pre);

  BinaryOperator *createFemaMul(Module &M, Instruction &I, IntegerType *GT);
  void createBrExpressFema(Function &F, Instruction &I);
  void createBrExpressFema2(Function &F, Instruction &I);
  void applyFema(Function &F);
  bool needObfuse(Function &F, std::string Owner);
  BasicBlock *createCloneBasicBlock(BasicBlock *B);
  void repaireBrInst(Function &F);

  void doFltObfuse(Function &F);
  void handleRegStack(Function &F);
  void searchInstructions(Function &F, std::vector<PHINode *> &PHI,
                          std::vector<Instruction *> &Reg);
  void pushToVector(BasicBlock &B, Instruction &I, BasicBlock *E,
                    std::vector<PHINode *> &PHI,
                    std::vector<Instruction *> &Reg);
  bool isEscapeInst(Instruction &I);
  bool isUsedOutside(Instruction &I, BasicBlock &B);

  bool updateTags(Function &F, LoadInst &OptTag, BasicBlock &Router);
  Value *getBranches(uint32_t &Fbran, uint32_t &Tbran, Function &F,
                     BasicBlock &B, uint32_t Index);
  BinaryOperator *genTags(Function &F, LoadInst &NewInst, BasicBlock &B,
                          uint32_t Index, std::vector<uint32_t> &BS);
  Value *getFuncConstInt(Function &F, uint32_t Index, uint32_t T);
  bool updateCaseInst(SwitchInst &CaseInst, BasicBlock &Router);
  uint32_t getBlockIndex(BasicBlock &B);
  bool initOrigBlock(Function &F);
  void initTags(size_t Length);
  bool checkPreDisIsSkip(BasicBlock &B);
  void swapBlockSet(std::vector<uint32_t> &BV);
  void clearObfData();
  bool skipBlock();

  std::shared_ptr<ObfConfig> ObfConfig;
};

} // namespace llvm
#endif
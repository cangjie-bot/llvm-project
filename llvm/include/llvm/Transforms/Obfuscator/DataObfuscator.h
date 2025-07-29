//===-------------------------- DataObfuscator.h --------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef CANGJIE_DATA_OBFUSCATOR_H
#define CANGJIE_DATA_OBFUSCATOR_H

#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"
#include "llvm/Analysis/ObfConfigAnalysis.h"

namespace llvm {

struct ObfVar {
  GlobalVariable *OriVar;
  GlobalVariable *ObfVar;
  std::string ReplaceName;
  uint8_t Key;
  const char *Data;
  uint32_t Len;
};

class DataObfuscator : public PassInfoMixin<DataObfuscator> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);

private:
  bool needObfuseString(GlobalVariable &G);
  void stripGlobalString(Module &M);
  static StringRef getGlobalString(GlobalVariable &G);
  static bool cmpGlb(GlobalVariable *&FG, GlobalVariable *&SG);
  char *getGlobalStringData(GlobalVariable &G, unsigned int &Len);
  void replaceGlobalVariable(Module &M, GlobalVariable &G,
                             std::vector<std::unique_ptr<ObfVar>> &ObfGVec);
  void doObfuseString(Module &M);
  void addDecodeFunction(Module &M,
                         std::vector<std::unique_ptr<ObfVar>> &ObfGVec);
  void insertDecodeBlock(Module &M, Function &DecodeFunc, IRBuilder<> &Builder,
                         std::unique_ptr<ObfVar> &ObfGv);
  Function *createDecodeFunction(Module &M);
  void doDecode(LLVMContext &CTX, Value &V, IRBuilder<> &Builder,
                const std::unique_ptr<ObfVar> &ObfGv);
  void insertDecodeFunction(Module &M, FunctionCallee F);
  bool isIntrinsic(Instruction &I);
  void handleConst(Instruction &I, int Index);
  Value *addConstZero(Instruction &I, ConstantInt &V);
  void initInstList(Function &F, std::vector<Value *> &FunctionLocalVariables);
  Value *bitCalTrans(IRBuilder<> &Builder, Instruction &I, Value &X, IntegerType &TransType);
  Value *logicCalTrans(IRBuilder<> &Builder, Instruction &I, Value &X, Value &Y,
                       IntegerType &TransType);
  Value *handleZero(Instruction &I, ConstantInt &V,
                    std::vector<Value *> &FunctionLocalVariables);
  void handleInstWithZero(Instruction &I, std::vector<Value *> &FunctionLocalVariables);
  void doObfuseConst(Function &F, BasicBlock &B, std::vector<Value *> &FunctionLocalVariables,
                     std::vector<Value *> &CandidateValues);
  bool isImmCallArg(Instruction &I, unsigned int Index);
  void doObfuseConst(Function &F);
  void doObfuseConst(Module &M);
  void recordInst(Value *V, std::vector<Value *> &CandidateValues);
  bool needObfuse(Instruction &I);
  bool isDominateValue(Instruction &I, Value &V);
  Value *getRandomDominateValue(Instruction &I, std::vector<Value *> &CandidateValues, int TryTimes);
  std::shared_ptr<ObfConfig> ObfConfig;
};

} // namespace llvm

#endif

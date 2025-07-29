//===--------------------- ControlFlowObfuscator.cpp ----------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// The control-flow obfuscation pass.
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InlineAsm.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Statepoint.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/TypeFinder.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/PassRegistry.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Transforms/Utils.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include "llvm/Transforms/Obfuscator/ControlFlowObfuscator.h"
#include <iostream>

using namespace llvm;

extern cl::opt<bool> EnableConfigFlatten;
extern cl::opt<bool> EnableConfigBcf;

namespace {
const int SWITCH_NUM = 2;
const int MAX_EXPRESS_VALUE = 1024;
const int PRIME_NUM = 7;

const int MINI_BLOCK_NUM = 5;
const int MAX_BLOCK_NUM = 1000;
const int MAP_CHANGE = 93;
const int MAP_PRIME = 97;
const int MAP_OFFSET = 16;
const int TYPE1 = 1;
const int TYPE32 = 32;
const int TWO_SUCC = 2;

const int BINARY_OBF_SWITCH_NUM = 4;
const int BINARY_OBF_CASE_0 = 0;
const int BINARY_OBF_CASE_1 = 1;
const int BINARY_OBF_CASE_2 = 2;
const int BINARY_OBF_CASE_3 = 3;

const int FLOAT_OBF_SWITCH_NUM = 3;
const int FLOAT_OBF_CASE_0 = 0;
const int FLOAT_OBF_CASE_1 = 1;
const int FLOAT_OBF_CASE_2 = 2;

const int BCMP_OBF_SWITCH_NUM = 3;
const int BCMP_OBF_CASE_0 = 0;
const int BCMP_OBF_CASE_1 = 1;
const int BCMP_OBF_CASE_2 = 2;

const int FCMP_OBF_SWITCH_NUM = 3;
const int FCMP_OBF_CASE_0 = 0;
const int FCMP_OBF_CASE_1 = 1;
const int FCMP_OBF_CASE_2 = 2;
} // end anonymous namespace

ControlFlowObfuscator::~ControlFlowObfuscator() { clearObfData(); }

unsigned int ControlFlowObfuscator::getRandNum() const {
  return this->ObfConfig->getRandNum();
}

void ControlFlowObfuscator::renameOperand(ValueToValueMapTy &TV,
                                          BasicBlock &TB) {
  Value *V = nullptr;
  for (auto Iter = TB.begin(); Iter != TB.end(); Iter++) {
    for (User::op_iterator OP = Iter->op_begin(); OP != Iter->op_end(); OP++) {
      V = MapValue(*OP, TV, RF_None, 0);
      if (V == nullptr) {
        continue;
      }
      *OP = V;
    }
    PHINode *PN = dyn_cast<PHINode>(Iter);
    if (PN == nullptr) {
      continue;
    }
    for (uint32_t Index = 0; Index < PN->getNumIncomingValues(); Index++) {
      V = MapValue(PN->getIncomingBlock(Index), TV, RF_None, 0);
      if (V == nullptr) {
        continue;
      }
      BasicBlock *TB = dyn_cast<BasicBlock>(V);
      if (TB == nullptr) {
        continue;
      }
      PN->setIncomingBlock(Index, TB);
    }
  }
}

bool ControlFlowObfuscator::isBinaryOpcode(unsigned int OP) const {
  // Don't handle div instructions: SDiv, UDiv, SRem and URem
  return (OP == Instruction::Add || OP == Instruction::Sub ||
          OP == Instruction::Mul || OP == Instruction::Shl ||
          OP == Instruction::LShr || OP == Instruction::AShr ||
          OP == Instruction::And || OP == Instruction::Or ||
          OP == Instruction::Xor);
}

bool ControlFlowObfuscator::isFloatOpcode(unsigned int OP) const {
  // Don't handle div instructions: FDiv and FRem
  return (OP == Instruction::FAdd || OP == Instruction::FSub ||
          OP == Instruction::FMul);
}

void ControlFlowObfuscator::handleBinaryInstruction(Instruction &I) {
  int N = (getRandNum() % SWITCH_NUM) + 1;
  int Index = 0;
  BinaryOperator *OP = nullptr;
  BinaryOperator *OP1 = nullptr;
  (void) OP;
  (void) OP1;

  do {
    switch (getRandNum() % BINARY_OBF_SWITCH_NUM) {
    case BINARY_OBF_CASE_0:
      break;
    case BINARY_OBF_CASE_1:
      OP = BinaryOperator::CreateNeg(I.getOperand(0), "", &I);
      OP1 =
          BinaryOperator::Create(Instruction::Add, OP, I.getOperand(1), "", &I);
      break;
    case BINARY_OBF_CASE_2:
      OP = BinaryOperator::Create(Instruction::Sub, I.getOperand(0),
                                  I.getOperand(1), "", &I);
      OP1 =
          BinaryOperator::Create(Instruction::Mul, OP, I.getOperand(1), "", &I);
      break;
    case BINARY_OBF_CASE_3:
      OP = BinaryOperator::Create(Instruction::Shl, I.getOperand(0),
                                  I.getOperand(1), "", &I);
      break;
    default:
      break;
    }
  } while (++Index < N);
}

void ControlFlowObfuscator::handleFloatInstruction(Instruction &I) {
  int N = (getRandNum() % SWITCH_NUM) + 1;
  int Index = 0;
  Instruction *OP = nullptr;
  BinaryOperator *OP1 = nullptr;
  (void) OP;
  (void) OP1;

  do {
    switch (getRandNum() % FLOAT_OBF_SWITCH_NUM) {
    case FLOAT_OBF_CASE_0:
      break;
    case FLOAT_OBF_CASE_1:
      OP = UnaryOperator::CreateFNeg(I.getOperand(0), "", &I);
      OP1 = BinaryOperator::Create(Instruction::FAdd, OP, I.getOperand(1), "",
                                   &I);
      break;
    case FLOAT_OBF_CASE_2:
      OP = BinaryOperator::Create(Instruction::FSub, I.getOperand(0),
                                  I.getOperand(1), "", &I);
      OP1 = BinaryOperator::Create(Instruction::FMul, OP, I.getOperand(1), "",
                                   &I);
      break;
    default:
      break;
    }
  } while (++Index < N);
}

void ControlFlowObfuscator::handleBinaryCmp(Instruction &I) {
  ICmpInst *CI = dyn_cast<ICmpInst>(&I);
  llvm::CmpInst::Predicate OPTable[] = {ICmpInst::ICMP_EQ,  ICmpInst::ICMP_NE,
                                        ICmpInst::ICMP_UGT, ICmpInst::ICMP_UGE,
                                        ICmpInst::ICMP_ULT, ICmpInst::ICMP_ULE,
                                        ICmpInst::ICMP_SGT, ICmpInst::ICMP_SGE,
                                        ICmpInst::ICMP_SLT, ICmpInst::ICMP_SLE};
  int N = (getRandNum() % SWITCH_NUM) + 1;
  int Count = 0;
  int Index;
  do {
    switch (getRandNum() % BCMP_OBF_SWITCH_NUM) {
    case BCMP_OBF_CASE_0:
      break;
    case BCMP_OBF_CASE_1:
      CI->swapOperands();
      break;
    case BCMP_OBF_CASE_2:
      Index =
          getRandNum() % (sizeof(OPTable) / sizeof(llvm::CmpInst::Predicate));
      CI->setPredicate(OPTable[Index]);
      break;
    default:
      break;
    }
  } while (++Count < N);
}

void ControlFlowObfuscator::handleFloatCmp(Instruction &I) {
  FCmpInst *CI = dyn_cast<FCmpInst>(&I);
  llvm::CmpInst::Predicate OPTable[] = {ICmpInst::FCMP_OEQ, FCmpInst::FCMP_ONE,
                                        FCmpInst::FCMP_UGT, FCmpInst::FCMP_UGE,
                                        FCmpInst::FCMP_ULT, FCmpInst::FCMP_ULE,
                                        FCmpInst::FCMP_OGT, FCmpInst::FCMP_OGE,
                                        FCmpInst::FCMP_OLT, FCmpInst::FCMP_OLE};
  int N = (getRandNum() % SWITCH_NUM) + 1;
  int Count = 0;
  int Index;
  do {
    switch (getRandNum() % FCMP_OBF_SWITCH_NUM) {
    case FCMP_OBF_CASE_0:
      break;
    case FCMP_OBF_CASE_1:
      CI->swapOperands();
      break;
    case FCMP_OBF_CASE_2:
      Index =
          getRandNum() % (sizeof(OPTable) / sizeof(llvm::CmpInst::Predicate));
      CI->setPredicate(OPTable[Index]);
      break;
    default:
      break;
    }
  } while (++Count < N);
}

void ControlFlowObfuscator::insertBogusBlocks(Instruction &I) {
  if (!I.isBinaryOp()) {
    return;
  }
  unsigned OP = I.getOpcode();
  if (isBinaryOpcode(OP)) {
    handleBinaryInstruction(I);
  } else if (isFloatOpcode(OP)) {
    handleFloatInstruction(I);
  } else if (OP == Instruction::ICmp) {
    handleBinaryCmp(I);
  } else if (OP == Instruction::FCmp) {
    handleFloatCmp(I);
  }
}

BasicBlock *ControlFlowObfuscator::createAlterBasicBlock(BasicBlock &B,
                                                         const Twine &N,
                                                         Function &F) {
  ValueToValueMapTy TV;
  BasicBlock *BcfBlock = CloneBasicBlock(&B, TV, N, &F);
  if (BcfBlock == nullptr) {
    return nullptr;
  }
  renameOperand(TV, *BcfBlock);
  for (auto I = BcfBlock->begin(); I != BcfBlock->end(); I++) {
    Instruction *TempInst = dyn_cast<Instruction>(I);
    if (TempInst == nullptr) {
      continue;
    }
    insertBogusBlocks(*TempInst);
  }

  Instruction *I = BcfBlock->getTerminator();
  if (I == nullptr) {
    return nullptr;
  }
  I->eraseFromParent();
  if (BranchInst::Create(&B, BcfBlock) == nullptr) {
    return nullptr;
  }
  return BcfBlock;
}

bool ControlFlowObfuscator::createBrForBasicBlock(Type &GT, BasicBlock &Father,
                                                  BasicBlock &LChild,
                                                  BasicBlock &RChild) {
  Value *LValue = ConstantFP::get(&GT, 0);
  Value *RValue = ConstantFP::get(&GT, 1);
  if (LValue == nullptr || RValue == nullptr) {
    return false;
  }
  Instruction *I = Father.getTerminator();
  if (I == nullptr) {
    return false;
  }
  I->eraseFromParent();
  FCmpInst *C = std::make_unique<FCmpInst>(Father, FCmpInst::FCMP_FALSE, LValue,
                                           RValue, "condition")
                    .release();
  if (C == nullptr) {
    return false;
  }
  if (BranchInst::Create(&LChild, &RChild, static_cast<Value *>(C), &Father) ==
      nullptr) {
    return false;
  }
  return true;
}

void ControlFlowObfuscator::createBasicBlock(BasicBlock &B, Function &F) {
  Module *M = F.getParent();
  Type *GT = Type::getFloatTy(M->getContext());
  // split the [`B`] into [`B` + `SplitBlock`]
  BasicBlock *SplitBlock = B.splitBasicBlock(B.getTerminator(), "obfuscatorA");

  // split the [`SplitBlock`] into [`SplitBlock` + `SplitBlock2`]
  BasicBlock *SplitBlock2 =
      SplitBlock->splitBasicBlock(SplitBlock->getTerminator(), "obfuscatorB");

  if (SplitBlock2 == nullptr) {
    return;
  }
  // clone `SplitBlock` to `BcfBlock` and insert bogus instructions into it.
  BasicBlock *BcfBlock = createAlterBasicBlock(*SplitBlock, "", F);
  if (BcfBlock == nullptr) {
    return;
  }
  /* create a conditional jump instruction in the end of `B` */
  /* and set `SplitBlock` and `BcfBlock` as the jump Targets     */
  if (!createBrForBasicBlock(*GT, B, *SplitBlock, *BcfBlock)) {
    return;
  }
  /* create a conditional jump instruction in the end of `SplitBlock` */
  /* and set `SplitBlock2` and `BcfBlock` as the jump Targets         */
  if (!createBrForBasicBlock(*GT, *SplitBlock, *SplitBlock2, *BcfBlock)) {
    return;
  }
}

void ControlFlowObfuscator::sortBasicBlock(Function &F) {
  std::vector<BasicBlock *> TmpBlockVec;
  for (auto B = F.begin(); B != F.end(); B++) {
    BasicBlock *Temp = dyn_cast<BasicBlock>(B);
    if (Temp == nullptr) {
      continue;
    }
    TmpBlockVec.push_back(Temp);
    if (TmpBlockVec.size() <= 1) {
      return;
    }
  }
  for (uint32_t Count = 0; Count < TmpBlockVec.size(); Count++) {
    int Temp = (getRandNum() % (TmpBlockVec.size() - 1)) + 1;
    BasicBlock *BB = TmpBlockVec[Temp];
    if (BB == nullptr) {
      continue;
    }
    F.getBasicBlockList().remove(BB);
    F.getBasicBlockList().push_back(BB);
  }
}

static bool isDivInstruction(Instruction &I) {
  return Instruction::isIntDivRem(I.getOpcode()) ||
         I.getOpcode() == Instruction::FDiv ||
         I.getOpcode() == Instruction::FRem;
}

void ControlFlowObfuscator::insertBranches(Function &F) {
  bool Flag = false;
  std::vector<BasicBlock *> TmpBlockVec;
  std::vector<BasicBlock *> DivBlockVec;
  unsigned int Index = 0;
  for (BasicBlock &B : F) {
    for (auto &I : B) {
      if (isDivInstruction(I)) {
        DivBlockVec.push_back(&B);
        break;
      }
    }
  }
  for (BasicBlock &B : F) {
    // Skip blocks contain div instructions.
    if (std::find(DivBlockVec.begin(), DivBlockVec.end(), &B) != DivBlockVec.end()) {
      continue;
    }
    // Skip blocks which's successors contain div instructions.
    unsigned int SuccNum = B.getTerminator()->getNumSuccessors();
    bool skip = false;
    for (Index = 0; Index < SuccNum; Index++) {
      auto Succ = B.getTerminator()->getSuccessor(Index);
      if (std::find(DivBlockVec.begin(), DivBlockVec.end(), Succ) != DivBlockVec.end()) {
        skip = true;
        break;
      }
    }
    if (skip)
      continue;
    TmpBlockVec.push_back(&B);
  }

  for (BasicBlock *B : TmpBlockVec) {
    if (Flag == false || !skipBlock()) {
      Flag = true;
      // create bogus blocks and insert it into `F`
      createBasicBlock(*B, F);
    }
  }
}

void ControlFlowObfuscator::findBrInstWithType(
    std::vector<Instruction *> &InstVec, std::vector<Instruction *> &CondVec,
    Function &F, uint32_t Pre) {
  for (auto B = F.begin(); B != F.end(); B++) {
    Instruction *I = B->getTerminator();
    if (I == nullptr || I->getOpcode() != Instruction::Br) {
      continue;
    }
    BranchInst *BrInst = reinterpret_cast<BranchInst *>(I);
    if (BrInst == nullptr || !BrInst->isConditional()) {
      continue;
    }
    FCmpInst *C = reinterpret_cast<FCmpInst *>(BrInst->getCondition());
    if (C == nullptr) {
      continue;
    }
    uint32_t OP = C->getOpcode();
    if (OP != Instruction::FCmp) {
      continue;
    }
    if (C->getPredicate() == Pre) {
      InstVec.push_back(I);
      CondVec.push_back(C);
    }
  }
}

void ControlFlowObfuscator::createBrExpressFema(Function &F, Instruction &I) {
  Module *M = F.getParent();
  IntegerType *GT = Type::getInt32Ty(M->getContext());
  if (GT == nullptr) {
    return;
  }
  Constant *X1 = static_cast<Constant *>(
      ConstantInt::get(GT, getRandNum() % MAX_EXPRESS_VALUE, false));
  GlobalVariable *X = std::make_unique<GlobalVariable>(
                          *M, GT, false, GlobalVariable::PrivateLinkage, X1)
                          .release();
  LoadInst *OPX =
      std::make_unique<LoadInst>(GT, static_cast<Value *>(X), "", &I).release();
  // [X] = RandNum
  // OP = [X] * PRIME_NUM
  BinaryOperator *OP =
      BinaryOperator::Create(Instruction::Mul, static_cast<Value *>(OPX),
                             ConstantInt::get(GT, PRIME_NUM, false), "", &I);

  Constant *Y1 = static_cast<Constant *>(
      ConstantInt::get(GT, getRandNum() % MAX_EXPRESS_VALUE, false));
  GlobalVariable *Y = std::make_unique<GlobalVariable>(
                          *M, GT, false, GlobalValue::PrivateLinkage, Y1)
                          .release();
  LoadInst *OPY =
      std::make_unique<LoadInst>(GT, static_cast<Value *>(Y), "", &I).release();
  // [y] = RandNum
  // OP1 = [y] * [y]
  BinaryOperator *OP1 =
      BinaryOperator::Create(Instruction::Mul, static_cast<Value *>(OPY),
                             static_cast<Value *>(OPY), "", &I);
  // OP1 = OP1 + 1
  OP1 = BinaryOperator::Create(Instruction::Add, OP1,
                               ConstantInt::get(GT, 1, false), "", &I);
  ICmpInst *C =
      std::make_unique<ICmpInst>(&I, ICmpInst::ICMP_NE, OP, OP1).release();

  if (BranchInst::Create(static_cast<BranchInst *>(&I)->getSuccessor(0),
                         static_cast<BranchInst *>(&I)->getSuccessor(1),
                         static_cast<Value *>(C),
                         static_cast<BranchInst *>(&I)->getParent()) ==
      nullptr) {
    return;
  }
  I.eraseFromParent();
}

BinaryOperator *ControlFlowObfuscator::createFemaMul(Module &M, Instruction &I,
                                                     IntegerType *GT) {
  Constant *X1 = static_cast<Constant *>(
      ConstantInt::get(GT, getRandNum() % MAX_EXPRESS_VALUE + 1, false));
  GlobalVariable *X = std::make_unique<GlobalVariable>(
                          M, GT, false, GlobalVariable::PrivateLinkage, X1)
                          .release();
  LoadInst *OPX =
      std::make_unique<LoadInst>(GT, static_cast<Value *>(X), "", &I).release();
  // OP = [X] * PRIME_NUM
  BinaryOperator *OP =
      BinaryOperator::Create(Instruction::Mul, static_cast<Value *>(OPX),
                             ConstantInt::get(GT, PRIME_NUM, false), "", &I);
  return OP;
}

void ControlFlowObfuscator::createBrExpressFema2(Function &F, Instruction &I) {
  Module *M = F.getParent();
  IntegerType *GT = Type::getInt32Ty(M->getContext());
  if (GT == nullptr) {
    return;
  }
  // OP = [X] * PRIME_NUM
  BinaryOperator *OP = createFemaMul(*M, I, GT);

  // OP1 = [y] * [y]
  BinaryOperator *OP1 = createFemaMul(*M, I, GT);

  OP1 = BinaryOperator::Create(Instruction::Add, OP1,
                               ConstantInt::get(GT, 1, false), "", &I);

  // OP2 = [z] * [z]
  BinaryOperator *OP2 = createFemaMul(*M, I, GT);

  // OP = [X] * PRIME_NUM + [y]^2
  OP = BinaryOperator::Create(Instruction::Add, OP, OP1, "", &I);
  // condition is ([z]^2 != [X] * PRIME_NUM + [y]^2)
  ICmpInst *C =
      std::make_unique<ICmpInst>(&I, ICmpInst::ICMP_NE, OP, OP2).release();

  if (BranchInst::Create(static_cast<BranchInst *>(&I)->getSuccessor(0),
                         static_cast<BranchInst *>(&I)->getSuccessor(1),
                         static_cast<Value *>(C),
                         static_cast<BranchInst *>(&I)->getParent()) ==
      nullptr) {
    return;
  }
  I.eraseFromParent();
}

void ControlFlowObfuscator::applyFema(Function &F) {
  std::vector<Instruction *> InstVec;
  std::vector<Instruction *> CondVec;

  findBrInstWithType(InstVec, CondVec, F, FCmpInst::FCMP_FALSE);
  for (auto IT : InstVec) {
    Instruction *I = IT;
    if (I == nullptr) {
      continue;
    }
    if (getRandNum() % SWITCH_NUM == 0) {
      createBrExpressFema(F, *I);
    } else {
      createBrExpressFema2(F, *I);
    }
  }

  for (uint32_t Count = 0; Count < CondVec.size(); Count++) {
    CondVec[Count]->eraseFromParent();
  }
  return;
}

void ControlFlowObfuscator::doBcfObfuse(Module &M) {
  for (auto &F : M) {
    if (!needObfuse(F, "obf-cf-bogus")) {
      continue;
    }
    // insert indirect branchs
    insertBranches(F);
    // shuffle the order of blocks
    sortBasicBlock(F);
    // apply fema to the condition of indirect branchs
    applyFema(F);
  }
}

void ControlFlowObfuscator::swapBlockSet(std::vector<uint32_t> &BV) {
  for (uint32_t Index = 0; Index < BV.size(); Index++) {
    uint32_t TempIndex = getRandNum() % BV.size();
    uint32_t Tag = BV[TempIndex];
    BV[TempIndex] = BV[Index];
    BV[Index] = Tag;
  }
}

bool ControlFlowObfuscator::checkPreDisIsSkip(BasicBlock &B) {
  bool Flag = false;
  for (auto Itr = pred_begin(&B); Itr != pred_end(&B); Itr++) {
    BasicBlock *Pred = *Itr;
    for (uint32_t Index = 0; Index < BlockVec.size(); Index++) {
      if (BlockVec[Index] != Pred)
        continue;
      if (BlockFlagVec[Index] == 0) {
        Flag = true;
        break;
      }
    }
  }
  return Flag;
}

void ControlFlowObfuscator::clearObfData() {
  BlockVec.clear();
  BlockSet.clear();
  MapTagVec.clear();
  MapValueVec.clear();
  BlockFlagVec.clear();
  PredisFlagVec.clear();
}

bool ControlFlowObfuscator::skipBlock() {
  unsigned int Level = this->ObfConfig->getObfLevel();
  unsigned int Max = this->ObfConfig->getMaxObfLevel();
  unsigned int Num = getRandNum();
  return ((Num % Max) > Level);
}

void ControlFlowObfuscator::initTags(size_t Length) {
  for (uint32_t Index = 0; Index < Length; Index++) {
    uint32_t Tag = 0;
    uint32_t Temp = 0;
    do {
      Tag = (getRandNum() << MAP_OFFSET) / MAP_PRIME;
      Temp = Tag ^ MAP_CHANGE;
    } while (find(MapTagVec.begin(), MapTagVec.end(), Tag) != MapTagVec.end() ||
             Temp >= (UINT32_MAX / MAP_PRIME));

    uint32_t Value = Temp * MAP_PRIME;
    MapTagVec.push_back(Tag);
    MapValueVec.push_back(Value);
  }
}

bool isUnsafeGCStatePoint(Instruction &I) {
  BasicBlock *B = I.getParent();
  auto GI = dyn_cast<GCStatepointInst>(&I);
  if (GI == nullptr) {
    return false;
  }
  if (GI->isUsedOutsideOfBlock(B)) {
    return true;
  }
  for (auto &SI : GI->struct_args()) {
    auto SInst = dyn_cast<Instruction>(&SI);
    if (SInst != nullptr && SInst->isUsedOutsideOfBlock(B)) {
      return true;
    }
  }
  for (auto &SI : GI->gc_args()) {
    auto SInst = dyn_cast<Instruction>(&SI);
    if (SInst != nullptr && SInst->isUsedOutsideOfBlock(B)) {
      return true;
    }
  }
  return false;
}

bool isInstUsedOutside(Instruction &I) {
  BasicBlock *B = I.getParent();
  if (I.isUsedOutsideOfBlock(B)) {
    return true;
  }
  auto CI = dyn_cast<CallInst>(&I);
  for (unsigned int Index = 0; Index < CI->arg_size(); Index++) {
    auto Arg = CI->getArgOperand(Index);
    if (Arg == nullptr) {
      continue;
    }
    auto ArgInst = dyn_cast<Instruction>(Arg);
    if (ArgInst != nullptr && ArgInst->isUsedOutsideOfBlock(B)) {
      return true;
    }
  }
  return false;
}

bool isUnsafeGCRelocate(Instruction &I) {
  auto GR = dyn_cast<GCRelocateInst>(&I);
  if (GR == nullptr) {
    return false;
  }
  return isInstUsedOutside(I);
}

bool isUnsafeGCResultInst(Instruction &I) {
  auto GR = dyn_cast<GCResultInst>(&I);
  if (GR == nullptr) {
    return false;
  }
  return isInstUsedOutside(I);
}

bool isFunctionSafeToModifyStack(Function &F) {
  for (auto &Iter : F) {
    BasicBlock *B = &Iter;
    if (isa<InvokeInst>(B->getTerminator()))
      return false;
    for (auto &I : *B) {
      if (isUnsafeGCStatePoint(I) || isUnsafeGCRelocate(I) ||
          isUnsafeGCResultInst(I) || isDivInstruction(I)) {
        return false;
      }
    }
  }
  return true;
}

bool ControlFlowObfuscator::initOrigBlock(Function &F) {
  if (!isFunctionSafeToModifyStack(F)) {
    return false;
  }

  clearObfData();
  for (auto &Iter : F) {
    BasicBlock *B = &Iter;
    if (B != nullptr) {
      BlockVec.push_back(B);
    }
  }
  if (BlockVec.size() < MINI_BLOCK_NUM || BlockVec.size() > MAX_BLOCK_NUM)
    return false;

  BlockVec.erase(BlockVec.begin());
  BasicBlock *Temp = &*(F.begin());

  if (isa<BranchInst>(Temp->getTerminator())) {
    BranchInst *BI = dyn_cast<BranchInst>(Temp->getTerminator());
    if (BI->isConditional() && Temp->size() > 1) {
      BasicBlock::iterator Iter = --Temp->end();
      Iter--;
      BasicBlock *SB = Temp->splitBasicBlock(Iter, "obfuscatorInit");
      BlockVec.insert(BlockVec.begin(), SB);
    }
  }

  // generate a disorder set
  BlockSet.resize(BlockVec.size());
  int TempVal = 0;
  for (auto &BlockSetVal : BlockSet) {
    BlockSetVal = TempVal++;
  }

  swapBlockSet(BlockSet);

  for (uint32_t Index = 0; Index < BlockVec.size(); Index++) {
    if (BlockVec[Index]->getTerminator()->getNumSuccessors() > TWO_SUCC || skipBlock())
      BlockFlagVec.push_back(0);
    else
      BlockFlagVec.push_back(1);
  }
  for (uint32_t Index = 0; Index < BlockVec.size(); Index++) {
    BasicBlock *BB = BlockVec[Index];
    // check if `BB`'s predecessors is 0 in `BlockFlagVec`
    bool Flag = checkPreDisIsSkip(*BB);
    PredisFlagVec.push_back(Flag);
  }

  initTags(BlockVec.size());
  return true;
}

uint32_t ControlFlowObfuscator::getBlockIndex(BasicBlock &B) {
  return distance(BlockVec.begin(), find(BlockVec.begin(), BlockVec.end(), &B));
}

Value *ControlFlowObfuscator::getFuncConstInt(Function &F, uint32_t Index,
                                              uint32_t T) {
  if (T == TYPE1) {
    return ConstantInt::get(Type::getInt1Ty(F.getContext()), Index);
  }
  if (T == TYPE32) {
    return ConstantInt::get(Type::getInt32Ty(F.getContext()), Index);
  }
  return nullptr;
}

bool ControlFlowObfuscator::updateCaseInst(SwitchInst &CaseInst,
                                           BasicBlock &Router) {
  for (uint32_t Index : BlockSet) {
    BasicBlock *B = BlockVec[Index];
    ConstantInt *CaseValue = dyn_cast<ConstantInt>(ConstantInt::get(
        CaseInst.getCondition()->getType(), MapValueVec[Index]));
    if (CaseValue == nullptr)
      return false;
    CaseInst.addCase(CaseValue, B);
  }
  return true;
}

Value *ControlFlowObfuscator::getBranches(uint32_t &Fbran, uint32_t &Tbran,
                                          Function &F, BasicBlock &B,
                                          uint32_t Index) {
  Value *ConstBool = nullptr;
  if (B.getTerminator()->getNumSuccessors() == 1) {
    ConstBool = getFuncConstInt(F, 0, TYPE1);
    Fbran = getBlockIndex(*B.getTerminator()->getSuccessor(0));
    Tbran = Index;
  } else if (B.getTerminator()->getNumSuccessors() == TWO_SUCC) {
    BranchInst *BI = dyn_cast<BranchInst>(B.getTerminator());
    if (BI == nullptr) {
      return nullptr;
    }
    ConstBool = dyn_cast<BranchInst>(B.getTerminator())->getCondition();
    Fbran = getBlockIndex(*B.getTerminator()->getSuccessor(1));
    Tbran = getBlockIndex(*B.getTerminator()->getSuccessor(0));
  } else {
    return nullptr;
  }
  return ConstBool;
}

BinaryOperator *ControlFlowObfuscator::genTags(Function &F, LoadInst &NewInst,
                                               BasicBlock &B, uint32_t Index,
                                               std::vector<uint32_t> &BS) {
  uint32_t Fbran, Tbran;
  Value *ConstBool = nullptr;
  BinaryOperator *SetTags = nullptr;
  uint32_t ObfNum = getRandNum();

  ConstBool = getBranches(Fbran, Tbran, F, B, Index);
  if (!ConstBool) {
    return nullptr;
  }

  Value *ConstInt = getFuncConstInt(F, ObfNum, TYPE32);
  Value *ConstZero = getFuncConstInt(F, 0, TYPE32);
  if (PredisFlagVec[Index] == 0)
    SetTags = BinaryOperator::Create(BinaryOperator::Xor, ConstInt, &NewInst,
                                     "", B.getTerminator());
  else
    SetTags = BinaryOperator::Create(BinaryOperator::Xor, ConstInt, ConstZero,
                                     "", B.getTerminator());
  for (uint32_t BNum : BS) {
    if (BNum == Fbran) {
      if (PredisFlagVec[Index] == 0) {
        ConstInt = getFuncConstInt(
            F, MapTagVec[Index] ^ MapTagVec[Fbran] ^ ObfNum, TYPE32);
      } else {
        ConstInt = getFuncConstInt(F, MapTagVec[Fbran] ^ ObfNum, TYPE32);
      }
      SetTags = BinaryOperator::Create(BinaryOperator::Xor, ConstInt, SetTags,
                                       "", B.getTerminator());
    } else if (BNum == Tbran) {
      ConstInt =
          getFuncConstInt(F, MapTagVec[Tbran] ^ MapTagVec[Fbran], TYPE32);
      Value *ZextInst = std::make_unique<ZExtInst>(
                            ConstBool, Type::getInt32Ty(F.getContext()), "",
                            B.getTerminator())
                            .release();
      BinaryOperator *Sext = BinaryOperator::Create(
          BinaryOperator::Sub, getFuncConstInt(F, 0, TYPE32), ZextInst, "",
          B.getTerminator());
      BinaryOperator *MaskVal = BinaryOperator::Create(
          BinaryOperator::And, Sext, ConstInt, "", B.getTerminator());
      SetTags = BinaryOperator::Create(BinaryOperator::Xor, MaskVal, SetTags,
                                       "", B.getTerminator());
    }
  }
  return SetTags;
}

bool ControlFlowObfuscator::updateTags(Function &F, LoadInst &OptTag,
                                       BasicBlock &Router) {
  for (uint32_t Index : BlockSet) {
    BasicBlock *B = BlockVec[Index];
    if (BlockFlagVec[Index] == 0) {
      continue;
    }
    if (B->getTerminator()->getNumSuccessors() == 0) {
      continue;
    }
    std::vector<uint32_t> BS = BlockSet;
    swapBlockSet(BS);
    BinaryOperator *SetTags = genTags(F, OptTag, *B, Index, BS);
    if (SetTags == nullptr) {
      return false;
    }

    Instruction *I = B->getTerminator();
    if (I == nullptr) {
      return false;
    }

    I->eraseFromParent();
    if (std::make_unique<StoreInst>(SetTags, OptTag.getPointerOperand(), B)
            .release() == nullptr) {
      return false;
    }

    if (BranchInst::Create(&Router, B) == nullptr) {
      return false;
    }
  }
  return true;
}

bool ControlFlowObfuscator::isEscapeInst(Instruction &I) {
  BasicBlock *B = I.getParent();
  if (B == nullptr)
    return false;
  Value::use_iterator InstIter;
  for (InstIter = I.use_begin(); InstIter != I.use_end(); InstIter++) {
    Instruction *TmpInst = dyn_cast<Instruction>(*InstIter);
    if (TmpInst == nullptr)
      continue;
    if (isa<PHINode>(TmpInst)) {
      return true;
    }
    if (TmpInst->getParent() != B) {
      return true;
    }
  }
  return false;
}

bool ControlFlowObfuscator::isUsedOutside(Instruction &I, BasicBlock &B) {
  if (!I.isUsedOutsideOfBlock(&B)) {
    return false;
  }
  auto FB = &*(B.getParent()->begin());
  if (I.getParent() == FB) {
    // the 1st block is not in the big switch-case struct,
    // so it is safe to ignore variables from the 1st block.
    return false;
  }

  return true;
}

void ControlFlowObfuscator::pushToVector(BasicBlock &B, Instruction &I,
                                         BasicBlock *E,
                                         std::vector<PHINode *> &PHI,
                                         std::vector<Instruction *> &Reg) {
  if (isa<PHINode>(I)) {
    PHINode *PN = dyn_cast<PHINode>(&I);
    if (PN != nullptr)
      PHI.push_back(PN);
    return;
  }

  if (isa<AllocaInst>(I) && I.getParent() == E)
    return;

  if (I.getType()->getTypeID() == Type::TokenTyID)
    return;

  if (isEscapeInst(I)) {
    Reg.push_back(&I);
  } else if (isUsedOutside(I, B)) {
    Reg.push_back(&I);
  }
}

void ControlFlowObfuscator::searchInstructions(
    Function &F, std::vector<PHINode *> &PHI, std::vector<Instruction *> &Reg) {
  PHI.clear();
  Reg.clear();
  BasicBlock *E = &*(F.begin());
  if (E == nullptr)
    return;
  for (auto &B : F) {
    for (auto &I : B)
      pushToVector(B, I, E, PHI, Reg);
  }
}

void ControlFlowObfuscator::handleRegStack(Function &F) {
  std::vector<PHINode *> PHI;
  std::vector<Instruction *> Reg;
  unsigned int Index;
  auto AllocaPoint = F.begin()->begin();
  do {
    searchInstructions(F, PHI, Reg);
    for (Index = 0; Index != PHI.size(); Index++) {
      DemotePHIToStack(PHI.at(Index), &*AllocaPoint);
    }
    for (Index = 0; Index != Reg.size(); Index++) {
      DemoteRegToStack(*Reg.at(Index), false, &*AllocaPoint);
    }
  } while (Reg.size() != 0 || PHI.size() != 0);
}

void ControlFlowObfuscator::doFltObfuse(Function &F) {
  if (!initOrigBlock(F)) {
    return;
  }
  BasicBlock *B = &*(F.begin());
  StoreInst *Store = nullptr;
  (void) Store;
  uint32_t nextIndex = getBlockIndex(*(B->getTerminator()->getSuccessor(0)));
  B->getTerminator()->eraseFromParent();

  IntegerType *T = Type::getInt32Ty(F.getContext());
  AllocaInst *Values =
      std::make_unique<AllocaInst>(T, 0, "Values", B).release();
  AllocaInst *Tags = std::make_unique<AllocaInst>(T, 0, "Tags", B).release();
  Value *BasisConst = getFuncConstInt(F, MAP_CHANGE, TYPE32);

  // Store `MAP_CHANGE` in `Values`
  Store = std::make_unique<StoreInst>(BasisConst, Values, B).release();
  // Store `MapTagVec[nextIndex]` in Tags
  Store = std::make_unique<StoreInst>(
              getFuncConstInt(F, MapTagVec[nextIndex], TYPE32), Tags, B)
              .release();

  BasicBlock *Router =
      BasicBlock::Create(F.getContext(), "obfuscatorFlt", &F, B);
  B->moveBefore(Router);
  BranchInst::Create(Router, B);

  // Store `MAP_CHANGE` in `Values`
  Store = std::make_unique<StoreInst>(BasisConst, Values, Router).release();
  ConstantInt *PrimeConst = ConstantInt::get(T, MAP_PRIME);
  LoadInst *OptValue =
      std::make_unique<LoadInst>(T, Values, "Values", Router).release();
  LoadInst *OptTag =
      std::make_unique<LoadInst>(T, Tags, "Tags", Router).release();
  BinaryOperator *GetValue =
      BinaryOperator::Create(BinaryOperator::Xor, OptTag, OptValue, "", Router);
  // (Tags ^ Values) * MAP_PRIME
  GetValue = BinaryOperator::Create(BinaryOperator::Mul, GetValue, PrimeConst,
                                    "", Router);
  Store = std::make_unique<StoreInst>(GetValue, Values, Router).release();
  // switch(MapValueVec[nextIndex])
  SwitchInst *CaseInst = SwitchInst::Create(GetValue, Router, 0, Router);
  if (!updateCaseInst(*CaseInst, *Router)) {
    report_fatal_error("Obfuscator failed to update case intructions!");
  }
  if (!updateTags(F, *OptTag, *Router)) {
    report_fatal_error("Obfuscator failed to update case tags!");
  }
  handleRegStack(F);
}

void ControlFlowObfuscator::doFltObfuse(Module &M) {
  initializeLowerSwitchLegacyPassPass(*PassRegistry::getPassRegistry());
  for (auto &F : M) {
    if (!needObfuse(F, "obf-cf-flatten")) {
      continue;
    }
    doFltObfuse(F);
  }
}

bool ControlFlowObfuscator::needObfuse(Function &F, std::string Owner) {
  if (F.isDeclaration() || F.hasAvailableExternallyLinkage() != 0)
    return false;
  auto FName = F.getName().str();
  if (!this->ObfConfig->needObfuse(FName, Owner))
    return false;
  return true;
}

PreservedAnalyses ControlFlowObfuscator::run(Module &M,
                                             ModuleAnalysisManager &AM) {
  this->ObfConfig = AM.getResult<ObfConfigAnalysis>(M);
  if (EnableConfigBcf)
    doBcfObfuse(M);

  if (EnableConfigFlatten)
    doFltObfuse(M);

  return PreservedAnalyses::all();
}

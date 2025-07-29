//===------------------------- DataObfuscator.cpp -------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// The data obfuscation pass.
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/TypeFinder.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/PassRegistry.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"
#include "llvm/Transforms/Obfuscator/DataObfuscator.h"
#include <iostream>

using namespace llvm;

extern cl::opt<bool> EnableConfigObfString;
extern cl::opt<bool> EnableConfigObfConst;

namespace {
const int BUILD_GEP_NUM = 2;
const int ROUTE_METHOD = 2;
const int ROUTE_VALUE = 3;
const int INT_TYPE = 64;
const int COMPUTE_TIMES = 32;
const int RAND_LEN = 8;
} // end anonymous namespace

StringRef DataObfuscator::getGlobalString(GlobalVariable &G) {
  Constant *C =
      dyn_cast<Constant>(G.getInitializer());
  if (C == nullptr) {
    return StringRef("", 0);
  }
  // string data is stored at index 2
  C = C->getAggregateElement(2);
  if (C == nullptr) {
    return StringRef("", 0);
  }
  ConstantDataSequential *CDS =
      dyn_cast<ConstantDataSequential>(C);
  if (CDS == nullptr)
    return StringRef("", 0);
  return CDS->isString() ? CDS->getAsString() : StringRef("", 0);
}

char *DataObfuscator::getGlobalStringData(GlobalVariable &G,
                                          unsigned int &Len) {
  char *Data = nullptr;
  uint64_t Num, ByteSize;
  Len = 0;
  if (!G.getName().contains(StringRef("const_cjstring_data"))) {
    return nullptr;
  }
  Constant *C =
      dyn_cast<Constant>(G.getInitializer());

  if (C == nullptr) {
    return nullptr;
  }

  // string data is stored at index 2
  C = C->getAggregateElement(2);
  if (C == nullptr) {
    return nullptr;
  }

  ConstantDataSequential *CDS =
      dyn_cast<ConstantDataSequential>(C);
  if (CDS == nullptr) {
    return nullptr;
  }

  Data = const_cast<char *>(CDS->getRawDataValues().data());
  Num = CDS->getNumElements();
  ByteSize = CDS->getElementByteSize();
  if (Num == 0 || Num > UINT32_MAX || ByteSize >= UINT32_MAX / Num) {
    return nullptr;
  }
  Len = Num * ByteSize;

  return Data;
}

bool DataObfuscator::needObfuseString(GlobalVariable &G) {
  if (!G.isConstant() || !G.hasInitializer())
    return false;
  unsigned int Len;
  char *Data = getGlobalStringData(G, Len);
  if (Data == nullptr || Len == 0) {
    return false;
  }

  return true;
}

bool DataObfuscator::cmpGlb(GlobalVariable *&FG, GlobalVariable *&SG) {
  std::string F = getGlobalString(*FG).str();
  std::string S = getGlobalString(*SG).str();
  return F.compare(S) < 0;
}

void DataObfuscator::stripGlobalString(Module &M) {
  std::list<GlobalVariable *> GvList;
  for (auto &G : M.globals()) {
    if (needObfuseString(G))
      GvList.push_back(&G);
  }

  GvList.sort(cmpGlb);
  std::list<GlobalVariable *>::iterator IG;
  for (IG = GvList.begin(); IG != GvList.end();) {
    GlobalVariable *GV1 = *IG;
    GlobalVariable *GV2 = nullptr;
    StringRef GVS1 = getGlobalString(*GV1);
    IG++;
    while (IG != GvList.end() &&
           (GV2 = *IG, GVS1.equals(getGlobalString(*GV2)))) {
      GV2->replaceAllUsesWith(
          ConstantExpr::getPointerCast(GV1, GV2->getType()));
      IG = GvList.erase(IG);
      GV2->eraseFromParent();
    }
  }
}

void DataObfuscator::replaceGlobalVariable(
    Module &M, GlobalVariable &G,
    std::vector<std::unique_ptr<ObfVar>> &ObfGVec) {
  GlobalVariable *Replace = nullptr;
  std::unique_ptr<ObfVar> OV = nullptr;
  char *Data = nullptr;
  unsigned int Len;

  Data = getGlobalStringData(G, Len);
  if (Data == nullptr || Len == 0)
    return;

  Replace = std::make_unique<GlobalVariable>(
                M, G.getType()->getElementType(), false, G.getLinkage(),
                nullptr, G.getName(), nullptr, G.getThreadLocalMode(),
                G.getType()->getAddressSpace())
                .release();
  if (Replace == nullptr)
    return;

  Replace->setInitializer(G.getInitializer());

  OV = std::make_unique<ObfVar>();
  if (OV == nullptr)
    return;

  OV->OriVar = &G;
  OV->ObfVar = Replace;
  OV->Key = this->ObfConfig->getRandNum();
  OV->ReplaceName = G.getName().str();
  OV->Len = Len;

  for (unsigned int Index = 0; Index < Len; Index++) {
    Data[Index] = (static_cast<uint8_t>(Data[Index])) ^ OV->Key;
  }

  ObfGVec.push_back(std::move(OV));
  G.replaceAllUsesWith(Replace);
}

void DataObfuscator::doObfuseString(Module &M) {
  std::vector<GlobalVariable *> GVec;
  std::vector<std::unique_ptr<ObfVar>> ObfGVec;
  for (auto &G : M.globals()) {
    if (needObfuseString(G))
      GVec.push_back(&G);
  }

  for (auto &G : GVec) {
    replaceGlobalVariable(M, *G, ObfGVec);
  }

  for (auto &OV : ObfGVec) {
    OV->OriVar->eraseFromParent();
    OV->ObfVar->setName(OV->ReplaceName);
  }

  if (ObfGVec.size() != 0)
    addDecodeFunction(M, ObfGVec);
}

void DataObfuscator::doDecode(LLVMContext &CTX, Value &V, IRBuilder<> &Builder,
                              const std::unique_ptr<ObfVar> &ObfGv) {
  Type *RetType = llvm::Type::getInt8Ty(CTX);
  LoadInst *LoadElement = Builder.CreateLoad(RetType, &V, "");
  Value *DecodeRet =
      Builder.CreateXor(LoadElement, Builder.getInt8(ObfGv->Key), "");
  Builder.CreateStore(DecodeRet, &V, false);
}

void DataObfuscator::insertDecodeBlock(Module &M, Function &DecodeFunc,
                                       IRBuilder<> &Builder,
                                       std::unique_ptr<ObfVar> &ObfGv) {
  LLVMContext &CTX = M.getContext();
  BasicBlock *InsertBlock = Builder.GetInsertBlock();
  if (InsertBlock == nullptr)
    return;

  BasicBlock *NewBlock =
      BasicBlock::Create(CTX, "obfuscatorDecode", &DecodeFunc);
  if (NewBlock == nullptr)
    return;
  if (Builder.CreateBr(NewBlock) == nullptr)
    return;

  Builder.SetInsertPoint(NewBlock);

  PHINode *CharIndex =
      Builder.CreatePHI(Type::getInt32Ty(CTX), BUILD_GEP_NUM, "");
  if (CharIndex == nullptr)
    return;
  CharIndex->addIncoming(Builder.getInt32(0), InsertBlock);
  unsigned AS = ObfGv->ObfVar->getType()->getPointerAddressSpace();
  Value *CastValue =
      Builder.CreateBitCast(ObfGv->ObfVar, Builder.getInt8PtrTy(AS), "");
  // get string base
  CastValue = Builder.CreateGEP(Builder.getInt8Ty(), CastValue, Builder.getInt32(16), "");
  Value *GEP = Builder.CreateGEP(Builder.getInt8Ty(), CastValue, CharIndex, "");
  if (GEP == nullptr)
    return;

  doDecode(CTX, *GEP, Builder, ObfGv);

  Value *NextCharIndex = Builder.CreateAdd(CharIndex, Builder.getInt32(1), "");
  if (NextCharIndex == nullptr)
    return;
  Value *IsOver =
      Builder.CreateICmpULT(CharIndex, Builder.getInt32(ObfGv->Len - 1), "");
  if (IsOver == nullptr)
    return;
  InsertBlock = Builder.GetInsertBlock();
  if (InsertBlock == nullptr)
    return;
  BasicBlock *LastBlock =
      BasicBlock::Create(CTX, "obfuscatorDecode", &DecodeFunc);
  if (Builder.CreateCondBr(IsOver, InsertBlock, LastBlock) == nullptr)
    return;

  Builder.SetInsertPoint(LastBlock);
  CharIndex->addIncoming(NextCharIndex, InsertBlock);
}

void DataObfuscator::addDecodeFunction(
    Module &M, std::vector<std::unique_ptr<ObfVar>> &ObfGVec) {
  Function *DecodeFunc = createDecodeFunction(M);
  if (DecodeFunc == nullptr)
    return;

  LLVMContext &CTX = M.getContext();
  BasicBlock *E = BasicBlock::Create(CTX, "obfuscatorDecode", DecodeFunc);
  if (E == nullptr)
    return;

  IRBuilder<> Builder(CTX);
  Builder.SetInsertPoint(E);

  for (unsigned int Index = 0; Index < ObfGVec.size(); Index++)
    insertDecodeBlock(M, *DecodeFunc, Builder, ObfGVec[Index]);
  Builder.CreateRetVoid();
}

Function *DataObfuscator::createDecodeFunction(Module &M) {
  std::vector<Type *> RetTypeArgs;
  LLVMContext &CTX = M.getContext();
  Type *RetType = Type::getVoidTy(CTX);
  if (RetType == nullptr)
    return nullptr;

  FunctionType *FuncType = FunctionType::get(RetType, RetTypeArgs, false);
  if (FuncType == nullptr)
    return nullptr;

  unsigned int RandNum = this->ObfConfig->getRandNum();
  std::string FuncName = std::to_string(RandNum).substr(0, RAND_LEN);
  FuncName = FuncName + this->ObfConfig->hash(M.getName(), true);
#if LLVM_VERSION_MAJOR <= 8
  Constant *C = M.getOrInsertFunction(".string_decode" + FuncName, FuncType);
  if (C == nullptr)
    return nullptr;
  Function *DecodeFunc = dyn_cast<Function>(C);
#else
  FunctionCallee C =
      M.getOrInsertFunction(".string_decode" + FuncName, FuncType);
  Function *DecodeFunc = dyn_cast<Function>(C.getCallee());
#endif

  if (DecodeFunc == nullptr)
    return nullptr;

  DecodeFunc->setCallingConv(CallingConv::Fast);
  insertDecodeFunction(M, C);
  return DecodeFunc;
}

static void appendToGlobalCtorArray(Module &M, Function *F,
                                    int Priority, Constant *Data) {
  std::string GlobalCtorName = "llvm.global_ctors";
  IRBuilder<> IRB(M.getContext());
  FunctionType *FnTy = FunctionType::get(IRB.getVoidTy(), false);

  // Get the current set of static global constructors and add the new ctor
  // to the list.
  SmallVector<Constant *, 1> CurrentCtors;
  StructType *EltTy = StructType::get(
      IRB.getInt32Ty(), PointerType::getUnqual(FnTy), IRB.getInt8PtrTy());
  if (GlobalVariable *GVCtor = M.getNamedGlobal(GlobalCtorName)) {
    if (Constant *Init = GVCtor->getInitializer()) {
      unsigned n = Init->getNumOperands();
      CurrentCtors.reserve(n + 1);
      for (unsigned i = 0; i != n; ++i)
        CurrentCtors.push_back(cast<Constant>(Init->getOperand(i)));
    }
    GVCtor->eraseFromParent();
  }

  // Build a 3 field global_ctor entry.  We don't take a comdat key.
  Constant *CSVals[] = {
      IRB.getInt32(Priority),
      F,
      Data ? ConstantExpr::getPointerCast(Data, IRB.getInt8PtrTy())
           : Constant::getNullValue(IRB.getInt8PtrTy())
  };
  Constant *RuntimeCtorInit =
      ConstantStruct::get(EltTy, makeArrayRef(CSVals, EltTy->getNumElements()));

  CurrentCtors.push_back(RuntimeCtorInit);

  // Create a new initializer.
  ArrayType *AT = ArrayType::get(EltTy, CurrentCtors.size());
  Constant *NewInit = ConstantArray::get(AT, CurrentCtors);

  // Create the new global variable and replace all uses of
  // the old global variable with the new one.
  (void)new GlobalVariable(M, NewInit->getType(), false,
                           GlobalValue::AppendingLinkage, NewInit, GlobalCtorName);
}

static void appendToUsedList(Module &M, ArrayRef<GlobalValue *> Values) {
  std::string LLVMUsedName = "llvm.used";
  GlobalVariable *GV = M.getGlobalVariable(LLVMUsedName);
  SmallPtrSet<Constant *, 1> InitAsSet;
  SmallVector<Constant *, 1> Init;
  if (GV) {
    if (GV->hasInitializer()) {
      auto *CA = cast<ConstantArray>(GV->getInitializer());
      for (auto &Op : CA->operands()) {
        Constant *C = cast_or_null<Constant>(Op);
        if (InitAsSet.insert(C).second)
          Init.push_back(C);
      }
    }
    GV->eraseFromParent();
  }

  Type *Int8PtrTy = llvm::Type::getInt8PtrTy(M.getContext());
  for (auto *V : Values) {
    Constant *C = ConstantExpr::getPointerBitCastOrAddrSpaceCast(V, Int8PtrTy);
    if (InitAsSet.insert(C).second)
      Init.push_back(C);
  }

  if (Init.empty()) {
    return;
  }

  ArrayType *ATy = ArrayType::get(Int8PtrTy, Init.size());
  GV = new llvm::GlobalVariable(M, ATy, false, GlobalValue::AppendingLinkage,
                                ConstantArray::get(ATy, Init), LLVMUsedName);
  GV->setSection("llvm.metadata");
}

void DataObfuscator::insertDecodeFunction(Module &M, FunctionCallee F) {
  std::string CtorName = "obf.string.ctor";
  Function *Ctor = Function::createWithDefaultAttr(
      FunctionType::get(Type::getVoidTy(M.getContext()), false),
      GlobalValue::InternalLinkage, 0, CtorName, &M);
  Ctor->addFnAttr(Attribute::NoUnwind);
  BasicBlock *CtorBB = BasicBlock::Create(M.getContext(), "", Ctor);
  ReturnInst::Create(M.getContext(), CtorBB);
  appendToUsedList(M, {Ctor});

  IRBuilder<> IRB(Ctor->getEntryBlock().getTerminator());
  IRB.CreateCall(F, {});

  appendToGlobalCtorArray(M, Ctor, 1, nullptr);
}

bool DataObfuscator::isIntrinsic(Instruction &I) {
#if LLVM_VERSION_MAJOR >= 11
  Function *CalledFunc = dyn_cast<CallBase>(&I)->getCalledFunction();
  if (CalledFunc == nullptr)
    CalledFunc = dyn_cast<Function>(
        dyn_cast<CallBase>(&I)->getCalledOperand()->stripPointerCasts());
#else
  CallSite CS(&I);
  Function *CalledFunc = CS.getCalledFunction();
  if (CalledFunc == nullptr)
    CalledFunc = dyn_cast<Function>(CS.getCalledValue()->stripPointerCasts());
#endif
  if (CalledFunc == nullptr)
    return false;
  if (CalledFunc->isIntrinsic())
    return true;
  return false;
}

Value *DataObfuscator::addConstZero(Instruction &I, ConstantInt &V) {
  IntegerType *TransType = V.getType();
  IntegerType *T = IntegerType::get(I.getParent()->getContext(), INT_TYPE);
  IRBuilder<> Builder(&I);
  auto M = Builder.GetInsertBlock()->getModule();
  Value *Trans = Builder.CreateIntCast(&V, T, true);

  uint64_t Num = V.getValue().getLimitedValue();
  uint64_t ObfNum = this->ObfConfig->getRandNum();

  auto G1 = new GlobalVariable(*M, T, false,
    GlobalValue::InternalLinkage, static_cast<Constant *>(ConstantInt::get(T, ObfNum, false)), "ConstZero1");
  auto Zero = ConstantInt::get(T, 0);

  auto L1 = std::make_unique<LoadInst>(T, static_cast<Value *>(G1), "", true, &I).release();

  if (ObfNum % ROUTE_METHOD == 0) {
    auto G2 = new GlobalVariable(*M, T, false,
      GlobalValue::InternalLinkage, static_cast<Constant *>(ConstantInt::get(T, Num ^ ObfNum, false)), "ConstZero2");
    auto L2 = std::make_unique<LoadInst>(T, static_cast<Value *>(G2), "", true, &I).release();
    auto OP1 = Builder.CreateAdd(L1, Zero);
    auto OP2 = Builder.CreateXor(L2, Zero);
    Trans = Builder.CreateXor(OP1, OP2);
  } else {
    auto G2 = new GlobalVariable(*M, T, false,
      GlobalValue::InternalLinkage, static_cast<Constant *>(ConstantInt::get(T, Num - ObfNum, false)), "ConstZero2");
    auto L2 = std::make_unique<LoadInst>(T, static_cast<Value *>(G2), "", true, &I).release();
    auto OP1 = Builder.CreateXor(L1, Zero);
    auto OP2 = Builder.CreateXor(L2, Zero);
    Trans = Builder.CreateAdd(OP1, OP2);
  }

  Trans = Builder.CreateIntCast(Trans, TransType, true);
  return Trans;
}

bool DataObfuscator::isImmCallArg(Instruction &I, unsigned int Index) {
  if (isa<CallInst>(I)) {
    CallBase *CB = dyn_cast<CallBase>(&I);
    if (Index < CB->arg_size() && CB->paramHasAttr(Index, Attribute::ImmArg))
      return true;
  }
  return false;
}

void DataObfuscator::handleConst(Instruction &I, int Index) {
  ConstantInt *ConstInt = dyn_cast<ConstantInt>(&*(I.getOperand(Index)));
  if (ConstInt == nullptr)
    return;

  // don't obfuse call argument with ImmArg attribute
  if (isImmCallArg(I, Index))
    return;

  uint64_t V = ConstInt->getValue().getLimitedValue();
  if (V == 0 || V == UINT64_MAX)
    return;

  Value *NewVal = addConstZero(I, *ConstInt);
  if (NewVal == nullptr)
    return;
  I.setOperand(Index, NewVal);
}

void DataObfuscator::initInstList(Function &F, std::vector<Value *> &FunctionLocalVariables) {
  for (auto &B : F) {
    for (BasicBlock::iterator IT = B.getFirstInsertionPt(); IT != B.end();
         IT++) {
      Instruction *I = static_cast<Instruction *>(&*IT);
      if (I == nullptr)
        continue;
      Type *T = I->getType();
      if (T == nullptr)
        continue;
      if (T->isIntegerTy() && (dyn_cast<ConstantInt>(I) == nullptr))
        FunctionLocalVariables.push_back(I);
    }
  }
}

Value *DataObfuscator::bitCalTrans(IRBuilder<> &Builder, Instruction &I, Value &X,
                                   IntegerType &TransType) {
  Value *Trans = nullptr;
  IntegerType *T = IntegerType::get(Builder.getContext(), INT_TYPE);
  uint64_t R1 = this->ObfConfig->getRandNum();
  R1 = (R1 << COMPUTE_TIMES) + this->ObfConfig->getRandNum();
  uint64_t R2 = ~R1;
  uint64_t R3 = 0xffffffffffffffff;

  auto M = Builder.GetInsertBlock()->getModule();
  auto G1 = new GlobalVariable(*M, T, false,
    GlobalValue::InternalLinkage, static_cast<Constant *>(ConstantInt::get(T, R1, false)), "G1");
  auto G2 = new GlobalVariable(*M, T, false,
    GlobalValue::InternalLinkage, static_cast<Constant *>(ConstantInt::get(T, R2, false)), "G2");
  auto G3 = new GlobalVariable(*M, T, false,
    GlobalValue::InternalLinkage, static_cast<Constant *>(ConstantInt::get(T, R3, false)), "G3");

  auto L1 = std::make_unique<LoadInst>(T, static_cast<Value *>(G1), "", true, &I).release();
  auto L2 = std::make_unique<LoadInst>(T, static_cast<Value *>(G2), "", true, &I).release();
  auto L3 = std::make_unique<LoadInst>(T, static_cast<Value *>(G3), "", true, &I).release();

  Value *Temp = Builder.CreateNot(&X);
  Temp = Builder.CreateOr(Temp, static_cast<Value *>(L1));
  Trans = Builder.CreateAnd(&X, static_cast<Value *>(L2));
  Trans = Builder.CreateAdd(Trans, Temp);
  Trans = Builder.CreateXor(Trans, static_cast<Value *>(L3));
  Trans = Builder.CreateIntCast(Trans, &TransType, false);

  return Trans;
}

Value *DataObfuscator::logicCalTrans(IRBuilder<> &Builder, Instruction &I, Value &X,
                                     Value &Y, IntegerType &TransType) {
  Value *Trans = nullptr;
  IntegerType *T = IntegerType::get(Builder.getContext(), INT_TYPE);
  auto M = Builder.GetInsertBlock()->getModule();
  Value *L1 = nullptr;
  Value *L2 = nullptr;
  if (dyn_cast<llvm::ConstantInt>(&X)) {
    auto G1 = new GlobalVariable(*M, T, false, GlobalValue::InternalLinkage, static_cast<Constant *>(&X), "G1");
    L1 = static_cast<Value *>(std::make_unique<LoadInst>(T, static_cast<Value *>(G1), "", true, &I).release());
  } else {
    L1 = &X;
  }

  if (dyn_cast<llvm::ConstantInt>(&Y)) {
    auto G2 = new GlobalVariable(*M, T, false, GlobalValue::InternalLinkage, static_cast<Constant *>(&Y), "G2");
    L2 = static_cast<Value *>(std::make_unique<LoadInst>(T, static_cast<Value *>(G2), "", true, &I).release());
  } else {
    L2 = &Y;
  }
  auto A = Builder.CreateNot(L1);
  auto B = Builder.CreateNot(L2);
  A = Builder.CreateAnd(A, B);
  B = Builder.CreateOr(L1, L2);
  Trans = Builder.CreateAnd(A, B);
  Trans = Builder.CreateIntCast(Trans, &TransType, false);
  return Trans;
}

Value *DataObfuscator::handleZero(Instruction &I, ConstantInt &V,
                                  std::vector<Value *> &CandidateValues) {
  IntegerType *TransType = V.getType();
  IntegerType *T = IntegerType::get(I.getParent()->getContext(), INT_TYPE);
  Value *Trans = nullptr;

  if (CandidateValues.size() <= 0) {
    return Trans;
  }

  IRBuilder<> Builder(&I);
  uint32_t Index1 = this->ObfConfig->getRandNum() % CandidateValues.size();
  Value *Temp1 = CandidateValues[Index1];
  Value *X = Builder.CreateIntCast(Temp1, T, false);
  if (CandidateValues.size() == 1) {
    Trans = bitCalTrans(Builder, I, *X, *TransType);
    recordInst(Trans, CandidateValues);
  } else {
    uint32_t Index2;
    do {
      Index2 = this->ObfConfig->getRandNum() % CandidateValues.size();
    } while (Index2 == Index1);
    Value *Temp2 = CandidateValues[Index2];
    Value *Y = Builder.CreateIntCast(Temp2, T, false);
    uint32_t Route = this->ObfConfig->getRandNum() % ROUTE_VALUE;
    if (Route == 0) {
      Trans = bitCalTrans(Builder, I, *X, *TransType);
      recordInst(Trans, CandidateValues);
    } else if (Route == 1) {
      Trans = logicCalTrans(Builder, I, *X, *Y, *TransType);
      recordInst(Trans, CandidateValues);
    }
  }
  return Trans;
}

void DataObfuscator::handleInstWithZero(Instruction &I,
                                        std::vector<Value *> &CandidateValues) {
  for (unsigned int Index = 0; Index < I.getNumOperands(); Index++) {
    if (isImmCallArg(I, Index))
      continue;
    ConstantInt *CI = dyn_cast<ConstantInt>(&*(I.getOperand(Index)));
    if (CI == nullptr || !CI->isZero())
      continue;
    Value *NewVal = handleZero(I, *CI, CandidateValues);
    if (NewVal == nullptr)
      continue;
    I.setOperand(Index, NewVal);
  }
}

void DataObfuscator::doObfuseConst(Function &F, BasicBlock &B,
                                   std::vector<Value *> &FunctionLocalVariables,
                                   std::vector<Value *> &CandidateValues) {
  // Record candidate values from predecessor blocks.
  for (BasicBlock *PreBlock = B.getSinglePredecessor(); PreBlock != nullptr;
       PreBlock = PreBlock->getSinglePredecessor()) {
    // Only record values from dominated blocks.
    if (PreBlock->getTerminator()->getNumSuccessors() > 1)
      continue;
    for (BasicBlock::iterator IT = PreBlock->getFirstInsertionPt();
         IT != PreBlock->end(); IT++) {
      Instruction *I = static_cast<Instruction *>(&*IT);
      if (!needObfuse(*I))
        continue;
      if (count(FunctionLocalVariables.begin(), FunctionLocalVariables.end(), I)) {
        recordInst(I, CandidateValues);
      }
    }
  }
  for (BasicBlock::iterator IT = B.getFirstInsertionPt(); IT != B.end(); IT++) {
    Instruction *I = static_cast<Instruction *>(&*IT);
    if (I == nullptr)
      continue;
    if (!needObfuse(*I))
      continue;
    if (!isa<GetElementPtrInst>(I) && !isa<AllocaInst>(I) &&
        !isa<SwitchInst>(I)) {
      handleInstWithZero(*I, CandidateValues);
    }
    if (count(FunctionLocalVariables.begin(), FunctionLocalVariables.end(), I))
      recordInst(I, CandidateValues);
  }
}

void DataObfuscator::recordInst(Value *V, std::vector<Value *> &CandidateValues) {
  if (V != nullptr && V->getType()->isIntegerTy() &&
      (dyn_cast<llvm::ConstantInt>(V) == nullptr))
    CandidateValues.push_back(V);
}

bool DataObfuscator::needObfuse(Instruction &I) {
  for (unsigned int Index = 0; Index < I.getNumOperands(); Index++) {
    Value *V = I.getOperand(Index);
    std::string S = V->getName().str();
    if (S.find("gc.statepoint") != S.npos)
      return false;
  }
  return true;
}

static bool isDivInstruction(Instruction &I) {
  return Instruction::isIntDivRem(I.getOpcode()) ||
         I.getOpcode() == Instruction::FDiv ||
         I.getOpcode() == Instruction::FRem;
}

static bool blockHasDIvInstruction(BasicBlock &B) {
  for (auto &I : B) {
    if (isDivInstruction(I)) {
      return true;
    }
  }
  return false;
}

static bool succHasDivInstruction(BasicBlock &B) {
  unsigned int SuccNum = B.getTerminator()->getNumSuccessors();
  unsigned int Index = 0;
  for (Index = 0; Index < SuccNum; Index++) {
    auto Succ = B.getTerminator()->getSuccessor(Index);
    if (blockHasDIvInstruction(*Succ)) {
      return true;
    }
  }
  return false;
}

void DataObfuscator::doObfuseConst(Function &F) {
  std::vector<Value *> FunctionLocalVariables;
  std::vector<Value *> CandidateValues;
  initInstList(F, FunctionLocalVariables);
  for (auto &B : F) {
    // Cangjie compiler frontend and backend will generate zero check for Div
    // instructions. If the divisor is a non-zero constant value, the frontend
    // will not  generate checks for it on O2. But if the non-zero divisor is
    // obfuscated, the backend will treat it as a variable and try to generate
    // stackmap for the function, and this will case abort since the frontend
    // does not generate stackmap for it.
    if (blockHasDIvInstruction(B) || succHasDivInstruction(B)) {
      continue;
    }
    for (auto IT = B.getFirstInsertionPt(); IT != B.end(); IT++) {
      Instruction *I = static_cast<Instruction *>(&*IT);
      if (I == nullptr)
        continue;

      if (!needObfuse(*I))
        continue;

      if (isa<GetElementPtrInst>(I) || isa<AllocaInst>(I))
        continue;
      if (isa<SwitchInst>(I)) {
        handleConst(*I, 0);
        continue;
      }
      for (unsigned int Index = 0; Index < I->getNumOperands(); Index++) {
        handleConst(*I, Index);
      }
    }
    // make sure CandidateValues is not empty.
    CandidateValues.push_back(ConstantInt::get(Type::getInt64Ty(F.getParent()->getContext()),
        this->ObfConfig->getRandNum(), false));
    doObfuseConst(F, B, FunctionLocalVariables, CandidateValues);
    CandidateValues.clear();
  }
  FunctionLocalVariables.clear();
}

void DataObfuscator::doObfuseConst(Module &M) {
  for (auto &F : M) {
    if (F.isDeclaration() || F.hasAvailableExternallyLinkage() != 0)
      continue;
    auto FName = F.getName().str();
    if (!this->ObfConfig->needObfuse(FName, "obf-const"))
      continue;
    doObfuseConst(F);
  }
}

PreservedAnalyses DataObfuscator::run(Module &M, ModuleAnalysisManager &AM) {
  this->ObfConfig = AM.getResult<ObfConfigAnalysis>(M);
  if (EnableConfigObfString) {
    stripGlobalString(M);
    doObfuseString(M);
  }
  if (EnableConfigObfConst) {
    doObfuseConst(M);
  }
  return PreservedAnalyses::all();
}

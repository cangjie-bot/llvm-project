//===---------------------- ThreadSanitizerPass.cpp --------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// The thread sanitizer pass.
//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/Passes.h"
#include "llvm/InitializePasses.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/SafepointIRVerifier.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Instrumentation.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

using namespace llvm;

#define DEBUG_TYPE "tsan"

namespace {

struct ThreadSanitizer {
  ThreadSanitizer() {
  }

  bool sanitizeFunction(Function &F);

private:
  void initialize(Module &M);
  bool instrumentAtomic(Instruction *I, const DataLayout &DL);
  bool instrumentCJAtomic(Instruction *I, const DataLayout &DL);
  int getMemoryAccessFuncIndex(Type *OrigTy, Value *Addr, const DataLayout &DL);

  Type *IntptrTy;
  // Accesses sizes are powers of two: 1, 2, 4, 8, 16.
  static const size_t kNumberOfAccessSizes = 5;
  FunctionCallee TsanAtomicLoad[kNumberOfAccessSizes];
  FunctionCallee TsanAtomicStore[kNumberOfAccessSizes];
  FunctionCallee TsanAtomicRMW[AtomicRMWInst::LAST_BINOP + 1]
                              [kNumberOfAccessSizes];
  FunctionCallee TsanAtomicCAS[kNumberOfAccessSizes];
  FunctionCallee TsanAtomicThreadFence;
  FunctionCallee TsanAtomicSignalFence;
};
}  // namespace

class ThreadSanitizerPass : public FunctionPass {
public:
  static char ID;
  ThreadSanitizerPass();
  bool runOnFunction(Function &F) override;
  StringRef getPassName() const override;
};

char ThreadSanitizerPass::ID = 0;

bool ThreadSanitizerPass::runOnFunction(Function &F) {
  ThreadSanitizer TSan;
  auto Res = TSan.sanitizeFunction(F);
  return Res;
}

StringRef ThreadSanitizerPass::getPassName() const {
  return "Cangjie Thread Sanitizer pass";
}

ThreadSanitizerPass::ThreadSanitizerPass() : FunctionPass(ID) {
  initializeThreadSanitizerPassPass(*PassRegistry::getPassRegistry());
}

void ThreadSanitizer::initialize(Module &M) {
  const DataLayout &DL = M.getDataLayout();
  IntptrTy = DL.getIntPtrType(M.getContext());

  IRBuilder<> IRB(M.getContext());
  AttributeList Attr;
  Attr = Attr.addFnAttribute(M.getContext(), Attribute::NoUnwind);

  IntegerType *OrdTy = IRB.getInt32Ty();
  for (size_t i = 0; i < kNumberOfAccessSizes; ++i) {
    const unsigned ByteSize = 1U << i;
    const unsigned BitSize = ByteSize * 8;
    std::string ByteSizeStr = utostr(ByteSize);
    std::string BitSizeStr = utostr(BitSize);

    Type *Ty = Type::getIntNTy(M.getContext(), BitSize);
    Type *PtrTy = Ty->getPointerTo();
    SmallString<32> AtomicLoadName("__tsan_atomic" + BitSizeStr + "_load");
    {
      AttributeList AL = Attr;
      AL = AL.addParamAttribute(M.getContext(), 1, Attribute::ZExt);
      TsanAtomicLoad[i] =
          M.getOrInsertFunction(AtomicLoadName, AL, Ty, PtrTy, OrdTy);
    }

    SmallString<32> AtomicStoreName("__tsan_atomic" + BitSizeStr + "_store");
    {
      AttributeList AL = Attr;
      AL = AL.addParamAttribute(M.getContext(), 1, Attribute::ZExt);
      AL = AL.addParamAttribute(M.getContext(), 2, Attribute::ZExt);
      TsanAtomicStore[i] = M.getOrInsertFunction(
          AtomicStoreName, AL, IRB.getVoidTy(), PtrTy, Ty, OrdTy);
    }

    for (unsigned Op = AtomicRMWInst::FIRST_BINOP;
         Op <= AtomicRMWInst::LAST_BINOP; ++Op) {
      TsanAtomicRMW[Op][i] = nullptr;
      const char *NamePart = nullptr;
      if (Op == AtomicRMWInst::Xchg)
        NamePart = "_exchange";
      else if (Op == AtomicRMWInst::Add)
        NamePart = "_fetch_add";
      else if (Op == AtomicRMWInst::Sub)
        NamePart = "_fetch_sub";
      else if (Op == AtomicRMWInst::And)
        NamePart = "_fetch_and";
      else if (Op == AtomicRMWInst::Or)
        NamePart = "_fetch_or";
      else if (Op == AtomicRMWInst::Xor)
        NamePart = "_fetch_xor";
      else if (Op == AtomicRMWInst::Nand)
        NamePart = "_fetch_nand";
      else
        continue;
      SmallString<32> RMWName("__tsan_atomic" + itostr(BitSize) + NamePart);
      {
        AttributeList AL = Attr;
        AL = AL.addParamAttribute(M.getContext(), 1, Attribute::ZExt);
        AL = AL.addParamAttribute(M.getContext(), 2, Attribute::ZExt);
        TsanAtomicRMW[Op][i] =
            M.getOrInsertFunction(RMWName, AL, Ty, PtrTy, Ty, OrdTy);
      }
    }

    SmallString<32> AtomicCASName("__tsan_atomic" + BitSizeStr +
                                  "_compare_exchange_val");
    {
      AttributeList AL = Attr;
      AL = AL.addParamAttribute(M.getContext(), 1, Attribute::ZExt);
      AL = AL.addParamAttribute(M.getContext(), 2, Attribute::ZExt);
      AL = AL.addParamAttribute(M.getContext(), 3, Attribute::ZExt);
      AL = AL.addParamAttribute(M.getContext(), 4, Attribute::ZExt);
      TsanAtomicCAS[i] = M.getOrInsertFunction(AtomicCASName, AL, Ty, PtrTy, Ty,
                                               Ty, OrdTy, OrdTy);
    }
  }

  {
    AttributeList AL = Attr;
    AL = AL.addParamAttribute(M.getContext(), 0, Attribute::ZExt);
    TsanAtomicThreadFence = M.getOrInsertFunction("__tsan_atomic_thread_fence",
                                                  AL, IRB.getVoidTy(), OrdTy);
  }
  {
    AttributeList AL = Attr;
    AL = AL.addParamAttribute(M.getContext(), 0, Attribute::ZExt);
    TsanAtomicSignalFence = M.getOrInsertFunction("__tsan_atomic_signal_fence",
                                                  AL, IRB.getVoidTy(), OrdTy);
  }
}

static bool isCJAtomic(const Instruction *I) {
  const IntrinsicInst *II = dyn_cast<IntrinsicInst>(I);
  if (II == nullptr) {
    return false;
  }
  auto IID = II->getIntrinsicID();
  return isCJAtomicIntrinsic(IID);
}

static bool isTsanAtomic(const Instruction *I) {
  // TODO: Ask TTI whether synchronization scope is between threads.
  auto SSID = getAtomicSyncScopeID(I);
  if (!SSID)
    return false;
  if (isa<LoadInst>(I) || isa<StoreInst>(I))
    return SSID.value() != SyncScope::SingleThread;
  return true;
}

bool ThreadSanitizer::sanitizeFunction(Function &F) {
  initialize(*F.getParent());
  SmallVector<Instruction*, 8> AtomicAccesses;
  SmallVector<Instruction*, 8> CJAtomicAccesses;
  bool Res = false;
  const DataLayout &DL = F.getParent()->getDataLayout();
  for (auto &BB : F) {
    for (auto &Inst : BB) {
      if (isTsanAtomic(&Inst))
        AtomicAccesses.push_back(&Inst);
      else if (isCJAtomic(&Inst))
        CJAtomicAccesses.push_back(&Inst);
    }
  }

  // Instrument atomic memory accesses in any case (they can be used to
  // implement synchronization).
  for (auto Inst : AtomicAccesses) {
    Res |= instrumentAtomic(Inst, DL);
  }
  for (auto Inst : CJAtomicAccesses) {
    Res |= instrumentCJAtomic(Inst, DL);
  }
  return Res;
}

enum class TsanAtomicOrdering: uint32_t {
  Unordered = 0,
  Consume = 1,
  Acquire = 2,
  Release = 3,
  AcquireRelease = 4,
  SequentiallyConsistent = 5
};

static ConstantInt *createOrdering(IRBuilder<> *IRB, AtomicOrdering ord) {
  uint32_t v = 0;
  switch (ord) {
    case AtomicOrdering::NotAtomic:
      llvm_unreachable("unexpected atomic ordering!");
    case AtomicOrdering::Unordered:
      LLVM_FALLTHROUGH;
    case AtomicOrdering::Monotonic:
      v = static_cast<uint32_t>(TsanAtomicOrdering::Unordered);
      break;
    case AtomicOrdering::Acquire:
      v = static_cast<uint32_t>(TsanAtomicOrdering::Acquire);
      break;
    case AtomicOrdering::Release:
      v = static_cast<uint32_t>(TsanAtomicOrdering::Release);
      break;
    case AtomicOrdering::AcquireRelease:
      v = static_cast<uint32_t>(TsanAtomicOrdering::AcquireRelease);
      break;
    case AtomicOrdering::SequentiallyConsistent:
      v = static_cast<uint32_t>(TsanAtomicOrdering::SequentiallyConsistent);
      break;
  }
  return IRB->getInt32(v);
}

// Both llvm and ThreadSanitizer atomic operations are based on C++11/C1x
// standards.  For background see C++11 standard.  A slightly older, publicly
// available draft of the standard (not entirely up-to-date, but close enough
// for casual browsing) is available here:
// http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2011/n3242.pdf
// The following page contains more background information:
// http://www.hpl.hp.com/personal/Hans_Boehm/c++mm/

bool ThreadSanitizer::instrumentAtomic(Instruction *I, const DataLayout &DL) {
  InstrumentationIRBuilder IRB(I);
  if (LoadInst *LI = dyn_cast<LoadInst>(I)) {
    Value *Addr = LI->getPointerOperand();
    Type *OrigTy = LI->getType();
    int Idx = getMemoryAccessFuncIndex(OrigTy, Addr, DL);
    if (Idx < 0)
      return false;
    const unsigned ByteSize = 1U << Idx;
    const unsigned BitSize = ByteSize * 8;
    Type *Ty = Type::getIntNTy(IRB.getContext(), BitSize);
    Type *PtrTy = Ty->getPointerTo();
    Value *Args[] = {IRB.CreatePointerCast(Addr, PtrTy),
                     createOrdering(&IRB, LI->getOrdering())};
    Value *C = IRB.CreateCall(TsanAtomicLoad[Idx], Args);
    Value *Cast = IRB.CreateBitOrPointerCast(C, OrigTy);
    I->replaceAllUsesWith(Cast);
  } else if (StoreInst *SI = dyn_cast<StoreInst>(I)) {
    Value *Addr = SI->getPointerOperand();
    int Idx =
        getMemoryAccessFuncIndex(SI->getValueOperand()->getType(), Addr, DL);
    if (Idx < 0)
      return false;
    const unsigned ByteSize = 1U << Idx;
    const unsigned BitSize = ByteSize * 8;
    Type *Ty = Type::getIntNTy(IRB.getContext(), BitSize);
    Type *PtrTy = Ty->getPointerTo();
    Value *Args[] = {IRB.CreatePointerCast(Addr, PtrTy),
                     IRB.CreateBitOrPointerCast(SI->getValueOperand(), Ty),
                     createOrdering(&IRB, SI->getOrdering())};
    CallInst *C = CallInst::Create(TsanAtomicStore[Idx], Args);
    ReplaceInstWithInst(I, C);
  } else if (AtomicRMWInst *RMWI = dyn_cast<AtomicRMWInst>(I)) {
    Value *Addr = RMWI->getPointerOperand();
    int Idx =
        getMemoryAccessFuncIndex(RMWI->getValOperand()->getType(), Addr, DL);
    if (Idx < 0)
      return false;
    FunctionCallee F = TsanAtomicRMW[RMWI->getOperation()][Idx];
    if (!F)
      return false;
    const unsigned ByteSize = 1U << Idx;
    const unsigned BitSize = ByteSize * 8;
    Type *Ty = Type::getIntNTy(IRB.getContext(), BitSize);
    Type *PtrTy = Ty->getPointerTo();
    Value *Args[] = {IRB.CreatePointerCast(Addr, PtrTy),
                     IRB.CreateIntCast(RMWI->getValOperand(), Ty, false),
                     createOrdering(&IRB, RMWI->getOrdering())};
    CallInst *C = CallInst::Create(F, Args);
    ReplaceInstWithInst(I, C);
  } else if (AtomicCmpXchgInst *CASI = dyn_cast<AtomicCmpXchgInst>(I)) {
    Value *Addr = CASI->getPointerOperand();
    Type *OrigOldValTy = CASI->getNewValOperand()->getType();
    int Idx = getMemoryAccessFuncIndex(OrigOldValTy, Addr, DL);
    if (Idx < 0)
      return false;
    const unsigned ByteSize = 1U << Idx;
    const unsigned BitSize = ByteSize * 8;
    Type *Ty = Type::getIntNTy(IRB.getContext(), BitSize);
    Type *PtrTy = Ty->getPointerTo();
    Value *CmpOperand =
      IRB.CreateBitOrPointerCast(CASI->getCompareOperand(), Ty);
    Value *NewOperand =
      IRB.CreateBitOrPointerCast(CASI->getNewValOperand(), Ty);
    Value *Args[] = {IRB.CreatePointerCast(Addr, PtrTy),
                     CmpOperand,
                     NewOperand,
                     createOrdering(&IRB, CASI->getSuccessOrdering()),
                     createOrdering(&IRB, CASI->getFailureOrdering())};
    CallInst *C = IRB.CreateCall(TsanAtomicCAS[Idx], Args);
    Value *Success = IRB.CreateICmpEQ(C, CmpOperand);
    Value *OldVal = C;
    if (Ty != OrigOldValTy) {
      // The value is a pointer, so we need to cast the return value.
      OldVal = IRB.CreateIntToPtr(C, OrigOldValTy);
    }

    Value *Res =
      IRB.CreateInsertValue(UndefValue::get(CASI->getType()), OldVal, 0);
    Res = IRB.CreateInsertValue(Res, Success, 1);

    I->replaceAllUsesWith(Res);
    I->eraseFromParent();
  } else if (FenceInst *FI = dyn_cast<FenceInst>(I)) {
    Value *Args[] = {createOrdering(&IRB, FI->getOrdering())};
    FunctionCallee F = FI->getSyncScopeID() == SyncScope::SingleThread
                           ? TsanAtomicSignalFence
                           : TsanAtomicThreadFence;
    CallInst *C = CallInst::Create(F, Args);
    ReplaceInstWithInst(I, C);
  }
  return true;
}

bool ThreadSanitizer::instrumentCJAtomic(Instruction *I, const DataLayout &DL) {
  InstrumentationIRBuilder IRB(I);
  auto ID = dyn_cast<IntrinsicInst>(I)->getIntrinsicID();
  const CallInst* CI = dyn_cast<CallInst>(I);

  if (ID == Intrinsic::cj_atomic_load) {
    Value *Addr = CI->getArgOperand(1);
    Type *Ty = CI->getType();
    int Idx = getMemoryAccessFuncIndex(Ty, Addr, DL);
    Type *PtrTy = Type::getIntNPtrTy(I->getModule()->getContext(), DL.getTypeStoreSizeInBits(Ty));
    Value *Args[] = {IRB.CreatePointerCast(Addr, PtrTy), CI->getArgOperand(2)};

    Value *C = IRB.CreateCall(TsanAtomicLoad[Idx], Args);
    Value *Cast = IRB.CreateBitOrPointerCast(C, Ty);
    I->replaceAllUsesWith(Cast);
  } else if (ID == Intrinsic::cj_atomic_store || ID == Intrinsic::cj_atomic_swap) {
    Value *Addr = CI->getArgOperand(2);
    Value *Val = CI->getArgOperand(0);
    int Idx = getMemoryAccessFuncIndex(Val->getType(), Addr, DL);
    uint32_t TypeSize = DL.getTypeStoreSizeInBits(Val->getType());
    Type *PtrTy = Type::getIntNPtrTy(I->getModule()->getContext(), TypeSize);
    Value *Args[] = {IRB.CreatePointerCast(Addr, PtrTy),
                     IRB.CreateBitOrPointerCast(Val, Type::getIntNTy(IRB.getContext(), TypeSize)),
                     CI->getArgOperand(3)};

    if (ID == Intrinsic::cj_atomic_store) {
      CallInst *C = CallInst::Create(TsanAtomicStore[Idx], Args);
      ReplaceInstWithInst(I, C);
    } else {
      Value *C = IRB.CreateCall(TsanAtomicRMW[AtomicRMWInst::Xchg][Idx], Args);
      Value *Cast = IRB.CreateBitOrPointerCast(C, Val->getType());
      I->replaceAllUsesWith(Cast);
      I->eraseFromParent();
    }
  } else if (ID == Intrinsic::cj_atomic_compare_swap) {
    Value *Addr = CI->getArgOperand(3);
    Value *CmpVal = CI->getArgOperand(0);
    Value *NewVal = CI->getArgOperand(1);
    int Idx = getMemoryAccessFuncIndex(NewVal->getType(), Addr, DL);
    uint32_t TypeSize = DL.getTypeStoreSizeInBits(NewVal->getType());
    Type *Ty = Type::getIntNTy(IRB.getContext(), TypeSize);
    Type *PtrTy = Type::getIntNPtrTy(I->getModule()->getContext(), TypeSize);
    Value *Args[] = {IRB.CreatePointerCast(Addr, PtrTy), IRB.CreateBitOrPointerCast(CmpVal, Ty),
                     IRB.CreateBitOrPointerCast(NewVal, Ty), CI->getArgOperand(4), CI->getArgOperand(5)};

    CallInst *C = IRB.CreateCall(TsanAtomicCAS[Idx], Args);
    Value *Success = IRB.CreateICmpEQ(C, IRB.CreateBitOrPointerCast(CmpVal, Ty));
    StructType *ST = StructType::get(IRB.getContext(), {Ty, IRB.getInt1Ty()});
    Value *Res = IRB.CreateInsertValue(UndefValue::get(ST), C, 0);
    Res = IRB.CreateInsertValue(Res, Success, 1);
    ExtractValueInst *EI = ExtractValueInst::Create(Res, 1);
    ReplaceInstWithInst(I, EI);
  }
  return true;
}

int ThreadSanitizer::getMemoryAccessFuncIndex(Type *OrigTy, Value *Addr,
                                              const DataLayout &DL) {
  assert(OrigTy->isSized());
  assert(
      cast<PointerType>(Addr->getType())->isOpaqueOrPointeeTypeMatches(OrigTy));
  uint32_t TypeSize = DL.getTypeStoreSizeInBits(OrigTy);
  if (TypeSize != 8  && TypeSize != 16 &&
      TypeSize != 32 && TypeSize != 64 && TypeSize != 128) {
    // Ignore all unusual sizes.
    return -1;
  }
  size_t Idx = countTrailingZeros(TypeSize / 8);
  assert(Idx < kNumberOfAccessSizes);
  return Idx;
}

INITIALIZE_PASS_BEGIN(ThreadSanitizerPass, "cj-thread-sanitizer-pass",
                      "Cangjie Thread-Sanitizer", false, false)
INITIALIZE_PASS_END(ThreadSanitizerPass, "cj-thread-sanitizer-pass",
                      "Cangjie Thread-Sanitizer", false, false)

FunctionPass *llvm::createThreadSanitizerPass() {
  return new ThreadSanitizerPass();
}

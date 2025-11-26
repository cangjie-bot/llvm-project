//===- CJFunctionVarLifeTime.cpp - -----------------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file provides interface to "Cangjie intra-function variable life time analysis" pass.
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/CJFunctionVarLifeTime.h"

#include "llvm/ADT/Optional.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/Argument.h"
#include "llvm/IR/CJIntrinsics.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/SafepointIRVerifier.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/PassRegistry.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;
using namespace cangjie;

AnalysisKey CJFunctionVarLifeTime::Key;

FunctionVarLifeTimeResult CJFunctionVarLifeTime::run(Function &F, FunctionAnalysisManager &AM) {
    FunctionVarLifeTimeResult Res = FunctionVarLifeTimeResult();
    linerByRPOT(F, Res);
    analysisLiveInterval(F, Res);
    Res.print();
    return Res;
}

void CJFunctionVarLifeTime::linerByRPOT(Function &F, FunctionVarLifeTimeResult &LifeTimeResult) {
    BasicBlock *Entry = &F.front();
    ReversePostOrderTraversal<BasicBlock*> RPOT(Entry);
    uint64_t BasicBlockIndex = 0;
    uint64_t InstructionIndex = 0;
    for (BasicBlock *BB : RPOT) {
        LifeTimeResult.BasicBlocksToIndex[BB] = BasicBlockIndex++;
        for (Instruction &Instr : BB->getInstList()) {
            LifeTimeResult.InstrsToIndex[&Instr] = InstructionIndex++;
        }
    }
}

void CJFunctionVarLifeTime::analysisLiveInterval(Function &F, FunctionVarLifeTimeResult &LifeTimeResult) {
    for(auto &Instr : instructions(F)){
        if (!Instr.getType()->isVoidTy()) {
            uint64_t LiveStart = LifeTimeResult.InstrsToIndex[&Instr];
            uint64_t LiveEnd = 0;
            for (User *U : Instr.users()) {
                LiveEnd = std::max(LiveEnd, LifeTimeResult.InstrsToIndex[dyn_cast<Instruction>(U)]);
            }
            LifeTimeResult.SSAVarToLiveInterval[&Instr] = {LiveStart, LiveEnd};
        }
    }
}


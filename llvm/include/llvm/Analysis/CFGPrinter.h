//===-- CFGPrinter.h - CFG printer external interface -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines a 'dot-cfg' analysis pass, which emits the
// cfg.<fnname>.dot file for each function in the program, with a graph of the
// CFG for that function.
//
// This file defines external functions that can be called to explicitly
// instantiate the CFG printer.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_ANALYSIS_CFGPRINTER_H
#define LLVM_ANALYSIS_CFGPRINTER_H

#include "llvm/ADT/SetVector.h"
#include "llvm/Analysis/BlockFrequencyInfo.h"
#include "llvm/Analysis/BranchProbabilityInfo.h"
#include "llvm/Analysis/HeatUtils.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Statepoint.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/DOTGraphTraits.h"
#include "llvm/Support/FormatVariadic.h"

using namespace llvm;

static bool IsCJCFG = false;
extern cl::opt<std::string> CJCFGARG;
extern cl::opt<bool> IfCJCFGOnly;
extern cl::opt<bool> IfCJCFGComplex;
extern cl::opt<unsigned> CJCFGCol;

namespace {
class CJDFXOperate {
public:
  void run(const Function &F) {
    setCJCFG();
    fillMap(F);
    if (!CJCFGARG.empty()) {
      fillArgSet(F);
    }
  }

  DenseMap<const Value *, SetVector<const Value *>> FlowMap;
  DenseMap<const Value *, const Value *> DerivedBase;
  SetVector<const Value *> ArgSet;

private:
  void setCJCFG() { IsCJCFG = true; }

  void fillArgSet(const Function &F) {
    for (auto &I : instructions(F)) {
      if (I.getName().equals(CJCFGARG)) {
        ArgSet.insert(&I);
        break;
      }
    }

    if (ArgSet.empty()) {
      return;
    }

    for (auto Flow : FlowMap) {
      for (auto Data : Flow.second) {
        if (Data == ArgSet[0] || Data == ArgSet[0]->stripPointerCasts()) {
          ArgSet.set_union(Flow.second);
          break;
        }
      }
    }
  }

  void getPhiOrigin(PHINode *Phi, SetVector<const Value *> &Cache) {
    Cache.insert(Phi);
    for (auto &Val : Phi->incoming_values()) {
      if (Cache.count(Val->stripPointerCasts()) == 0) {
        if (auto Reloc = dyn_cast<GCRelocateInst>(Val->stripPointerCasts())) {
          getRelocateOrigin(Reloc, Cache);
        } else if (auto PhiNew = dyn_cast<PHINode>(Val->stripPointerCasts())) {
          getPhiOrigin(PhiNew, Cache);
        } else {
          Cache.insert(Val->stripPointerCasts());
        }
      }
    }
  }

  void getRelocateOrigin(const GCRelocateInst *Reloc,
                         SetVector<const Value *> &Cache) {
    Cache.insert(Reloc);
    auto Statepoint = cast<GCStatepointInst>(Reloc->getStatepoint());
    auto Derived = dyn_cast<Value>(
        *(Statepoint->gc_args_begin() + Reloc->getDerivedPtrIndex()));
    auto Base = dyn_cast<Value>(
        *(Statepoint->gc_args_begin() + Reloc->getBasePtrIndex()));
    DerivedBase[Derived] = Base;
    if (auto RelocOld =
            dyn_cast<const GCRelocateInst>(Derived->stripPointerCasts())) {
      getRelocateOrigin(RelocOld, Cache);
    } else if (auto Phi = dyn_cast<PHINode>(Derived->stripPointerCasts())) {
      getPhiOrigin(Phi, Cache);
    } else {
      Cache.insert(Derived->stripPointerCasts());
    }
  }

  void fillMap(const Function &F) {
    auto isFind = [&](const Value *Val) {
      for (auto Flow : FlowMap) {
        if (Flow.second.count(Val) > 0) {
          return true;
        }
      }
      return false;
    };

    for (auto &I : reverse(instructions(F))) {
      if (auto Reloc = dyn_cast<const GCRelocateInst>(&I)) {
        if (isFind(Reloc)) {
          continue;
        }
        SetVector<const Value *> Cache;
        getRelocateOrigin(Reloc, Cache);
        bool Changed = false;
        for (auto Flow : FlowMap) {
          auto Temp = Cache;
          Temp.set_subtract(Flow.second);
          if (Temp.size() < Cache.size()) {
            FlowMap[Flow.first].set_union(Temp);
            Changed = true;
          }
        }
        if (!Changed) {
          FlowMap[&I] = Cache;
        }
      }
    }
  }
};
} // end anonymous namespace

namespace llvm {
template <class GraphType> struct GraphTraits;
class CFGViewerPass : public PassInfoMixin<CFGViewerPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

class CFGOnlyViewerPass : public PassInfoMixin<CFGOnlyViewerPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

class CFGPrinterPass : public PassInfoMixin<CFGPrinterPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

class CFGOnlyPrinterPass : public PassInfoMixin<CFGOnlyPrinterPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

class CJCFGViewerPass : public PassInfoMixin<CJCFGViewerPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

class CJCFGPrinterPass : public PassInfoMixin<CJCFGPrinterPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

class DOTFuncInfo {
private:
  const Function *F;
  const BlockFrequencyInfo *BFI;
  const BranchProbabilityInfo *BPI;
  uint64_t MaxFreq;
  bool ShowHeat;
  bool EdgeWeights;
  bool RawWeights;

public:
  DOTFuncInfo(const Function *F) : DOTFuncInfo(F, nullptr, nullptr, 0) {}

  DOTFuncInfo(const Function *F, const BlockFrequencyInfo *BFI,
              const BranchProbabilityInfo *BPI, uint64_t MaxFreq)
      : F(F), BFI(BFI), BPI(BPI), MaxFreq(MaxFreq) {
    ShowHeat = false;
    EdgeWeights = !!BPI; // Print EdgeWeights when BPI is available.
    RawWeights = !!BFI;  // Print RawWeights when BFI is available.
  }

  const BlockFrequencyInfo *getBFI() const { return BFI; }

  const BranchProbabilityInfo *getBPI() const { return BPI; }

  const Function *getFunction() const { return this->F; }

  uint64_t getMaxFreq() const { return MaxFreq; }

  uint64_t getFreq(const BasicBlock *BB) const {
    return BFI->getBlockFreq(BB).getFrequency();
  }

  void setHeatColors(bool ShowHeat) { this->ShowHeat = ShowHeat; }

  bool showHeatColors() { return ShowHeat; }

  void setRawEdgeWeights(bool RawWeights) { this->RawWeights = RawWeights; }

  bool useRawEdgeWeights() { return RawWeights; }

  void setEdgeWeights(bool EdgeWeights) { this->EdgeWeights = EdgeWeights; }

  bool showEdgeWeights() { return EdgeWeights; }
};

template <>
struct GraphTraits<DOTFuncInfo *> : public GraphTraits<const BasicBlock *> {
  static NodeRef getEntryNode(DOTFuncInfo *CFGInfo) {
    return &(CFGInfo->getFunction()->getEntryBlock());
  }

  // nodes_iterator/begin/end - Allow iteration over all nodes in the graph
  using nodes_iterator = pointer_iterator<Function::const_iterator>;

  static nodes_iterator nodes_begin(DOTFuncInfo *CFGInfo) {
    return nodes_iterator(CFGInfo->getFunction()->begin());
  }

  static nodes_iterator nodes_end(DOTFuncInfo *CFGInfo) {
    return nodes_iterator(CFGInfo->getFunction()->end());
  }

  static size_t size(DOTFuncInfo *CFGInfo) {
    return CFGInfo->getFunction()->size();
  }
};

template <>
struct DOTGraphTraits<DOTFuncInfo *> : public DefaultDOTGraphTraits {

  // Cache for is hidden property
  llvm::DenseMap<const BasicBlock *, bool> isOnDeoptOrUnreachablePath;

  DOTGraphTraits(bool isSimple = false) : DefaultDOTGraphTraits(isSimple) {}

  static std::string getGraphName(DOTFuncInfo *CFGInfo) {
    return "CFG for '" + CFGInfo->getFunction()->getName().str() + "' function";
  }

  static const Value *findOrigin(const Value *Live, CJDFXOperate &CJDFXOp) {
    for (auto Flow : CJDFXOp.FlowMap) {
      if (Flow.second.count(Live->stripPointerCasts()) > 0) {
        return Flow.first;
      }
    }
    return Live;
  }

  static void printBase(raw_string_ostream &OS, const Value *Derived,
                        CJDFXOperate &CJDFXOp) {
    auto Itr = CJDFXOp.DerivedBase.find(Derived);
    if (Itr != CJDFXOp.DerivedBase.end() && Itr->second != Derived) {
      OS << "[ %" << CJDFXOp.DerivedBase[Derived]->getName() << " ]";
    } else {
      OS << "[ nullptr ]";
    }
  }

  // print: gc-live[ base ]( origin1 origin2 ... ), phi1, phi2, ...
  static void printLive(raw_string_ostream &OS,
                        DenseMap<const Value *, const Value *> &LiveOriginMap,
                        bool IsRef, CJDFXOperate &CJDFXOp) {
    if (LiveOriginMap.size() == 0) {
      return;
    }
    if (IsRef) {
      OS << "ref:\n";
    } else {
      OS << "struct:\n";
    }
    for (auto LiveOrigin : LiveOriginMap) {
      const Value *Live = LiveOrigin.first;
      const Value *Origin = LiveOrigin.second;
      OS << "%" << Live->getName();
      printBase(OS, Live, CJDFXOp);
      bool Changed = false;
      OS << "(";
      for (auto Flow : CJDFXOp.FlowMap[Origin]) {
        if (isa<GCResultInst>(Flow) || isa<LoadInst>(Flow) ||
            isa<AllocaInst>(Flow) || isa<Argument>(Flow) ||
            isa<GetElementPtrInst>(Flow)) {
          OS << " %" << Flow->getName();
          Changed = true;
        }
      }
      if (!Changed) {
        OS << " %" << Live->stripPointerCasts()->getName();
      }
      OS << " )";
      for (auto Flow : CJDFXOp.FlowMap[Origin]) {
        if (isa<PHINode>(Flow)) {
          OS << ", %" << Flow->getName();
        }
      }
      OS << "\n";
    }
  }

  static void addCJDFXLabel(const BasicBlock *Node, raw_string_ostream &OS,
                            CJDFXOperate &CJDFXOp) {
    auto isStructTy = [&](Type *Ty) {
      if (auto PT = dyn_cast<PointerType>(Ty)) {
        return Ty->getNonOpaquePointerElementType()->isStructTy();
      }
      return Ty->isStructTy();
    };

    auto handleGCArg = [&](raw_string_ostream &OS, const GCStatepointInst *Call,
                           bool IsRef) {
      DenseMap<const Value *, const Value *> LiveOriginMap;
      for (auto &GCArg : Call->gc_args()) {
        const Value *Live = dyn_cast<Value>(&GCArg);
        const Value *Origin = findOrigin(Live, CJDFXOp);
        if ((IsRef ^ isStructTy(Live->getType()))) {
          LiveOriginMap.insert({Live, Origin});
        }
      }
      printLive(OS, LiveOriginMap, IsRef, CJDFXOp);
    };

    for (auto &I : *Node) {
      if (auto Call = dyn_cast<GCStatepointInst>(&I)) {
        // print: statepoint_tokenxxx( calleefunc ):
        OS << Call->getName();
        if (auto CalledFunc = Call->getActualCalledFunction()) {
          OS << "( " << CalledFunc->getName() << " ):\n";
        } else {
          // 3: ActualCallee
          OS << "( " << Call->getOperand(3)->getName() << " ):\n";
        }
        handleGCArg(OS, Call, true);
        handleGCArg(OS, Call, false);
      }
    }
  }

  // Print base and derived for relocated
  static void printReloc(raw_string_ostream &OS,
                         const GCRelocateInst *GCReloc) {
    OS << "(%";
    auto Base = dyn_cast<Value>(
        *(cast<GCStatepointInst>(GCReloc->getStatepoint())->gc_args_begin() +
          GCReloc->getBasePtrIndex()));
    auto Derived = dyn_cast<Value>(
        *(cast<GCStatepointInst>(GCReloc->getStatepoint())->gc_args_begin() +
          GCReloc->getDerivedPtrIndex()));
    OS << Base->getName() << ", %";
    OS << Derived->getName() << ")\n";
  }

  static void addCJDFXArgLabel(const BasicBlock *Node, raw_string_ostream &OS,
                               CJDFXOperate &CJDFXOp) {
    auto setFind = [&](const Value *Val) {
      return CJDFXOp.ArgSet.count(Val) > 0 ||
             CJDFXOp.ArgSet.count(Val->stripPointerCasts()) > 0;
    };

    auto argUse = [&](const Instruction *I) {
      for (auto &Arg : I->operands()) {
        if (setFind(dyn_cast<Value>(&Arg))) {
          return true;
        }
      }
      return false;
    };

    if (CJDFXOp.ArgSet.empty()) {
      return;
    }
    SetVector<const Value *> DataSet;
    for (auto &I : *Node) {
      const Value *Val = &I;
      if (!IfCJCFGComplex) {
        if (setFind(Val)) {
          DataSet.insert(Val);
        }
      } else {
        if (setFind(Val) || argUse(&I)) {
          DataSet.insert(Val);
          CJDFXOp.ArgSet.insert(Val);
        }
      }
    }
    if (!DataSet.empty()) {
      OS << "\nData flow of ";
      OS << CJCFGARG << ":\n";
    }
    for (auto Data : DataSet) {
      OS << *Data << "\n";
      if (auto GCReloc = dyn_cast<GCRelocateInst>(Data)) {
        printReloc(OS, GCReloc);
      }
    }
  }

  static std::string getSimpleNodeLabel(const BasicBlock *Node, DOTFuncInfo *) {
    if (!Node->getName().empty())
      return Node->getName().str();

    std::string Str;
    raw_string_ostream OS(Str);

    Node->printAsOperand(OS, false);
    return OS.str();
  }

  static void eraseComment(std::string &OutStr, unsigned &I, unsigned Idx) {
    OutStr.erase(OutStr.begin() + I, OutStr.begin() + Idx);
    --I;
  }

  static std::string getCompleteNodeLabel(
      const BasicBlock *Node, DOTFuncInfo *,
      llvm::function_ref<void(raw_string_ostream &, const BasicBlock &)>
          HandleBasicBlock = [](raw_string_ostream &OS,
                                const BasicBlock &Node) -> void { OS << Node; },
      llvm::function_ref<void(std::string &, unsigned &, unsigned)>
          HandleComment = eraseComment) {
    enum { MaxColumns = 80 };
    std::string Str;
    raw_string_ostream OS(Str);

    if (Node->getName().empty()) {
      Node->printAsOperand(OS, false);
      OS << ":";
    }

    CJDFXOperate CJDFXOp;
    CJDFXOp.run(*(Node->getParent()));
    if (IsCJCFG && IfCJCFGOnly) {
      OS << Node->getName() << ":\n";
    } else {
      HandleBasicBlock(OS, *Node);
    }
    if (IsCJCFG) {
      if (CJCFGARG.empty()) {
        addCJDFXLabel(Node, OS, CJDFXOp);
      } else {
        addCJDFXArgLabel(Node, OS, CJDFXOp);
      }
    }
    std::string OutStr = OS.str();
    if (OutStr[0] == '\n')
      OutStr.erase(OutStr.begin());

    // Process string output to make it nicer...
    unsigned ColNum = 0;
    unsigned LastSpace = 0;
    unsigned MaxCol = IsCJCFG ? CJCFGCol : MaxColumns;
    for (unsigned i = 0; i != OutStr.length(); ++i) {
      if (OutStr[i] == '\n') { // Left justify
        OutStr[i] = '\\';
        OutStr.insert(OutStr.begin() + i + 1, 'l');
        ColNum = 0;
        LastSpace = 0;
      } else if (OutStr[i] == ';') {             // Delete comments!
        unsigned Idx = OutStr.find('\n', i + 1); // Find end of line
        HandleComment(OutStr, i, Idx);
      } else if (ColNum == MaxCol) { // Wrap lines.
        // Wrap very long names even though we can't find a space.
        if (!LastSpace)
          LastSpace = i;
        OutStr.insert(LastSpace, "\\l...");
        ColNum = i - LastSpace;
        LastSpace = 0;
        i += 3; // The loop will advance 'i' again.
      } else
        ++ColNum;
      if (OutStr[i] == ' ')
        LastSpace = i;
    }
    return OutStr;
  }

  std::string getNodeLabel(const BasicBlock *Node, DOTFuncInfo *CFGInfo) {
    if (isSimple())
      return getSimpleNodeLabel(Node, CFGInfo);
    else
      return getCompleteNodeLabel(Node, CFGInfo);
  }

  static std::string getEdgeSourceLabel(const BasicBlock *Node,
                                        const_succ_iterator I) {
    // Label source of conditional branches with "T" or "F"
    if (const BranchInst *BI = dyn_cast<BranchInst>(Node->getTerminator()))
      if (BI->isConditional())
        return (I == succ_begin(Node)) ? "T" : "F";

    // Label source of switch edges with the associated value.
    if (const SwitchInst *SI = dyn_cast<SwitchInst>(Node->getTerminator())) {
      unsigned SuccNo = I.getSuccessorIndex();

      if (SuccNo == 0)
        return "def";

      std::string Str;
      raw_string_ostream OS(Str);
      auto Case = *SwitchInst::ConstCaseIt::fromSuccessorIndex(SI, SuccNo);
      OS << Case.getCaseValue()->getValue();
      return OS.str();
    }
    return "";
  }

  /// Display the raw branch weights from PGO.
  std::string getEdgeAttributes(const BasicBlock *Node, const_succ_iterator I,
                                DOTFuncInfo *CFGInfo) {
    if (!CFGInfo->showEdgeWeights())
      return "";

    const Instruction *TI = Node->getTerminator();
    if (TI->getNumSuccessors() == 1)
      return "penwidth=2";

    unsigned OpNo = I.getSuccessorIndex();

    if (OpNo >= TI->getNumSuccessors())
      return "";

    BasicBlock *SuccBB = TI->getSuccessor(OpNo);
    auto BranchProb = CFGInfo->getBPI()->getEdgeProbability(Node, SuccBB);
    double WeightPercent = ((double)BranchProb.getNumerator()) /
                           ((double)BranchProb.getDenominator());
    double Width = 1 + WeightPercent;

    if (!CFGInfo->useRawEdgeWeights())
      return formatv("label=\"{0:P}\" penwidth={1}", WeightPercent, Width)
          .str();

    // Prepend a 'W' to indicate that this is a weight rather than the actual
    // profile count (due to scaling).

    uint64_t Freq = CFGInfo->getFreq(Node);
    std::string Attrs = formatv("label=\"W:{0}\" penwidth={1}",
                                (uint64_t)(Freq * WeightPercent), Width);
    if (Attrs.size())
      return Attrs;

    MDNode *WeightsNode = TI->getMetadata(LLVMContext::MD_prof);
    if (!WeightsNode)
      return "";

    MDString *MDName = cast<MDString>(WeightsNode->getOperand(0));
    if (MDName->getString() != "branch_weights")
      return "";

    OpNo = I.getSuccessorIndex() + 1;
    if (OpNo >= WeightsNode->getNumOperands())
      return "";
    ConstantInt *Weight =
        mdconst::dyn_extract<ConstantInt>(WeightsNode->getOperand(OpNo));
    if (!Weight)
      return "";
    return ("label=\"W:" + std::to_string(Weight->getZExtValue()) +
            "\" penwidth=" + std::to_string(Width));
  }

  std::string getNodeAttributes(const BasicBlock *Node, DOTFuncInfo *CFGInfo) {

    if (!CFGInfo->showHeatColors())
      return "";

    uint64_t Freq = CFGInfo->getFreq(Node);
    std::string Color = getHeatColor(Freq, CFGInfo->getMaxFreq());
    std::string EdgeColor = (Freq <= (CFGInfo->getMaxFreq() / 2))
                                ? (getHeatColor(0))
                                : (getHeatColor(1));

    std::string Attrs = "color=\"" + EdgeColor + "ff\", style=filled," +
                        " fillcolor=\"" + Color + "70\"";
    return Attrs;
  }
  bool isNodeHidden(const BasicBlock *Node, const DOTFuncInfo *CFGInfo);
  void computeDeoptOrUnreachablePaths(const Function *F);
};
} // End llvm namespace

namespace llvm {
class FunctionPass;
FunctionPass *createCFGPrinterLegacyPassPass();
FunctionPass *createCFGOnlyPrinterLegacyPassPass();
FunctionPass *createCJCFGViewerLegacyPassPass();
FunctionPass *createCJCFGPrinterLegacyPassPass();
} // End llvm namespace

#endif

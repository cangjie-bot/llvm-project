//===- CJSimpleGraphColoring.h - -----------------------------------------*- C++ -*-===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// This file provides interface to "Cangjie simple graph coloring" util.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_UTILS_CJSIMPLEGRAPHCOLORING_H
#define LLVM_TRANSFORMS_UTILS_CJSIMPLEGRAPHCOLORING_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/ADT/GraphTraits.h"
#include "llvm/Analysis/CJFunctionVarLifeTime.h"
#include <queue>
#include <vector>
#include <algorithm>

namespace llvm {

class InstrWithLiveIntervalNode {
public:
  using InstrVector = SmallSet<InstrWithLiveIntervalNode *, 4>;

  InstrWithLiveIntervalNode(Instruction *Instr) : Instr(Instr) {}

  InstrWithLiveIntervalNode(const InstrWithLiveIntervalNode &) = delete;
  InstrWithLiveIntervalNode &operator=(const InstrWithLiveIntervalNode &) = delete;

  ~InstrWithLiveIntervalNode() {}

  using iterator = InstrVector::iterator;
  using const_iterator = InstrVector::const_iterator;

  inline iterator begin() { return AdjacentInstrs.begin(); }
  inline iterator end() { return AdjacentInstrs.end(); }
  inline const_iterator begin() const { return AdjacentInstrs.begin(); }
  inline const_iterator end() const { return AdjacentInstrs.end(); }
  inline bool empty() const { return AdjacentInstrs.empty(); }
  inline unsigned size() const { return (unsigned)AdjacentInstrs.size(); }

  Instruction *getInstr() const { return Instr; }

  void dump() const;
  void print(raw_ostream &OS) const;

private:
  friend class InstrLiveIntervalConflictGraph;

  Instruction *Instr;
  InstrVector AdjacentInstrs;
};

template <> struct GraphTraits<InstrWithLiveIntervalNode *> {
  using NodeRef = InstrWithLiveIntervalNode *;

  static NodeRef getEntryNode(InstrWithLiveIntervalNode *InstrNode) { return InstrNode; }

  using ChildIteratorType = InstrWithLiveIntervalNode::iterator;

  static ChildIteratorType child_begin(NodeRef N) {
    return ChildIteratorType(N->begin());
  }

  static ChildIteratorType child_end(NodeRef N) {
    return ChildIteratorType(N->end());
  }

  static unsigned size(NodeRef N) {
    return N->size();
  }
};

template <> struct GraphTraits<const InstrWithLiveIntervalNode *> {
  using NodeRef = const InstrWithLiveIntervalNode *;
  using EdgeRef = const InstrWithLiveIntervalNode &;

  static NodeRef getEntryNode(InstrWithLiveIntervalNode *InstrNode) { return InstrNode; }

  using ChildIteratorType = InstrWithLiveIntervalNode::const_iterator;
  using ChildEdgeIteratorType = InstrWithLiveIntervalNode::const_iterator;

  static ChildIteratorType child_begin(NodeRef N) {
    return ChildIteratorType(N->begin());
  }

  static ChildIteratorType child_end(NodeRef N) {
    return ChildIteratorType(N->end());
  }

  static unsigned size(NodeRef N) {
    return N->size();
  }

  static ChildEdgeIteratorType child_edge_begin(NodeRef N) { return N->begin(); }
  static ChildEdgeIteratorType child_edge_end(NodeRef N) { return N->end(); }

  static NodeRef edge_dest(EdgeRef E) { return &E; }
};

class InstrLiveIntervalConflictGraph {

  using NodeArrTy = SmallVector<InstrWithLiveIntervalNode *, 4>;
  using ValueToLiveInterval = SmallDenseMap<Value*, FunctionVarLifeTimeResult::LiveInterval, 16>;

  NodeArrTy Nodes;

public:
  explicit InstrLiveIntervalConflictGraph(SmallVector<CallBase *, 4> &SmallSizeCB, ValueToLiveInterval& LiveIntervalMap);
  ~InstrLiveIntervalConflictGraph() {
    for (auto U : Nodes) {
        delete U;
    }
    Nodes.clear();
  }

  using iterator = NodeArrTy::iterator;
  using const_iterator = NodeArrTy::const_iterator;

  inline iterator begin() { return Nodes.begin(); }
  inline iterator end() { return Nodes.end(); }
  inline const_iterator begin() const { return Nodes.begin(); }
  inline const_iterator end() const { return Nodes.end(); }
};

template <>
struct GraphTraits<InstrLiveIntervalConflictGraph *> : public GraphTraits<InstrWithLiveIntervalNode *> {
  static NodeRef getEntryNode(InstrLiveIntervalConflictGraph *ILICG) {
    return *ILICG->begin();
  }

  using nodes_iterator = InstrLiveIntervalConflictGraph::iterator;

  static nodes_iterator nodes_begin(InstrLiveIntervalConflictGraph *ILICG) {
    return nodes_iterator(ILICG->begin());
  }

  static nodes_iterator nodes_end(InstrLiveIntervalConflictGraph *ILICG) {
    return nodes_iterator(ILICG->end());
  }
};

template <>
struct GraphTraits<const InstrLiveIntervalConflictGraph *> : public GraphTraits<const InstrWithLiveIntervalNode *> {
  static NodeRef getEntryNode(const InstrLiveIntervalConflictGraph *ILICG) {
    return *ILICG->begin();
  }

  using nodes_iterator = InstrLiveIntervalConflictGraph::const_iterator;

  static nodes_iterator nodes_begin(const InstrLiveIntervalConflictGraph *ILICG) {
    return nodes_iterator(ILICG->begin());
  }

  static nodes_iterator nodes_end(const InstrLiveIntervalConflictGraph *ILICG) {
    return nodes_iterator(ILICG->end());
  }
};

template<typename GraphT>
class SimpleGraphColoring {
private:
  typedef typename llvm::GraphTraits<GraphT>::NodeRef NodeRef;

  const GraphT G;
  SmallDenseMap<NodeRef, unsigned, 4> ColorMap;
  unsigned ColorNum = 0;

public:
  SimpleGraphColoring(const GraphT &G) : G(G) {}
  SimpleGraphColoring(const SimpleGraphColoring &) = delete;
  SimpleGraphColoring &operator=(const SimpleGraphColoring &) = delete;
  ~SimpleGraphColoring() {}

  unsigned color();
  SmallDenseMap<NodeRef, unsigned, 4> getColorMapRes() const { return ColorMap; }
  unsigned getColorNum() const { return ColorNum; }
};

extern template class SimpleGraphColoring<InstrLiveIntervalConflictGraph*>;

}

#endif // LLVM_TRANSFORMS_UTILS_CJSIMPLEGRAPHCOLORING_H
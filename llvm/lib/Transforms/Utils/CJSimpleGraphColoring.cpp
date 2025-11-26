//===- CJSimpleGraphColoring.cpp - -----------------------------------------*- C++ -*-===//
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

#include <llvm/Transforms/Utils/CJSimpleGraphColoring.h>

using namespace llvm;

InstrLiveIntervalConflictGraph::InstrLiveIntervalConflictGraph(SmallVector<CallBase *, 4> &SmallSizeCB, ValueToLiveInterval& LiveIntervalMap) {
    for (auto U : SmallSizeCB) {
        Nodes.push_back(new InstrWithLiveIntervalNode(U));
    }

    for (auto U : Nodes) {
        for (auto V : Nodes) {
            if (U != V && 
                LiveIntervalMap.count(U->Instr) &&
                LiveIntervalMap.count(V->Instr) &&
                FunctionVarLifeTimeResult::overlapLifeInterval(LiveIntervalMap[U->Instr], LiveIntervalMap[V->Instr])) {
                U->AdjacentInstrs.insert(V);
                V->AdjacentInstrs.insert(U);
            }
        }
    }
}

// Use Welsh-Powell algorithm
template<typename GraphT>
unsigned SimpleGraphColoring<GraphT>::color() {
    ColorMap.clear();
    ColorNum = 0;
    SmallVector<NodeRef, 8> UnColorNodes;
    std::set<size_t, std::greater<size_t>> Temp;
    for (auto It = GraphTraits<GraphT>::nodes_begin(G);
        It != GraphTraits<GraphT>::nodes_end(G); ++It) {
        UnColorNodes.push_back(*It);
    }
    auto AdjacentNodesHaveDifferentColor = [this] (NodeRef N, unsigned Color) -> bool {
        for (auto It = GraphTraits<GraphT>::child_begin(N); It != GraphTraits<GraphT>::child_end(N); ++It) {
            if (this->ColorMap.count(*It) && this->ColorMap[*It] == Color) {
                return false;
            }
        }
        return true;
    };
    while (!UnColorNodes.empty()) {
        ++ColorNum;
        Temp.clear();
        std::sort(UnColorNodes.begin(), UnColorNodes.end(), [this](NodeRef A, NodeRef B) {
        return GraphTraits<GraphT>::size(A) > GraphTraits<GraphT>::size(B); });
        NodeRef FirstNode = *UnColorNodes.begin();
        this->ColorMap[FirstNode] = ColorNum;
        size_t Index = 0;
        Temp.insert(Index);
        for (auto E : UnColorNodes) {
            if (E != FirstNode && AdjacentNodesHaveDifferentColor(E, ColorNum)) {
                this->ColorMap[E] = ColorNum;
                Temp.insert(Index);
            }
            ++Index;
        }
        for (auto I : Temp) {
           UnColorNodes.erase(UnColorNodes.begin() + I);
        }
    }
    return ColorNum;
}

template class llvm::SimpleGraphColoring<InstrLiveIntervalConflictGraph*>;

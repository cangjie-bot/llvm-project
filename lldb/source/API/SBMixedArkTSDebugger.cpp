//===-- SBMixedArkTSDebugger.cpp ------------------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#include "lldb/API/SBMixedArkTSDebugger.h"
#include "lldb/API/SBData.h"
#include "lldb/API/SBTarget.h"
#include "lldb/API/SBError.h"
#include "lldb/Utility/Instrumentation.h"
#include "lldb/Target/Target.h"

using namespace lldb;
using namespace lldb_private;

SBMixedArkTSDebugger::SBMixedArkTSDebugger() {
  LLDB_INSTRUMENT_VA(this);
}

SBMixedArkTSDebugger::SBMixedArkTSDebugger(const lldb::SBTarget &rhs) {
  LLDB_INSTRUMENT_VA(this, rhs);
}

SBMixedArkTSDebugger::SBMixedArkTSDebugger(const lldb::TargetSP &target_sp) {
  LLDB_INSTRUMENT_VA(this, target_sp);
}

SBMixedArkTSDebugger::~SBMixedArkTSDebugger() {}

lldb::SBData SBMixedArkTSDebugger::GetBackTrace(SBError &er) {
  LLDB_INSTRUMENT_VA(this, er);

  return SBData();
}
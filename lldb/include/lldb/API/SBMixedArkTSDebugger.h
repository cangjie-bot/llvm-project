//===-- SBMixedArkTSDebugger.h --------------------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_API_SBMIXEDARKTSDEBUGGER_H
#define LLDB_API_SBMIXEDARKTSDEBUGGER_H

#include "lldb/API/SBDefines.h"

namespace lldb {

class LLDB_API SBMixedArkTSDebugger {
public:
  SBMixedArkTSDebugger();

  SBMixedArkTSDebugger(const lldb::SBTarget &rhs);

  SBMixedArkTSDebugger(const lldb::TargetSP &target_sp);

  ~SBMixedArkTSDebugger();

  lldb::SBData GetBackTrace(SBError &er);

  lldb::SBData OperateDebugMessage(const char *message, SBError &er);

};

} // namespace lldb

#endif // LLDB_API_SBMIXEDARKTSDEBUGGER_H
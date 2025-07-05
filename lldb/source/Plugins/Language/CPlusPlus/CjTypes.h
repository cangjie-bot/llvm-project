//===-- CjTypes.h ---------------------------------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef liblldb_CjTypes_h_
#define liblldb_CjTypes_h_

#include "lldb/Core/ValueObject.h"
#include "lldb/DataFormatters/TypeSummary.h"
#include "lldb/Utility/Stream.h"

namespace lldb_private {
namespace formatters {
bool BasicSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool StringSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool UnitSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool CStringSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool CPointerSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool RangeSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool OptionSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool OptionPtrSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool EnumOptionSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool EnumOptionPtrSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool FunctionSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool EnumSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
bool Enum2SummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options);
} // namespace formatters
} // namespace lldb_private

#endif // liblldb_CjTypes_h_

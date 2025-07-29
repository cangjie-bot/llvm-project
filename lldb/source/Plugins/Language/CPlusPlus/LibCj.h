//===-- LibCj.h -----------------------------------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_SOURCE_PLUGINS_LANGUAGE_CPLUSPLUS_LIBCJ_H
#define LLDB_SOURCE_PLUGINS_LANGUAGE_CPLUSPLUS_LIBCJ_H

#include "lldb/Core/ValueObject.h"
#include "lldb/DataFormatters/TypeSynthetic.h"

namespace lldb_private {
namespace formatters {
SyntheticChildrenFrontEnd *CjArraySyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjTupleSyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjEnumSyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjE2SyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjE3SyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjComplexAsSimpleSyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjClassSyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjArrayListSyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjHashMapSyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjHashSetSyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjOptionSyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
SyntheticChildrenFrontEnd *CjVArraySyntheticFrontEndCreator(CXXSyntheticChildren *, lldb::ValueObjectSP);
} // namespace formatters
} // namespace lldb_private

#endif // LLDB_SOURCE_PLUGINS_LANGUAGE_CPLUSPLUS_LIBCJ_H

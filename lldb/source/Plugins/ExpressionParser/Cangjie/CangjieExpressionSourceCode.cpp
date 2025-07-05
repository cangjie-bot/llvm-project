//===-- CangjieExpressionSourceCode.cpp -----------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#include "CangjieExpressionSourceCode.h"
#include "lldb/Utility/StreamString.h"

using namespace lldb_private;

bool CangjieExpressionSourceCode::GetText(
    std::string &text, ExecutionContext &exe_ctx, bool add_locals,
    bool force_add_all_locals, llvm::ArrayRef<std::string> modules) const {
  StreamString lldb_local_var_decls;
  if (m_wrap) {
    // Generate a list of @import statements that will import the specified
    // module into our expression.
    std::string module_imports = {};
    for (const std::string &module : modules) {
      module_imports.append(module);
      module_imports.append("\n");
    }
    StreamString wrap_stream;
    // First construct a tagged form of the user expression so we can find it
    // later:
    switch (m_wrap_kind) {
    case WrapKind::Function:
      wrap_stream.Printf(
          "package expr\n"
          "%s\n"
          "@OverflowThrowing\n"
          "public func __lldb_expr(__lldb_arg: CPointer<Unit>): Int64 {\n"
          "  try {\n"
          "       var __lldb_expr_result = unsafe {\n"
          "       %s \n"
          "    }\n"
          "  } catch (e: Exception) {\n"
          "    println(e.toString()) \n"
          "    var __lldb_error_result = -1\n"
          "    -1\n"
          "  }\n"
          "  0\n"
          "}\n",
          module_imports.c_str(), m_body.c_str());
      break;
    case WrapKind::MemberFunction:
      wrap_stream.Printf(
          "package expr\n"
          "%s\n"
          "extend %s {\n"
          "  @OverflowThrowing\n"
          "  public func __lldb_wrapped_expr(__lldb_arg: CPointer<Unit>): Int64 {\n"
          "    try {\n"
          "      var __lldb_expr_result = unsafe {\n"
          "        %s \n"
          "      }\n"
          "    } catch (e: Exception) {\n"
          "      println(e.toString()) \n"
          "      var __lldb_error_result = -1\n"
          "      -1\n"
          "    }\n"
          "    0\n"
          "  }\n"
          "}\n"
          "public func __lldb_expr(__lldb_arg: CPointer<Unit>): Int64 {\n"
          "  __lldb_injected_self.__lldb_wrapped_expr(__lldb_arg)\n"
          "}\n",
          module_imports.c_str(),
          m_class_name.c_str(), m_body.c_str());
      break;
    }
    text = std::string(wrap_stream.GetString());
  } else {
    text.append(m_body);
  }
  return true;
}

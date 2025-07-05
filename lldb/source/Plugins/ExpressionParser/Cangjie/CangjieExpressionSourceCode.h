//===-- CangjieExpressionSourceCode.h -------------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_SOURCE_PLUGINS_EXPRESSIONPARSER_CANGJIE_CANGJIEEXPRESSIONSOUECECODE_H
#define LLDB_SOURCE_PLUGINS_EXPRESSIONPARSER_CANGJIE_CANGJIEEXPRESSIONSOUECECODE_H
#include "lldb/Expression/Expression.h"
#include "lldb/Expression/ExpressionSourceCode.h"

namespace lldb_private {
class CangjieExpressionSourceCode : public ExpressionSourceCode {
public:
  /// The possible ways an expression can be wrapped.
  enum class WrapKind {
    /// Wrapped in a function.
    Function,
    /// Wrapped in a non-static member function of a cj class.
    MemberFunction,
  };

  static CangjieExpressionSourceCode *CreateWrapped(llvm::StringRef prefix,
                                                  llvm::StringRef body,
                                                  WrapKind wrap_kind,
                                                  llvm::StringRef classname) {
    return new CangjieExpressionSourceCode("$__lldb_expr", prefix, body, Wrap, wrap_kind, classname);
  }

  bool GetText(std::string &text, ExecutionContext &exe_ctx, bool add_locals,
               bool force_add_all_locals,
               llvm::ArrayRef<std::string> modules) const;

private:
  CangjieExpressionSourceCode(
      llvm::StringRef name, llvm::StringRef prefix, llvm::StringRef body,
      Wrapping wrap, WrapKind wrap_kind, llvm::StringRef classname):
        ExpressionSourceCode(name, prefix, body, wrap), m_wrap_kind(wrap_kind), m_class_name(classname) {};

  /// How the expression has been wrapped.
  const WrapKind m_wrap_kind;
  std::string m_class_name;
};
} // namespace lldb_private
#endif // LLDB_SOURCE_PLUGINS_EXPRESSIONPARSER_CANGJIE_CANGJIEEXPRESSIONSOUECECODE_H

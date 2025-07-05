//===-- CangjieUserExpression.cpp -----------------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#include "CangjieUserExpression.h"
#include "CangjieCompilerInstance.h"
#include "lldb/Utility/LLDBLog.h"
#include "lldb/Utility/Log.h"
#include "clang/AST/DeclCXX.h"
#include "Plugins/ExpressionParser/Clang/ClangASTMetadata.h"


using namespace lldb_private;
using namespace Cangjie;

CangjieUserExpression::CangjieUserExpression(
    ExecutionContextScope &exe_scope, llvm::StringRef expr,
    llvm::StringRef prefix, lldb::LanguageType language,
    ResultType desired_type, const EvaluateExpressionOptions &options,
    ValueObject *ctx_obj)
    : LLVMUserExpression(exe_scope, expr, prefix, language, desired_type,
                         options), m_ctx_obj(ctx_obj) {}

CangjieUserExpression::~CangjieUserExpression() = default;

bool CangjieUserExpression::Parse(
    DiagnosticManager &diagnostic_manager, ExecutionContext &exe_ctx,
    lldb_private::ExecutionPolicy execution_policy, bool keep_result_in_memory,
    bool generate_debug_info) {
  if (!SetupPersistentState(diagnostic_manager, exe_ctx)) {
    return false;
  }
  m_materializer_up = std::make_unique<Materializer>();
  // Create source code.
  std::vector<std::string> m_imported_cpp_modules;
  CreateSourceCode(diagnostic_manager, exe_ctx, m_imported_cpp_modules, false);
  // Do compile.
  if (!TryParse(exe_ctx, generate_debug_info)) {
    return false;
  }

  m_parser->m_in_member_method = m_in_member_method;
  Status jit_error = m_parser->PrepareForExecution(
      m_jit_start_addr, m_jit_end_addr, m_execution_unit_sp, exe_ctx,
      m_can_interpret, execution_policy);
  if (jit_error.Fail()) {
    Log *log = GetLog(LLDBLog::Expressions);
    LLDB_LOGF(log, "%s", jit_error.AsCString());
    return false;
  }
  m_materialized_address = m_parser->m_materialized_address;
  Process *process = exe_ctx.GetProcessPtr();
  if (process && m_jit_start_addr != LLDB_INVALID_ADDRESS)
    m_jit_process_wp = lldb::ProcessWP(process->shared_from_this());

  return true;
}

bool CangjieUserExpression::TryParse(ExecutionContext &exe_ctx,
                                     bool generate_debug_info) {
  StackFrame *frame = exe_ctx.GetFramePtr();
  if (!frame) {
    return false;
  }

  auto exe_scope = exe_ctx.GetBestExecutionContextScope();
  m_parser = std::make_unique<CangjieExpressionParser>(
      exe_scope, *this, generate_debug_info);
  m_parser->PrepareParse(m_materializer_up.get(), &m_result_delegate, &m_error_result_delegate, m_in_static_method);
  return m_parser->Parse(exe_ctx, m_transformed_text);
}

bool CangjieUserExpression::Complete(ExecutionContext &exe_ctx,
                                     CompletionRequest &request,
                                     unsigned complete_pos) {
  return true;
}

void CangjieUserExpression::ScanContext(ExecutionContext &exe_ctx, Status &err) {
  Log *log = GetLog(LLDBLog::Expressions);
  LLDB_LOGF(log, "CangjieUserExpression::ScanContext()");

  StackFrame *frame = exe_ctx.GetFramePtr();
  if (!frame) {
    LLDB_LOGF(log, "  [ScanContext] Null stack frame");
    return;
  }

  SymbolContext sym_ctx = frame->GetSymbolContext(lldb::eSymbolContextFunction |
                                                  lldb::eSymbolContextBlock);
  if (!sym_ctx.function) {
    LLDB_LOGF(log, "  [ScanContext] Null function");
    return;
  }

  Block *function_block = sym_ctx.GetFunctionBlock();
  if (!function_block) {
    LLDB_LOGF(log, "  [ScanContext] Null function block");
    return;
  }
  auto this_variable = frame->FindVariable(ConstString("this"));
  if (this_variable) {
    auto pkg_name = GetPkgNameFromCompilerUnit(*sym_ctx.comp_unit);
    std::string type_name = this_variable->GetTypeName().GetCString();
    if (ConstString(type_name).GetStringRef().contains(GENERIC_TYPE_PREFIX_NAME)) {
      auto dynamic_Type = this_variable->GetDynamicType();
      std::string tmp_name = dynamic_Type.GetTypeName().GetCString();
      auto pkg_name = GetPkgNameFromCompilerUnit(*sym_ctx.comp_unit);
      m_class_name = DeleteAllPkgname(tmp_name, pkg_name);
    }
    type_name = DeletePrefixOfType(type_name);
    m_class_name = GetSubNameWithoutPkgname(type_name, pkg_name);
  }
  CompilerDeclContext decl_context = function_block->GetDeclContext();
  if (!decl_context) {
    if (this_variable) {
      LLDB_LOGF(log, " in member method context");
      m_in_member_method = true;
      return;
    }
    LLDB_LOGF(log, "  [ScanContext] Null decl context");
    return;
  }

  if (clang::CXXMethodDecl *method_decl =
          TypeSystemClang::DeclContextGetAsCXXMethodDecl(decl_context)) {
    ClangASTMetadata *metadata =
        TypeSystemClang::DeclContextGetMetaData(decl_context, method_decl);
    if (!this_variable) {
      // If the function is static.
      LLDB_LOGF(log, " in static method context");
      m_in_static_method = true;
      return;
    }
    // Get the class name if the ctx in instance Member Function.
    auto classdecl = method_decl->getParent();
    if (classdecl) {
      m_class_name = classdecl->getIdentifier()->getName();
      m_class_name = DeletePrefixOfType(m_class_name);
      if (ConstString(m_class_name).GetStringRef().contains(GENERIC_TYPE_PREFIX_NAME)) {
        // use `extend A<Int16> {...}` instand of `extend A<$G_T> {...}`
        auto m_this_variable = frame->FindVariable(ConstString("this"));
        auto dynamic_Type = m_this_variable->GetDynamicType();
        auto pkg_name = GetPkgNameFromCompilerUnit(*sym_ctx.comp_unit);
        std::string type_name = dynamic_Type.GetTypeName().GetCString();
        m_class_name = DeleteAllPkgname(type_name, pkg_name);
        m_class_name = DeletePrefixOfType(m_class_name);
        LLDB_LOGF(log, "class name %s -> %s", type_name.c_str(), m_class_name.c_str());
      }
    }
    LLDB_LOGF(log, " in member method context");
    m_in_member_method = true;
    return;
  } else if (clang::ObjCMethodDecl *method_decl =
          TypeSystemClang::DeclContextGetAsObjCMethodDecl(decl_context)) {
    if (!this_variable) {
        LLDB_LOGF(log, " in static method context");
        m_in_static_method = true;
        return;
    }
    LLDB_LOGF(log, " in member method context");
    m_in_member_method = true;
    return;
  } else if (clang::FunctionDecl *function_decl =
          TypeSystemClang::DeclContextGetAsFunctionDecl(decl_context)) {
    ClangASTMetadata *metadata =
        TypeSystemClang::DeclContextGetMetaData(decl_context, function_decl);
    if (metadata && metadata->HasObjectPtr()) {
      LLDB_LOGF(log, " in member method context");
      m_in_member_method = true;
    }
    return;
  }
  LLDB_LOGF(log, " in normal function context");
  return;
}

CangjieExpressionSourceCode::WrapKind CangjieUserExpression::GetWrapKind() const {
  using Kind = CangjieExpressionSourceCode::WrapKind;
  if (m_in_member_method) {
    return Kind::MemberFunction;
  }

  // Not in any kind of 'special' function,
  // so just wrap it in a normal cj function.
  return Kind::Function;
}

void CangjieUserExpression::CreateSourceCode(
    DiagnosticManager &diagnostic_manager, ExecutionContext &exe_ctx,
    std::vector<std::string> modules_to_import, bool for_completion) {
  // Scan wrapkind for SourceCode.
  Status err;
  ScanContext(exe_ctx, err);

  std::string prefix = m_expr_prefix;
  if (m_options.GetExecutionPolicy() == eExecutionPolicyTopLevel) {
    m_transformed_text = m_expr_text;
  } else {
    m_source_code.reset(CangjieExpressionSourceCode::CreateWrapped(
        prefix, m_expr_text, GetWrapKind(), m_class_name));

    if (!m_source_code->GetText(m_transformed_text, exe_ctx, for_completion,
                                for_completion, modules_to_import)) {
      return;
    }
  }
  Log *log = GetLog(LLDBLog::Expressions);
  if (log) {
    LLDB_LOGF(log, " ------ [ Cangjie source code start] ------ \n%s", m_transformed_text.c_str());
    LLDB_LOGF(log, " ------ [ Cangjie source code end] ------ \n");
  }
}

bool CangjieUserExpression::AddArguments(ExecutionContext &exe_ctx, std::vector<lldb::addr_t> &args,
                                         lldb::addr_t struct_address,
                                         DiagnosticManager &diagnostic_manager) {
  args.push_back(struct_address);
  return true;
}

ConstString CangjieUserExpression::CangjiePersistentVariableDelegate::GetName() {
  return m_persistent_state->GetNextPersistentVariableName(false);
}

void CangjieUserExpression::CangjiePersistentVariableDelegate::DidDematerialize(
    lldb::ExpressionVariableSP &variable) {
  m_variable = variable;
}

void CangjieUserExpression::CangjiePersistentVariableDelegate::RegisterPersistentState(
    PersistentExpressionState *persistent_state) {
  m_persistent_state = persistent_state;
}

bool CangjieUserExpression::SetupPersistentState(DiagnosticManager &diagnostic_manager,
                                                 ExecutionContext &exe_ctx) {
  Target *target = exe_ctx.GetTargetPtr();
  if (!target) {
    diagnostic_manager.PutString(eDiagnosticSeverityError,
                                 "error: couldn't start parsing (no target)");
    return false;
  }
  if (PersistentExpressionState *persistent_state =
          target->GetPersistentExpressionStateForLanguage(
              lldb::eLanguageTypeC)) {
    m_result_delegate.RegisterPersistentState(persistent_state);
    m_error_result_delegate.RegisterPersistentState(persistent_state);
    return true;
  } else {
    diagnostic_manager.PutString(
        eDiagnosticSeverityError,
        "couldn't start parsing (no persistent data)");
    return false;
  }
}

lldb::ExpressionVariableSP CangjieUserExpression::GetResultAfterDematerialization(
    ExecutionContextScope *exe_scope) {
  lldb::TargetSP target_sp = exe_scope->CalculateTarget();
  auto persistent_state = target_sp->GetPersistentExpressionStateForLanguage(lldb::eLanguageTypeC);
  auto error = m_error_result_delegate.GetVariable()->GetValueObject();
  if (error->GetValueAsSigned(-1) == -1) {
    persistent_state->RemovePersistentVariable(m_error_result_delegate.GetVariable());
    persistent_state->RemovePersistentVariable(m_result_delegate.GetVariable());
    return nullptr;
  }

  persistent_state->RemovePersistentVariable(m_error_result_delegate.GetVariable());
  return m_result_delegate.GetVariable();
}

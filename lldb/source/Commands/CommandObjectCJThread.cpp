//===-- CommandObjectCJThread.cpp -----------------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#include "CommandObjectCJThread.h"
#include "Commands/CommandObjCJThreadCommon.h"
#include "lldb/Core/PluginManager.h"
#include "lldb/Core/ValueObject.h"
#include "lldb/Host/OptionParser.h"
#include "lldb/Interpreter/CommandInterpreter.h"
#include "lldb/Interpreter/CommandOptionArgumentTable.h"
#include "lldb/Interpreter/CommandReturnObject.h"
#include "lldb/Interpreter/OptionArgParser.h"
#include "lldb/Interpreter/OptionGroupPythonClassWithDict.h"
#include "lldb/Interpreter/Options.h"
#include "lldb/Target/Process.h"
#include "lldb/Target/Target.h"
#include "lldb/Target/Thread.h"
#include "lldb/Utility/State.h"
#include "lldb/Expression/UserExpression.h"
#include "lldb/DataFormatters/StringPrinter.h"
#include "lldb/DataFormatters/FormattersHelpers.h"
#include "lldb/DataFormatters/DumpValueObjectOptions.h"
#include "lldb/DataFormatters/ValueObjectPrinter.h"

using namespace lldb;
using namespace lldb_private;

// CommandObjectThreadBacktrace
#define LLDB_OPTIONS_cjthread_backtrace
#include "CommandOptions.inc"

class CommandObjectCJThreadBacktrace : public CommandObjectParsed,
                                       public CommandObjCJThreadCommon {
public:
  class CommandOptions : public Options {
  public:
    CommandOptions() {
      // Keep default values of all options in one place: OptionParsingStarting
      OptionParsingStarting(nullptr);
    }

    ~CommandOptions() override = default;

    Status SetOptionValue(uint32_t option_idx, llvm::StringRef option_arg,
                          ExecutionContext *execution_context) override {
      Status error;
      const int short_option = m_getopt_table[option_idx].val;

      switch (short_option) {
      case 'c': {
        int32_t input_count = 0;
        if (option_arg.getAsInteger(0, m_count)) {
          m_count = UINT32_MAX;
          error.SetErrorStringWithFormat(
              "invalid integer value for option '%c'", short_option);
        } else if (input_count < 0) {
          m_count = UINT32_MAX;
        }
      }
        break;
      case 's':
        if (option_arg.getAsInteger(0, m_start)) {
          error.SetErrorStringWithFormat(
              "invalid integer value for option '%c'", short_option);
        }
        break;
      default:
        llvm_unreachable("Unimplemented option");
      }

      return error;
    }

    void OptionParsingStarting(ExecutionContext *execution_context) override {
      m_count = UINT32_MAX;
      m_start = 0;
    }

    llvm::ArrayRef<OptionDefinition> GetDefinitions() override {
      return llvm::makeArrayRef(g_cjthread_backtrace_options);
    }

    // Instance variables to hold the values for command options.
    uint32_t m_count;
    uint32_t m_start;
  };

  explicit CommandObjectCJThreadBacktrace(CommandInterpreter &interpreter)
      : CommandObjectParsed(
            interpreter, "cjthread backtrace",
            "Show cjthread call stacks.  Defaults to the current thread, thread "
            "indexes can be specified as arguments.\n"
            "Use the thread-index \"unique\" to see cjthreads grouped by unique "
            "call stacks.\n",
            nullptr,
            eCommandRequiresProcess | eCommandRequiresThread |
                eCommandTryTargetAPILock | eCommandProcessMustBeLaunched |
                eCommandProcessMustBePaused),
        CommandObjCJThreadCommon() {
    CommandArgumentData cjthread_arg{eArgTypeCJThreadIndex, eArgRepeatStar};
    m_arguments.push_back({cjthread_arg});
  }

  ~CommandObjectCJThreadBacktrace() override = default;

  Options *GetOptions() override { return &m_options; }

  llvm::Optional<std::string> GetRepeatCommand(Args &current_args,
                                               uint32_t idx) override {
    llvm::StringRef count_opt("--count");
    llvm::StringRef start_opt("--start");

    // If no "count" was provided, we are dumping the entire backtrace, so
    // there isn't a repeat command.  So we search for the count option in
    // the args, and if we find it, we make a copy and insert or modify the
    // start option's value to start count indices greater.

    Args copy_args(current_args);
    size_t num_entries = copy_args.GetArgumentCount();
    // These two point at the index of the option value if found.
    size_t count_idx = 0;
    size_t start_idx = 0;
    size_t count_val = 0;
    size_t start_val = 0;

    for (size_t idx = 0; idx < num_entries; idx++) {
      llvm::StringRef arg_string = copy_args[idx].ref();
      if (arg_string.equals("-c") || count_opt.startswith(arg_string)) {
        idx++;
        if (idx == num_entries) {
          return llvm::None;
        }
        count_idx = idx;
        if (copy_args[idx].ref().getAsInteger(0, count_val)) {
          return llvm::None;
        }
      } else if (arg_string.equals("-s") || start_opt.startswith(arg_string)) {
        idx++;
        if (idx == num_entries) {
          return llvm::None;
        }
        start_idx = idx;
        if (copy_args[idx].ref().getAsInteger(0, start_val)) {
          return llvm::None;
        }
      }
    }
    if (count_idx == 0) {
      return llvm::None;
    }

    std::string new_start_val = llvm::formatv("{0}", start_val + count_val);
    if (start_idx == 0) {
      copy_args.AppendArgument(start_opt);
      copy_args.AppendArgument(new_start_val);
    } else {
      copy_args.ReplaceArgumentAtIndex(start_idx, new_start_val);
    }
    std::string repeat_command;
    if (!copy_args.GetQuotedCommandString(repeat_command)) {
      return llvm::None;
    }

    return repeat_command;
  }

protected:
  bool DoExecute(Args &command, CommandReturnObject &result) override {
    Status error;
    GetCJThreadInfo(m_exe_ctx, error);
    if (error.Fail()) {
      result.AppendErrorWithFormat("%s", error.AsCString());
      return false;
    }

    const size_t num_args = command.GetArgumentCount();
    Process *process = m_exe_ctx.GetProcessPtr();
    std::lock_guard<std::recursive_mutex> guard(
        process->GetThreadList().GetMutex());

    if (num_args == 0) {
      return GetCurrentCJthreadStatus(m_exe_ctx.GetThreadSP(), result, m_cjthread_info,
                                      m_options.m_start, m_options.m_count);
    }

    for (size_t i = 0; i < num_args; i++) {
      uint32_t cjthread_idx;
      if (!llvm::to_integer(command.GetArgumentAtIndex(i), cjthread_idx)) {
        result.AppendErrorWithFormat("invalid cjthread specification: \"%s\"\n",
                                     command.GetArgumentAtIndex(i));
        continue;
      }

      auto cjthread_context = GetCJthreadInfoByCJThreadID(m_cjthread_info, cjthread_idx);
      if (!cjthread_context) {
        result.AppendErrorWithFormat("invalid cjthread index \"%u\"", cjthread_idx);
        continue;
      }

      if (!GetCJThreadStatus(m_exe_ctx.GetThreadSP(), result, cjthread_context,
                             m_options.m_start, m_options.m_count)) {
        return false;
      }
    }

    return result.Succeeded();
  }

private:
  CommandOptions m_options;
};

// CommandObjectCJThreadList
class CommandObjectCJThreadList : public CommandObjectParsed,
                                  public CommandObjCJThreadCommon {
public:
  explicit CommandObjectCJThreadList(CommandInterpreter &interpreter)
      : CommandObjectParsed(
            interpreter, "cjthread list",
            "Show a summary of each cjthread in the current target process.",
            "cjthread list",
            eCommandRequiresProcess | eCommandTryTargetAPILock |
            eCommandProcessMustBeLaunched | eCommandProcessMustBePaused),
        CommandObjCJThreadCommon() {}

  ~CommandObjectCJThreadList() override = default;

protected:
  bool DoExecute(Args &command, CommandReturnObject &result) override {
    result.SetStatus(eReturnStatusSuccessFinishNoResult);
    Status error;
    GetCJThreadInfo(m_exe_ctx, error);
    if (error.Fail()) {
      result.AppendErrorWithFormat("%s", error.AsCString());
      return false;
    }

    Process *process = m_exe_ctx.GetProcessPtr();
    std::lock_guard<std::recursive_mutex> guard(
        process->GetThreadList().GetMutex());
    for (uint32_t i = 0; i < m_cjthread_count; i++) {
      auto cjthread_context = m_cjthread_info->GetChildAtIndex(i, true);
      if (!GetCJThreadStatus(m_exe_ctx.GetThreadSP(), result, cjthread_context, 0, 1)) {
        return false;
      }
    }

    return result.Succeeded();
  }
};

CommandObjectMultiwordCJThread::CommandObjectMultiwordCJThread(
    CommandInterpreter &interpreter)
    : CommandObjectMultiword(interpreter, "cjthread",
                             "Commands for operating on "
                             "one or more cjthread in "
                             "the current process.",
                             "cjthread <subcommand> [<subcommand-options>]") {
  LoadSubCommand("backtrace",
                 CommandObjectSP(new CommandObjectCJThreadBacktrace(interpreter)));
  LoadSubCommand("list",
                 CommandObjectSP(new CommandObjectCJThreadList(interpreter)));
}

CommandObjectMultiwordCJThread::~CommandObjectMultiwordCJThread() = default;

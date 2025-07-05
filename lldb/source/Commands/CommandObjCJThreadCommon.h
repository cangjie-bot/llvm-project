//===-- CommandObjCJThreadCommon.h ----------------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_SOURCE_COMMANDS_OBJCJTHREADCOMMON_H
#define LLDB_SOURCE_COMMANDS_OBJCJTHREADCOMMON_H

#include "lldb/Core/ValueObject.h"
#include "lldb/Target/ExecutionContext.h"
#include "lldb/Core/ValueObject.h"

namespace lldb_private {
class  CommandObjCJThreadCommon {
public:
  CommandObjCJThreadCommon();
  ~CommandObjCJThreadCommon();

  enum class State {
    eIdle,
    eReady,
    eRunning,
    ePending,
    eSyscall,
    eUnknown
  };
  uint64_t GetCJThreadCount(ExecutionContext exe_ctx, Status &error);
  lldb::ValueObjectSP GetCJThreadInfo(ExecutionContext exe_ctx, Status &error);
  void HandOneCJThread(lldb::ThreadSP thread, lldb::ValueObjectSP cjthread_context,
                       Status &error, bool show_all_frames = true);
  std::string GetCJThreadState(lldb::ValueObjectSP cjthread_value);
  uint64_t GetCJThreadID(lldb::ValueObjectSP cjthread_value);
  std::string GetCJThreadName(lldb::ValueObjectSP cjthread_value);
  std::vector<lldb::StackFrameSP> m_frames;
protected:

  const char *GetCJThreadInfoExp(Target *target);
  bool GetCurrentCJthreadStatus(lldb::ThreadSP thread, CommandReturnObject &result,
                                lldb::ValueObjectSP &info, uint32_t first_frame, uint32_t num_frames);
  bool GetDescription(Stream &strm, Status &error, lldb::ValueObjectSP cjthread_value);
  bool GetFramesStatus(Stream &strm, Status &error, uint32_t first_frame, uint32_t num_frames);
  lldb::ValueObjectSP GetCJthreadInfoByCJThreadID(lldb::ValueObjectSP cjthread_info, uint32_t ID);
  lldb::ValueObjectSP GetCJthreadInfoByThreadID(lldb::ValueObjectSP cjthread_info, uint32_t ID);
  void SetCJThreadRegisterContext(lldb::ValueObjectSP cjthread_context, lldb::ProcessSP process);
  bool GetCJThreadStatus(lldb::ThreadSP thread, CommandReturnObject &result,
                         lldb::ValueObjectSP cjthread_context, uint32_t first_frame, uint32_t num_frames);
  const char *CJThreadStateToString(State state);
  uint64_t m_cjthread_count = 0;
  lldb::ValueObjectSP m_cjthread_info;

private:
  std::map<ConstString, uint64_t> m_regcontext;
  const char *m_count_exp =
  "unsigned long long cjdb_cjthread_count = (unsigned long long)CJ_MRT_GetCJThreadNumberUnsafe();"
  "cjdb_cjthread_count";
#if defined(__linux__) || defined(__APPLE__)
  const char *m_info_x86_64 =
    "struct CJThreadContext {"
    "  unsigned long long rsp;"
    "  unsigned long long rbp;"
    "  unsigned long long rbx;"
    "  unsigned long long rip;"
    "  unsigned long long r12;"
    "  unsigned long long r13;"
    "  unsigned long long r14;"
    "  unsigned long long r15;"
    "  unsigned int mxcsr;"
    "  unsigned short fpuCw;"
    "};";
#endif
#if defined(_WIN32)
const char *m_info_x86_64_win =
    "struct CJThreadContext {"
    "  unsigned long long rsp;"
    "  unsigned long long rbp;"
    "  unsigned long long rbx;"
    "  unsigned long long rip;"
    "  unsigned long long r12;"
    "  unsigned long long r13;"
    "  unsigned long long r14;"
    "  unsigned long long r15;"
    "  unsigned int mxcsr;"
    "  unsigned short fpuCw;"
    "  unsigned long long rdi;"
    "  unsigned long long rsi;"
    "  unsigned long long xmm6[2];"
    "  unsigned long long xmm7[2];"
    "  unsigned long long xmm8[2];"
    "  unsigned long long xmm9[2];"
    "  unsigned long long xmm10[2];"
    "  unsigned long long xmm11[2];"
    "  unsigned long long xmm12[2];"
    "  unsigned long long xmm13[2];"
    "  unsigned long long xmm14[2];"
    "  unsigned long long xmm15[2];"
    "  unsigned long long gsStackLow;"
    "  unsigned long long gsStackHigh;"
    "  unsigned long long gsStackDeallocation;"
    "};";
#endif
  const char *m_info_aarch64 =
    "struct CJThreadContext {"
    "  unsigned long long x18;"
    "  unsigned long long x19;"
    "  unsigned long long x20;"
    "  unsigned long long x21;"
    "  unsigned long long x22;"
    "  unsigned long long x23;"
    "  unsigned long long x24;"
    "  unsigned long long x25;"
    "  unsigned long long x26;"
    "  unsigned long long x27;"
    "  unsigned long long x28;"
    "  unsigned long long fp;"
    "  unsigned long long lr;"
    "  unsigned long long pc;"
    "  unsigned long long sp;"
    "  unsigned long long d8;"
    "  unsigned long long d9;"
    "  unsigned long long d10;"
    "  unsigned long long d11;"
    "  unsigned long long d12;"
    "  unsigned long long d13;"
    "  unsigned long long d14;"
    "  unsigned long long d15;"
    "  unsigned int fpcr;"
    "};";
  const char *m_info_common =
    "struct CJThreadInfo {"
    "  char name[32];"
    "  int state;"
    "  unsigned int arg_size;"
    "  unsigned int process_id;"
    "  unsigned int tid;"
    "  void *arg_start;"
    "  unsigned long sp;"
    "  unsigned long pc;"
    "  unsigned long long id;"
    "  unsigned long long pthread_id;"
    "  struct CJThreadContext context;"
    "};";
};

}
#endif /* LLDB_SOURCE_COMMANDS_OBJCJTHREADCOMMON_H */

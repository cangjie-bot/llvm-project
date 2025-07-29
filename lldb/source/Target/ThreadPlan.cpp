//===-- ThreadPlan.cpp ----------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#include "lldb/Target/ThreadPlan.h"
#include "lldb/Core/Debugger.h"
#include "lldb/Target/Process.h"
#include "lldb/Target/RegisterContext.h"
#include "lldb/Target/Target.h"
#include "lldb/Target/Thread.h"
#include "lldb/Utility/LLDBLog.h"
#include "lldb/Utility/Log.h"
#include "lldb/Utility/State.h"
#include "lldb/Target/ThreadPlanRunToAddress.h"
#include "lldb/Target/SectionLoadList.h"

using namespace lldb;
using namespace lldb_private;

// ThreadPlan constructor
ThreadPlan::ThreadPlan(ThreadPlanKind kind, const char *name, Thread &thread,
                       Vote report_stop_vote, Vote report_run_vote)
    : m_process(*thread.GetProcess().get()), m_tid(thread.GetID()),
      m_report_stop_vote(report_stop_vote), m_report_run_vote(report_run_vote),
      m_takes_iteration_count(false), m_could_not_resolve_hw_bp(false),
      m_thread(&thread), m_kind(kind), m_name(name), m_plan_complete_mutex(),
      m_cached_plan_explains_stop(eLazyBoolCalculate), m_plan_complete(false),
      m_plan_private(false), m_okay_to_discard(true),
      m_is_controlling_plan(false), m_plan_succeeded(true) {
  SetID(GetNextID());
}

// Destructor
ThreadPlan::~ThreadPlan() = default;

Target &ThreadPlan::GetTarget() { return m_process.GetTarget(); }

const Target &ThreadPlan::GetTarget() const { return m_process.GetTarget(); }

Thread &ThreadPlan::GetThread() {
  if (m_thread)
    return *m_thread;

  ThreadSP thread_sp = m_process.GetThreadList().FindThreadByID(m_tid);
  m_thread = thread_sp.get();
  return *m_thread;
}

bool ThreadPlan::PlanExplainsStop(Event *event_ptr) {
  if (m_cached_plan_explains_stop == eLazyBoolCalculate) {
    bool actual_value = DoPlanExplainsStop(event_ptr);
    CachePlanExplainsStop(actual_value);
    return actual_value;
  } else {
    return m_cached_plan_explains_stop == eLazyBoolYes;
  }
}

bool ThreadPlan::IsPlanComplete() {
  std::lock_guard<std::recursive_mutex> guard(m_plan_complete_mutex);
  return m_plan_complete;
}

void ThreadPlan::SetPlanComplete(bool success) {
  std::lock_guard<std::recursive_mutex> guard(m_plan_complete_mutex);
  m_plan_complete = true;
  m_plan_succeeded = success;
}

bool ThreadPlan::MischiefManaged() {
  std::lock_guard<std::recursive_mutex> guard(m_plan_complete_mutex);
  // Mark the plan is complete, but don't override the success flag.
  m_plan_complete = true;
  return true;
}

Vote ThreadPlan::ShouldReportStop(Event *event_ptr) {
  Log *log = GetLog(LLDBLog::Step);

  if (m_report_stop_vote == eVoteNoOpinion) {
    ThreadPlan *prev_plan = GetPreviousPlan();
    if (prev_plan) {
      Vote prev_vote = prev_plan->ShouldReportStop(event_ptr);
      LLDB_LOG(log, "returning previous thread plan vote: {0}", prev_vote);
      return prev_vote;
    }
  }
  LLDB_LOG(log, "Returning vote: {0}", m_report_stop_vote);
  return m_report_stop_vote;
}

Vote ThreadPlan::ShouldReportRun(Event *event_ptr) {
  if (m_report_run_vote == eVoteNoOpinion) {
    ThreadPlan *prev_plan = GetPreviousPlan();
    if (prev_plan)
      return prev_plan->ShouldReportRun(event_ptr);
  }
  return m_report_run_vote;
}

void ThreadPlan::ClearThreadCache() { m_thread = nullptr; }

bool ThreadPlan::StopOthers() {
  ThreadPlan *prev_plan;
  prev_plan = GetPreviousPlan();
  return (prev_plan == nullptr) ? false : prev_plan->StopOthers();
}

void ThreadPlan::SetStopOthers(bool new_value) {
  // SetStopOthers doesn't work up the hierarchy.  You have to set the explicit
  // ThreadPlan you want to affect.
}

bool ThreadPlan::WillResume(StateType resume_state, bool current_plan) {
  m_cached_plan_explains_stop = eLazyBoolCalculate;

  if (current_plan) {
    Log *log = GetLog(LLDBLog::Step);

    if (log) {
      RegisterContext *reg_ctx = GetThread().GetRegisterContext().get();
      assert(reg_ctx);
      addr_t pc = reg_ctx->GetPC();
      addr_t sp = reg_ctx->GetSP();
      addr_t fp = reg_ctx->GetFP();
      LLDB_LOGF(
          log,
          "%s Thread #%u (0x%p): tid = 0x%4.4" PRIx64 ", pc = 0x%8.8" PRIx64
          ", sp = 0x%8.8" PRIx64 ", fp = 0x%8.8" PRIx64 ", "
          "plan = '%s', state = %s, stop others = %d",
          __FUNCTION__, GetThread().GetIndexID(),
          static_cast<void *>(&GetThread()), m_tid, static_cast<uint64_t>(pc),
          static_cast<uint64_t>(sp), static_cast<uint64_t>(fp), m_name.c_str(),
          StateAsCString(resume_state), StopOthers());
    }
  }
  bool success = DoWillResume(resume_state, current_plan);
  ClearThreadCache(); // We don't cache the thread pointer over resumes.  This
                      // Thread might go away, and another Thread represent
                      // the same underlying object on a later stop.
  return success;
}

lldb::user_id_t ThreadPlan::GetNextID() {
  static uint32_t g_nextPlanID = 0;
  return ++g_nextPlanID;
}

void ThreadPlan::DidPush() {}

void ThreadPlan::DidPop() {}

bool ThreadPlan::OkayToDiscard() {
  return IsControllingPlan() ? m_okay_to_discard : true;
}

lldb::StateType ThreadPlan::RunState() {
  if (m_tracer_sp && m_tracer_sp->TracingEnabled())
    return eStateStepping;
  else
    return GetPlanRunState();
}

bool ThreadPlan::IsUsuallyUnexplainedStopReason(lldb::StopReason reason) {
  switch (reason) {
  case eStopReasonWatchpoint:
  case eStopReasonSignal:
  case eStopReasonException:
  case eStopReasonExec:
  case eStopReasonThreadExiting:
  case eStopReasonInstrumentation:
    return true;
  default:
    return false;
  }
}

// ThreadPlanNull

ThreadPlanNull::ThreadPlanNull(Thread &thread)
    : ThreadPlan(ThreadPlan::eKindNull, "Null Thread Plan", thread,
                 eVoteNoOpinion, eVoteNoOpinion) {}

ThreadPlanNull::~ThreadPlanNull() = default;

void ThreadPlanNull::GetDescription(Stream *s, lldb::DescriptionLevel level) {
  s->PutCString("Null thread plan - thread has been destroyed.");
}

bool ThreadPlanNull::ValidatePlan(Stream *error) {
#ifdef LLDB_CONFIGURATION_DEBUG
  fprintf(stderr,
          "error: %s called on thread that has been destroyed (tid = 0x%" PRIx64
          ", ptid = 0x%" PRIx64 ")",
          LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#else
  Log *log = GetLog(LLDBLog::Thread);
  if (log)
    log->Error("%s called on thread that has been destroyed (tid = 0x%" PRIx64
               ", ptid = 0x%" PRIx64 ")",
               LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#endif
  return true;
}

bool ThreadPlanNull::ShouldStop(Event *event_ptr) {
#ifdef LLDB_CONFIGURATION_DEBUG
  fprintf(stderr,
          "error: %s called on thread that has been destroyed (tid = 0x%" PRIx64
          ", ptid = 0x%" PRIx64 ")",
          LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#else
  Log *log = GetLog(LLDBLog::Thread);
  if (log)
    log->Error("%s called on thread that has been destroyed (tid = 0x%" PRIx64
               ", ptid = 0x%" PRIx64 ")",
               LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#endif
  return true;
}

bool ThreadPlanNull::WillStop() {
#ifdef LLDB_CONFIGURATION_DEBUG
  fprintf(stderr,
          "error: %s called on thread that has been destroyed (tid = 0x%" PRIx64
          ", ptid = 0x%" PRIx64 ")",
          LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#else
  Log *log = GetLog(LLDBLog::Thread);
  if (log)
    log->Error("%s called on thread that has been destroyed (tid = 0x%" PRIx64
               ", ptid = 0x%" PRIx64 ")",
               LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#endif
  return true;
}

bool ThreadPlanNull::DoPlanExplainsStop(Event *event_ptr) {
#ifdef LLDB_CONFIGURATION_DEBUG
  fprintf(stderr,
          "error: %s called on thread that has been destroyed (tid = 0x%" PRIx64
          ", ptid = 0x%" PRIx64 ")",
          LLVM_PRETTY_FUNCTION, GetThread().GetID(), GetThread().GetProtocolID());
#else
  Log *log = GetLog(LLDBLog::Thread);
  if (log)
    log->Error("%s called on thread that has been destroyed (tid = 0x%" PRIx64
               ", ptid = 0x%" PRIx64 ")",
               LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#endif
  return true;
}

// The null plan is never done.
bool ThreadPlanNull::MischiefManaged() {
// The null plan is never done.
#ifdef LLDB_CONFIGURATION_DEBUG
  fprintf(stderr,
          "error: %s called on thread that has been destroyed (tid = 0x%" PRIx64
          ", ptid = 0x%" PRIx64 ")",
          LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#else
  Log *log = GetLog(LLDBLog::Thread);
  if (log)
    log->Error("%s called on thread that has been destroyed (tid = 0x%" PRIx64
               ", ptid = 0x%" PRIx64 ")",
               LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#endif
  return false;
}

lldb::StateType ThreadPlanNull::GetPlanRunState() {
// Not sure what to return here.  This is a dead thread.
#ifdef LLDB_CONFIGURATION_DEBUG
  fprintf(stderr,
          "error: %s called on thread that has been destroyed (tid = 0x%" PRIx64
          ", ptid = 0x%" PRIx64 ")",
          LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#else
  Log *log = GetLog(LLDBLog::Thread);
  if (log)
    log->Error("%s called on thread that has been destroyed (tid = 0x%" PRIx64
               ", ptid = 0x%" PRIx64 ")",
               LLVM_PRETTY_FUNCTION, m_tid, GetThread().GetProtocolID());
#endif
  return eStateRunning;
}

bool ThreadPlan::CFFIGetValueFromReg(Target &target, StackFrame *frame,
                                     uint64_t *addr, const char *reg) {
  if (!frame) {
    return false;
  }
  auto reg_ctx = frame->GetRegisterContext();
  if (!reg_ctx) {
    return false;
  }
  auto reg_info = reg_ctx->GetRegisterInfoByName(reg);
  if (!reg_info) {
    return false;
  }
  RegisterValue mem_addr;
  if (!reg_ctx->ReadRegister(reg_info, mem_addr)) {
    return false;
  }
  uint64_t value = mem_addr.GetAsUInt64(UINT64_MAX);
  if (value == UINT64_MAX) {
    return false;
  }
  *addr = value;
  return true;
}

ThreadPlanSP ThreadPlan::CFFIMakeThreadPlanRunToAddress(Thread &thread, uint64_t cfunc_addr,
                                                        bool stop_others) {
  typedef std::vector<lldb::addr_t> AddressVector;
  AddressVector addrs;
  addrs.push_back(cfunc_addr);
  return std::make_shared<ThreadPlanRunToAddress>(thread, addrs, stop_others);
}

static void GetCFFIRegNameFromArchitecture(Target &target, std::string &cffi_next,
                                           std::string &cffi_final) {
  auto arch_type = target.GetArchitecture().GetTriple().getArch();
  switch (arch_type) {
  case llvm::Triple::x86_64:
    cffi_next = "rsp";
#if defined(_WIN32)
    cffi_final = "rcx";
#endif
#if defined(__linux__) || defined(__APPLE__)
    cffi_final = "rdi";
#endif
    break;
  case llvm::Triple::aarch64:
    cffi_next = "x9";
    cffi_final = "x20";
    break;
  default:
    break;
  }
}

static bool IsCFFIStubFunc(ConstString name) {
  return name == "CJ_MCC_C2NStub" || name == "CJ_MCC_N2CStub";
}

static bool IsCFFIWarperFunc(ConstString name) {
  return name == "wrapper.FCivE";
}

static bool GetCFFIFuncAddrFromMemoryAddress(Target &target, uint64_t mem_addr, uint64_t *cfunc_addr) {
  Status error;
  Address symbol_containing_address;
  auto section_load_list = target.GetSectionLoadList();
  target.ReadMemory(Address(mem_addr), cfunc_addr, sizeof(uint64_t), error);
  if (error.Fail() || !section_load_list.ResolveLoadAddress(*cfunc_addr, symbol_containing_address)) {
    return false;
  }
  return true;
}

ThreadPlanSP ThreadPlan::CFFILookForPlanToStepThroughFromCurrentPC() {
  Thread &thread = GetThread();
  Target &target = GetTarget();
  auto current_pc = thread.GetRegisterContext()->GetPC();
  auto section_load_list = target.GetSectionLoadList();
  Address symbol_containing_address;
  if (!section_load_list.ResolveLoadAddress(current_pc, symbol_containing_address)) {
    return nullptr;
  }
  lldb_private::SymbolContext sym;
  symbol_containing_address.ResolveFunctionScope(sym);
  ConstString name = sym.GetFunctionName();
  StackFrame *frame = thread.GetStackFrameAtIndex(0).get();
  if (!frame) {
    return nullptr;
  }
  std::string cffi_next;
  std::string cffi_final;
  uint64_t cfunc_addr = 0;
  GetCFFIRegNameFromArchitecture(target, cffi_next, cffi_final);
  if (IsCFFIStubFunc(name)) {
    uint64_t reg_value = 0;
    if (cffi_next.empty() || cffi_final.empty()) {
      return nullptr;
    }
    CFFIGetValueFromReg(target, frame, &reg_value, cffi_next.c_str());
    auto arch_type = target.GetArchitecture().GetTriple().getArch();
    if (arch_type == llvm::Triple::x86_64) {
      // We are located in cangjie runtime function CJ_MCC_C2NStub or CJ_MCC_N2CStub,
      // we read the cfunc from the memory, the memory addr from cffi_next register require offset 0x10.
      reg_value += 0x10;
      if (!GetCFFIFuncAddrFromMemoryAddress(target, reg_value, &cfunc_addr)) {
        return nullptr;
      }
      return CFFIMakeThreadPlanRunToAddress(thread, cfunc_addr, true);
    } else if (arch_type == llvm::Triple::aarch64) {
      return CFFIMakeThreadPlanRunToAddress(thread, reg_value, true);
    }
  } else if (IsCFFIWarperFunc(name)) {
    // We are located in func warpper, we direct read the cfunc address from cffi_final register.
    CFFIGetValueFromReg(target, frame, &cfunc_addr, cffi_final.c_str());
    return CFFIMakeThreadPlanRunToAddress(thread, cfunc_addr, true);
  }
  return nullptr;
}

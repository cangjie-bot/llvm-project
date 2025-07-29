//===-- tsan_cangjie.cpp -------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// ThreadSanitizer runtime for Cangjie.
//
//===----------------------------------------------------------------------===//
#include "tsan_rtl.h"
#include "tsan_symbolize.h"
#include "sanitizer_common/sanitizer_common.h"
#include "tsan_interface.h"

extern "C" {
__tsan::Processor *CJ_MCC_TsanGetRaceProc(void) __attribute__((weak));
}

namespace __tsan {

void InitializeInterceptors() {}

void InitializeDynamicAnnotations() {}

bool IsExpectedReport(uptr addr, uptr size) {
  return false;
}

void *Alloc(uptr sz) {
  return InternalAlloc(sz);
}

void FreeImpl(void *p) {
  InternalFree(p);
}

static Processor* get_cur_proc() {
  Processor *proc = CJ_MCC_TsanGetRaceProc();
  return proc;
}

Processor *ThreadState::proc() {
  return get_cur_proc();
}

extern void MemoryAccess16(ThreadState* thr, uptr pc, uptr addr, AccessType typ);

extern "C" {
static ThreadState *AllocThreadState() {
  auto *thr = static_cast<ThreadState *>(Alloc(sizeof(ThreadState)));
  internal_memset(thr, 0, sizeof(ThreadState));
  return thr;
}

ThreadState *__tsan_init() {
  ThreadState *thr = AllocThreadState();
  Initialize(thr);
  return thr;
}

void __tsan_fini() {
  ThreadState *thr = CJ_MCC_TsanGetThreadState();
  if (thr == nullptr) {
    return;
  }
  Finalize(thr);
}

void __tsan_init_shadow(uptr addr, uptr size) {
  // `MapShadow` needs to map memory from low to high address
  MapCangjieShadow(addr, size);
}

void __tsan_read(uptr pc, uptr addr, uptr size) {
  ThreadState *thr = CJ_MCC_TsanGetThreadState();
  if (thr == nullptr) {
    return;
  }
  AccessType type = kAccessRead;
  if (size == 1 || size == 2 || size == 4 || size == 8) {
    MemoryAccess(thr, pc, addr, size, type);
  } else if (size == 16) {
    MemoryAccess16(thr, pc, addr, type);
  } else {
    MemoryAccessRange(thr, pc, addr, size, false);
  }
}

void __tsan_write(uptr pc, uptr addr, uptr size) {
  ThreadState *thr = CJ_MCC_TsanGetThreadState();
  if (thr == nullptr) {
    return;
  }
  AccessType type = kAccessWrite;
  if (size == 1 || size == 2 || size == 4 || size == 8) {
    MemoryAccess(thr, pc, addr, size, type);
  } else if (size == 16) {
    MemoryAccess16(thr, pc, addr, type);
  } else {
    MemoryAccessRange(thr, pc, addr, size, true);
  }
}

void __tsan_read_range(uptr pc, uptr addr, uptr size) {
  ThreadState *thr = CJ_MCC_TsanGetThreadState();
  if (thr == nullptr) {
    return;
  }
  MemoryAccessRange(thr, pc, addr, size, false);
}

void __tsan_write_range(uptr pc, uptr addr, uptr size) {
  ThreadState *thr = CJ_MCC_TsanGetThreadState();
  if (thr == nullptr) {
    return;
  }
  MemoryAccessRange(thr, pc, addr, size, true);
}

void __tsan_func_entry(uptr pc) {
  ThreadState *thr = CJ_MCC_TsanGetThreadState();
  if (thr == nullptr) {
    return;
  }
  FuncEntry(thr, pc);
}

void __tsan_func_exit() {
  ThreadState *thr = CJ_MCC_TsanGetThreadState();
  if (thr == nullptr) {
    return;
  }
  FuncExit(thr);
}

void __tsan_func_restore_context(uptr pc) {
  ThreadState *thr = CJ_MCC_TsanGetThreadState();
  if (thr == nullptr) {
    return;
  }

  // check if current exit function is instrumented
  if (pc != thr->shadow_stack_pos[-1]) {
    return;
  }
  FuncExit(thr);
}

void __tsan_alloc(uptr pc, uptr p, uptr sz) {
  ThreadState *thr = CJ_MCC_TsanGetThreadState();
  if (thr == nullptr) {
    return;
  }
  MemoryResetRange(thr, pc, p, sz);
}

void __tsan_clean_shadow(uptr p, uptr sz) {
  RawShadow* s = MemToShadow(RoundDownTo(p, kShadowCell));
  RawShadow* e = MemToShadow(RoundUpTo(p + sz, kShadowCell));
  ShadowSet(s, e, Shadow::kEmpty);
}

void __tsan_free(uptr pc, uptr p, uptr sz) {
  ThreadState *thr = CJ_MCC_TsanGetThreadState();
  if (thr == nullptr) {
    return;
  }
  ctx->metamap.FreeRange(get_cur_proc(), p, sz, false);
  __tsan_clean_shadow(p, sz);
}

ThreadState *__tsan_state_create(ThreadState *parent, uptr pc) {
  ThreadState *thr = AllocThreadState();
  Tid tid = ThreadCreate(parent, pc, 0, true);
  ThreadStart(thr, tid, 0, ThreadType::Regular);
  return thr;
}

void __tsan_state_delete(ThreadState *thr) {
  if (!thr) {
    return;
  }
  ThreadFinish(thr);
  Free(thr);
}

Processor *__tsan_proc_create(void) {
  return ProcCreate();
}

void __tsan_proc_destroy(Processor *proc) {
  ProcDestroy(proc);
}

void __tsan_acquire(ThreadState *thr, uptr addr) {
  if (thr == nullptr) {
    return;
  }
  Acquire(thr, 0, addr);
}

void __tsan_release_acquire(ThreadState *thr, uptr addr) {
  if (thr == nullptr) {
    return;
  }
  ReleaseStoreAcquire(thr, 0, addr);
}

void __tsan_release(ThreadState *thr, uptr addr) {
  if (thr == nullptr) {
    return;
  }
  ReleaseStore(thr, 0, addr);
}

void __tsan_release_merge(ThreadState *thr, uptr addr) {
  if (thr == nullptr) {
    return;
  }
  Release(thr, 0, addr);
}

void __tsan_fix_shadow(uptr from, uptr to, uptr size) {
  size = RoundDownTo(size, kShadowCell);

  RawShadow* fs = MemToShadow(from);
  RawShadow* ts = MemToShadow(to);
  RawShadow* fend = MemToShadow(from + size);
  uptr inc = 1;

  if (to > from) {
    // avoid corruption when `from` overlapped with `to`
    fs = MemToShadow(from + size) - 1;
    ts = MemToShadow(to + size) - 1;
    fend = MemToShadow(from) - 1;
    inc = -1;
  }

  for (; fs != fend; fs += inc, ts += inc) {
    *ts = *fs;
  }

  TraceFixAll(from, to, size);
}
}  // extern "C"
}  // namespace __tsan

; RUN: llvm-as %s -o %t
; RUN: not not ld.lld --mllvm --cangjie-pipeline -O2 --plugin-opt=no-opaque-pointers %t -o %t1 2>&1 | FileCheck --check-prefix=ABORT %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%Unit.Type = type { i8 }
%"record._ZN11std$FS$core6StringE" = type { i8 addrspace(1)*, i64 }

declare void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE"), i8*, i64) gc "cangjie"
declare void @"_ZN11std$FS$core7printlnER_ZN11std$FS$core6StringE"(%Unit.Type* sret(%Unit.Type), i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*) gc "cangjie"
declare void @CJ_MCC_ThrowStackOverflowError()
declare cangjiegccc void @MCC_SafepointStub()
declare token @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 immarg, i32 immarg, void ()*, i32 immarg, i32 immarg, ...)
declare token @"llvm.experimental.gc.statepoint.p0f_isVoidp0s_Unit.Typesp1i8p1s_record._ZN11std$FS$core6StringEsf"(i64 immarg, i32 immarg, void (%Unit.Type*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)*, i32 immarg, i32 immarg, ...)
declare token @"llvm.experimental.gc.statepoint.p0f_isVoidp0s_record._ZN11std$FS$core6StringEsp0i8i64f"(i64 immarg, i32 immarg, void (%"record._ZN11std$FS$core6StringE"*, i8*, i64)*, i32 immarg, i32 immarg, ...)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

@"$const_string.0" = private unnamed_addr constant [9 x i8] c"hello cj\00"

define void @_ZN7default4mainEv(%Unit.Type* sret(%Unit.Type) %0) gc "cangjie" {
entry:
  %callRet1 = alloca %Unit.Type
  %callRet = alloca %"record._ZN11std$FS$core6StringE"
  %1 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %1, i8 0, i64 16, i1 false)
  br label %thunk19E

thunk19E:                                         ; preds = %entry
  %statepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* elementtype(void ()) @CJ_MCC_ThrowStackOverflowError, i32 0, i32 0, i32 0, i32 0) [ "struct-live"(%"record._ZN11std$FS$core6StringE"* %callRet) ]
  %statepoint_token1 = call cangjiegccc token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* elementtype(void ()) @MCC_SafepointStub, i32 0, i32 0, i32 0, i32 0) [ "struct-live"(%"record._ZN11std$FS$core6StringE"* %callRet) ]
  %statepoint_token2 = call token (i64, i32, void (%"record._ZN11std$FS$core6StringE"*, i8*, i64)*, i32, i32, ...) @"llvm.experimental.gc.statepoint.p0f_isVoidp0s_record._ZN11std$FS$core6StringEsp0i8i64f"(i64 2882400000, i32 0, void (%"record._ZN11std$FS$core6StringE"*, i8*, i64)* elementtype(void (%"record._ZN11std$FS$core6StringE"*, i8*, i64)) @"_ZN11std$FS$core6String23createStringFromLiteralE", i32 3, i32 0, %"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @"$const_string.0", i32 0, i32 0), i64 8, i32 0, i32 0) [ "struct-live"(%"record._ZN11std$FS$core6StringE"* %callRet) ]
  %2 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %statepoint_token3 = call token (i64, i32, void (%Unit.Type*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)*, i32, i32, ...) @"llvm.experimental.gc.statepoint.p0f_isVoidp0s_Unit.Typesp1i8p1s_record._ZN11std$FS$core6StringEsf"(i64 2882400000, i32 0, void (%Unit.Type*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)* elementtype(void (%Unit.Type*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)) @"_ZN11std$FS$core7printlnER_ZN11std$FS$core6StringE", i32 3, i32 0, %Unit.Type* sret(%Unit.Type) %callRet1, i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %2, i32 0, i32 0) [ "struct-live"(%"record._ZN11std$FS$core6StringE"* %callRet) ]
  ret void
}

; ABORT: LLVM ERROR: Module has done CJRewriteStatepoint before!
; ABORT: error: Aborted

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"CJBC", i32 1}
!1 = !{i32 2, !"HasRewrittenStatepoint", i32 1}

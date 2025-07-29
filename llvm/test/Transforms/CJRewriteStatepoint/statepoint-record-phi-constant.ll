; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%record = type { i8 addrspace(1)* }
@g_var = global %record zeroinitializer

define void @foo(i1 %cond) #0 gc "cangjie" {
entry:
  %atom = alloca %record
  %atom.1 = alloca %record
  %0 = bitcast %record* %atom to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %0, i8 0, i64 8, i1 false)
  %1 = bitcast %record* %atom.1 to i8*
  br i1 %cond, label %tmp1, label %tmp2

; CHECK: tmp1
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record addrspace(1)*)* @tmp_use, i32 2, i32 0, i8 addrspace(1)* null, %record addrspace(1)* %2) [ "struct-live"(%record* %atom) ]
;
tmp1:                                       ; preds = %body1
  %2 = addrspacecast %record* %atom to %record addrspace(1)*
  call void @tmp_use(i8 addrspace(1)* null, %record addrspace(1)* %2)
  br label %tmp2

; CHECK: tmp2
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @test, i32 0, i32 0) [ "struct-live"(%record* %atom) ]
;
tmp2:                                    ; preds = %entry, %tmp1
  %sink = phi i8* [ bitcast (%record* @g_var to i8*), %entry ], [ %0, %tmp1 ]
  call void @test()
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %1, i8* %sink, i64 8, i1 false)
  ret void
}


declare void @tmp_use(i8 addrspace(1)* %arg0, %record addrspace(1)* %arg1) #0 gc "cangjie"
declare void @test() gc "cangjie"

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

attributes #0 = { "hasRcdParam" }

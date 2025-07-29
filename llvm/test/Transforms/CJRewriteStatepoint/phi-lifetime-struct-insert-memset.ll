; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s


%struct = type { i8 addrspace(1)*, i64 }

; CHECK: entry:
; CHECK:   call void @llvm.memset.p0i8.i64(i8* align 8 %0, i8 0, i64 16, i1 false)
; CHECK: bb0:
; CHECK:   call void @llvm.memset.p0i8.i64(i8* %r.cast, i8 0, i64 16, i1 false)
; CHECK: bb1:
; CHECK:   [[TMP0:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @testcase, i32 0, i32 0) [ "struct-live"(%struct* %r, %struct* %x) ]
; CHECK: bb2:
; CHECK-NEXT:   [[TMP1:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (%struct*)* @init, i32 1, i32 0, %struct* %r) [ "struct-live"(%struct* %r, %struct* %x) ]
; CHECK: bb9:
; CHECK-NEXT:   [[TMP2:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (%struct*)* @init, i32 1, i32 0, %struct* %x) [ "struct-live"(%struct* %r, %struct* %x) ]

define void @foo(i64 %w) gc "cangjie" {
entry:
  %r = alloca %struct
  %x = alloca %struct
  %r.cast = bitcast %struct* %r to i8*
  %x.cast = bitcast %struct* %x to i8*
  call void @llvm.memset.p0i8.i64(i8* %x.cast, i8 0, i64 16, i1 false)
  br label %bb0

bb0:
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %r.cast)
  br label %bb1

bb1:
  call void @testcase()
  %icmpeq = icmp eq i64 %w, 0
  br i1 %icmpeq, label %bb2, label %bb9

bb2:
  call void @llvm.memset.p0i8.i64(i8* %r.cast, i8 0, i64 16, i1 false)
  call void @init(%struct* %r)
  br label %bb3

bb9:
  call void @init(%struct* %x)
  br label %bb3

bb3:
  %in = phi %struct* [%r, %bb2], [%x, %bb9]
  %0 = addrspacecast %struct* %in to %struct addrspace(1)*
  call void @test(%struct addrspace(1)* %0)
  call void @RunGC()
  %icmp1 = icmp sgt i64 %w, 0
  br i1 %icmp1, label %bb0, label %bbend

bbend:
  ret void
}


declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1 immarg)
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)

declare void @testcase() gc "cangjie"
declare void @init(%struct* %arg0) gc "cangjie"
declare void @test(%struct addrspace(1)* %arg0) gc "cangjie"
declare void @RunGC()

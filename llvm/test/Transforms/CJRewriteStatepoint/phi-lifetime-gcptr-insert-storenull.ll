; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s


%struct = type { i8 addrspace(1)*, i64 }

; CHECK: entry:
; CHECK:   store i8 addrspace(1)* null, i8 addrspace(1)** %r, align 8
; CHECK: bb0:
; CHECK:   store i8 addrspace(1)* null, i8 addrspace(1)** %r, align 8
; CHECK: bb1:
; CHECK:   [[TMP0:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @testcase, i32 0, i32 0) [ "struct-live"(i8 addrspace(1)** %r, i8 addrspace(1)** %x) ]
; CHECK: bb2:
; CHECK-NEXT:   [[TMP1:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)**)* @init, i32 1, i32 0, i8 addrspace(1)** %r) [ "struct-live"(i8 addrspace(1)** %r, i8 addrspace(1)** %x) ]
; CHECK: bb9:
; CHECK-NEXT:   [[TMP2:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)**)* @init, i32 1, i32 0, i8 addrspace(1)** %x) [ "struct-live"(i8 addrspace(1)** %r, i8 addrspace(1)** %x) ]


define void @foo(i64 %w) gc "cangjie" {
entry:
  %r = alloca i8 addrspace(1)*
  %x = alloca i8 addrspace(1)*
  %r.cast = bitcast i8 addrspace(1)** %r to i8*
  store i8 addrspace(1)* null, i8 addrspace(1)** %x
  br label %bb0

bb0:
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %r.cast)
  br label %bb1

bb1:
  call void @testcase()
  %icmpeq = icmp eq i64 %w, 0
  br i1 %icmpeq, label %bb2, label %bb9

bb2:
  store i8 addrspace(1)* null, i8 addrspace(1)** %r
  call void @init(i8 addrspace(1)** %r)
  br label %bb3

bb9:
  call void @init(i8 addrspace(1)** %x)
  br label %bb3

bb3:
  %in = phi i8 addrspace(1)** [%r, %bb2], [%x, %bb9]
  call void @test(i8 addrspace(1)** %in)
  call void @RunGC()
  %icmp1 = icmp sgt i64 %w, 0
  br i1 %icmp1, label %bb0, label %bbend

bbend:
  ret void
}


declare void @llvm.lifetime.start.p0i8(i64 immarg, i8*)

declare void @testcase() gc "cangjie"
declare void @init(i8 addrspace(1)**) gc "cangjie"
declare void @test(i8 addrspace(1)**) gc "cangjie"
declare void @RunGC()

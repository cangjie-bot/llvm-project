; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%record = type { i32, i8 addrspace(1)* }

declare void @default()
declare void @test_func()

; CHECK: entry:
; CHECK:  %token = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @test_func, i32 0, i32 0) [ "gc-live"(i8 addrspace(1)* %arg2, i8 addrspace(1)* %arg1) ]
; CHECK:  %token2 = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @default, i32 0, i32 0) [ "struct-live"(i8 addrspace(1)** %0, i8 addrspace(1)** %1) ]
; CHECK: bb1:
; CHECK:  %token4 = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @default, i32 0, i32 0) [ "struct-live"(i8 addrspace(1)** %1, i8 addrspace(1)** %0) ]
;
define i8 addrspace(1)* @foo(i1 %cond, %record %arg0, i8 addrspace(1)* %arg1, i8 addrspace(1)* %arg2) #0 gc "cangjie" {
entry:
  %0 = alloca i8 addrspace(1)*
  %1 = alloca i8 addrspace(1)*
  call void @test_func()
  store i8 addrspace(1)* %arg1, i8 addrspace(1)** %0, align 8
  store i8 addrspace(1)* %arg2, i8 addrspace(1)** %1, align 8
  call void @default()
  br label %bb1

bb1:                                    ; preds = %entry
  %2 = select i1 %cond, i8 addrspace(1)** %0, i8 addrspace(1)** %1
  call void @default()
  %load = load i8 addrspace(1)*, i8 addrspace(1)** %2
  ret i8 addrspace(1)* %load
}

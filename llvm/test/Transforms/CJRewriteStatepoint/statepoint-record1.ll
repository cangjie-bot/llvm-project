; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%record = type { i64, i8 addrspace(1)* }

declare %record addrspace(1)* @g0(%record addrspace(1)* %arg1, i8 addrspace(1)* %arg0, i64 %arg2) #0 gc "cangjie"
declare void @g1(%record addrspace(1)* %arg1, i8 addrspace(1)* %arg0, i64 %arg2) #0 gc "cangjie"

define void @foo(%record addrspace(1)* %arg1, i8 addrspace(1)* %arg0, i64 %arg2, i64 %arg3) #0 gc "cangjie" {
; CHECK-LABEL: @foo(
; CHECK:    entry:
; CHECK:    call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, %record addrspace(1)* (%record addrspace(1)*, i8 addrspace(1)*, i64)* @g0, i32 3, i32 0, %record addrspace(1)* %arg1, i8 addrspace(1)* null, i64 %arg2) [ "gc-live"(i8 addrspace(1)* %arg0, %record addrspace(1)* %arg1) ]
; CHECK:    call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, %record addrspace(1)* (%record addrspace(1)*, i8 addrspace(1)*, i64)* @g0, i32 3, i32 0, %record addrspace(1)* %arg1.reloc.casted, i8 addrspace(1)* null, i64 %arg3) [ "gc-live"(i8 addrspace(1)* %arg0.reloc, %record addrspace(1)* %arg1.reloc.casted), "struct-live"(%record addrspace(1)** %temp) ]
; CHECK:    call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (%record addrspace(1)*, i8 addrspace(1)*, i64)* @g1, i32 3, i32 0, %record addrspace(1)* %1, i8 addrspace(1)* null, i64 %arg2) [ "gc-live"(%record addrspace(1)* %1), "struct-live"(%record addrspace(1)** %temp) ]
; CHECK:    call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (%record addrspace(1)*, i8 addrspace(1)*, i64)* @g1, i32 3, i32 0, %record addrspace(1)* %4, i8 addrspace(1)* null, i64 %arg2) [ "gc-live"(%record addrspace(1)* %4) ]
;
entry:
  %temp = alloca %record addrspace(1)*
  %0 = call %record addrspace(1)* @g0(%record addrspace(1)* %arg1, i8 addrspace(1)* null, i64 %arg2)
  store %record addrspace(1)* %0, %record addrspace(1)** %temp
  %1 = call %record addrspace(1)* @g0(%record addrspace(1)* %arg1, i8 addrspace(1)* null, i64 %arg3)
  call void @g1(%record addrspace(1)* %1, i8 addrspace(1)* null, i64 %arg2)
  %2 = load %record addrspace(1)*, %record addrspace(1)** %temp
  call void @g1(%record addrspace(1)* %2, i8 addrspace(1)* null, i64 %arg2)
  ret void
}

attributes #0 = { "record_mut" }

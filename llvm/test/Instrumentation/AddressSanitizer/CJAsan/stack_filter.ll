; This test checks stack variable instrumentation capability in cangjie.
; RUN: opt < %s -passes='asan-module' -cj-asan=true --cangjie-pipeline -S | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%TypeWithAddrSpace = type { i8 addrspace(1)* }
%Wrapper = type { %TypeWithAddrSpace }

define void @use_val(i8* %a) {
    ret void
}

define void @use_val_addrspace(i8 addrspace(1)** %a) {
    ret void
}

define void @use_val_struct(%Wrapper* %a) {
    ret void
}

define void @use_val_struct_ptr(%Wrapper** %a) {
    ret void
}

define void @use_val_array([2 x i8 addrspace(1)*]* %a) {
    ret void
}

define void @use_val_vector(<2 x i8 addrspace(1)*>* %a) {
    ret void
}

define void @use_val_struct_array([2 x %Wrapper]* %a) {
    ret void
}


; function without inout (i.e., no address_sanitize_stack annotation)
; which should not be instrumented
define void @no_stack_instrument() {
entry:
  %0 = alloca i8, align 8
  %1 = alloca i8, align 8
  call void @use_val(i8* %0)
  call void @use_val(i8* %1)
  ret void
}

; CHECK-LABEL: @no_stack_instrument
; CHECK: %0 = alloca i8, align 8
; CHECK: %1 = alloca i8, align 8

; CHECK-NOT: %MyAlloca = alloca [64 x i8], align 16
; CHECK-NOT: %asan_local_stack_base = alloca i64, align 8

; CHECK: call void @use_val(i8* %0)
; CHECK: call void @use_val(i8* %1)


; function with inout which should not be instrumented
define void @stack_instrument_var() "address_sanitize_stack" {
entry:
  %0 = alloca i8, align 8
  %1 = alloca i8, align 8
  call void @use_val(i8* %0)
  call void @use_val(i8* %1)
  ret void
}

; CHECK-LABEL: @stack_instrument_var
; CHECK-NOT: %0 = alloca i8, align 8
; CHECK-NOT: %1 = alloca i8, align 8

; CHECK: %MyAlloca = alloca [64 x i8], align 16
; CHECK: %asan_local_stack_base = alloca i64, align 8
; CHECK: store i64 %10, i64* %asan_local_stack_base, align 8
; CHECK: %11 = add i64 %10, 32
; CHECK: %12 = inttoptr i64 %11 to i8*
; CHECK: %13 = add i64 %10, 48
; CHECK: %14 = inttoptr i64 %13 to i8*

; CHECK: call void @use_val(i8* %12)
; CHECK: call void @use_val(i8* %14)


; stack variable point to heap (i.e., marked by addrspace(1))
; should not be instrumented
define void @stack_instrument_addrspace() "address_sanitize_stack" {
entry:
  %0 = alloca i8 addrspace(1)*, align 8
  %1 = alloca i8 addrspace(1)*, align 8
  call void @use_val_addrspace(i8 addrspace(1)** %0)
  call void @use_val_addrspace(i8 addrspace(1)** %1)
  ret void
}

; CHECK-LABEL: @stack_instrument_addrspace
; CHECK: %0 = alloca i8 addrspace(1)*, align 8
; CHECK: %1 = alloca i8 addrspace(1)*, align 8

; CHECK-NOT: %asan_local_stack_base = alloca i64, align 8
; CHECK-NOT: %12 = inttoptr i64 %11 to i8 addrspace(1)**
; CHECK-NOT: %14 = inttoptr i64 %13 to i8 addrspace(1)**

; CHECK: call void @use_val_addrspace(i8 addrspace(1)** %0)
; CHECK: call void @use_val_addrspace(i8 addrspace(1)** %1)


; stack variable point to heap (i.e., marked by addrspace(1))
; should not be instrumented
define void @stack_instrument_mixed() "address_sanitize_stack" {
entry:
  %0 = alloca i8, align 8
  %1 = alloca i8 addrspace(1)*, align 8
  call void @use_val(i8 * %0)
  call void @use_val_addrspace(i8 addrspace(1)** %1)
  ret void
}

; CHECK-LABEL: @stack_instrument_mixed
; CHECK-NOT: %0 = alloca i8, align 8
; CHECK-NOT: %1 = alloca i8 addrspace(1)*, align 8

; CHECK: %0 = alloca i8 addrspace(1)*, align 8
; CHECK: %MyAlloca = alloca [64 x i8], align 16
; CHECK: %asan_local_stack_base = alloca i64, align 8
; CHECK: store i64 %11, i64* %asan_local_stack_base, align 8
; CHECK: %12 = add i64 %11, 32
; CHECK: %13 = inttoptr i64 %12 to i8*

; CHECK: call void @use_val(i8* %13)
; CHECK: call void @use_val_addrspace(i8 addrspace(1)** %0)


; heap pointer in struct should not be instrumented
define void @stack_instrument_addrspace_in_struct() "address_sanitize_stack" {
entry:
  %0 = alloca %Wrapper, align 8
  call void @use_val_struct(%Wrapper* %0)
  ret void
}

; CHECK-LABEL: @stack_instrument_addrspace_in_struct
; CHECK: %0 = alloca %Wrapper, align 8

; CHECK-NOT: %MyAlloca = alloca [64 x i8], align 16
; CHECK-NOT: %asan_local_stack_base = alloca i64, align 8
; CHECK-NOT: store i64 %10, i64* %asan_local_stack_base, align 8
; CHECK-NOT: %12 = inttoptr i64 %11 to %Wrapper*

; CHECK: call void @use_val_struct(%Wrapper* %0)


; a pointer points to stack variable which contains GC ptr
; Asan should handle this ptr since:
;     if ptr is point to stack, stack map is not generated for this ptr: ignore
;     if ptr is point to heap, it already has addrspace(1) which is already handled
define void @stack_instrument_addrspace_in_struct_ptr() "address_sanitize_stack" {
entry:
  %0 = alloca %Wrapper*, align 8
  call void @use_val_struct_ptr(%Wrapper** %0)
  ret void
}

; CHECK-LABEL: @stack_instrument_addrspace_in_struct_ptr
; CHECK-NOT: %0 = alloca %Wrapper*, align 8

; CHECK: %MyAlloca = alloca [64 x i8], align 16
; CHECK: %asan_local_stack_base = alloca i64, align 8
; CHECK: store i64 %10, i64* %asan_local_stack_base, align 8
; CHECK: %11 = add i64 %10, 32
; CHECK: %12 = inttoptr i64 %11 to %Wrapper**

; CHECK: call void @use_val_struct_ptr(%Wrapper** %12)


; heap pointer in array should not be instrumented
define void @stack_instrument_addrspace_in_array() "address_sanitize_stack" {
entry:
  %0 = alloca [2 x i8 addrspace(1)*], align 8
  call void @use_val_array([2 x i8 addrspace(1)*]* %0)
  ret void
}

; CHECK-LABEL: @stack_instrument_addrspace_in_array
; CHECK: %0 = alloca [2 x i8 addrspace(1)*], align 8

; CHECK-NOT: %MyAlloca = alloca [64 x i8], align 16
; CHECK-NOT: %asan_local_stack_base = alloca i64, align 8
; CHECK-NOT: store i64 %10, i64* %asan_local_stack_base, align 8
; CHECK-NOT: %12 = inttoptr i64 %11 to [2 x i8 addrspace(1)*]*

; CHECK: call void @use_val_array([2 x i8 addrspace(1)*]* %0)


; heap pointer in struct inside array should not be instrumented
define void @stack_instrument_addrspace_in_struct_array() "address_sanitize_stack" {
entry:
  %0 = alloca [2 x %Wrapper], align 8
  call void @use_val_struct_array([2 x %Wrapper]* %0)
  ret void
}

; CHECK-LABEL: @stack_instrument_addrspace_in_struct_array
; CHECK: %0 = alloca [2 x %Wrapper], align 8

; CHECK-NOT: %MyAlloca = alloca [64 x i8], align 16
; CHECK-NOT: %asan_local_stack_base = alloca i64, align 8
; CHECK-NOT: store i64 %10, i64* %asan_local_stack_base, align 8
; CHECK-NOT: %12 = inttoptr i64 %11 to [2 x %Wrapper]*

; CHECK: call void @use_val_struct_array([2 x %Wrapper]* %0)


; heap pointer in struct inside vector should not be instrumented
define void @stack_instrument_addrspace_in_vector() "address_sanitize_stack" {
entry:
  %0 = alloca <2 x i8 addrspace(1)*>, align 8
  call void @use_val_vector(<2 x i8 addrspace(1)*>* %0)
  ret void
}

; CHECK-LABEL: @stack_instrument_addrspace_in_vector
; CHECK: %0 = alloca <2 x i8 addrspace(1)*>, align 8

; CHECK-NOT: %MyAlloca = alloca [64 x i8], align 16
; CHECK-NOT: %asan_local_stack_base = alloca i64, align 8
; CHECK-NOT: store i64 %10, i64* %asan_local_stack_base, align 8
; CHECK-NOT: %12 = inttoptr i64 %11 to <2 x i8 addrspace(1)*>*

; CHECK: call void @use_val_vector(<2 x i8 addrspace(1)*>* %0)

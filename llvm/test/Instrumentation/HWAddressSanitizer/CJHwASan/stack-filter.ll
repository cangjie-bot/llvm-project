; RUN: opt < %s -passes=hwasan -cj-hwasan=true --cangjie-pipeline -S | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux"

%TypeWithAddrSpace = type { i8 addrspace(1)* }
%Wrapper = type { %TypeWithAddrSpace }

declare void @use_val(i8* %a)

declare void @use_val_addrspace(i8 addrspace(1)** %a)

declare void @use_val_struct(%Wrapper* %a)

declare void @use_val_struct_ptr(%Wrapper** %a)

declare void @use_val_array([2 x i8 addrspace(1)*]* %a)

declare void @use_val_vector(<2 x i8 addrspace(1)*>* %a)

declare void @use_val_struct_array([2 x %Wrapper]* %a)


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

; CHECK-NOT: %alloca.0.hwasan = inttoptr i64 %20 to i8*
; CHECK-NOT: %alloca.1.hwasan = inttoptr i64 %32 to i8*

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

; CHECK: %alloca.0.hwasan = inttoptr i64 %20 to i8*
; CHECK: %alloca.1.hwasan = inttoptr i64 %32 to i8*

; CHECK: call void @use_val(i8* %alloca.0.hwasan)
; CHECK: call void @use_val(i8* %alloca.1.hwasan)


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

; CHECK-NOT: %alloca.0.hwasan = inttoptr i64 %20 to i8 addrspace(1)**
; CHECK-NOT: %alloca.1.hwasan = inttoptr i64 %32 to i8 addrspace(1)**

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

; CHECK: %alloca.0.hwasan = inttoptr i64 %20 to i8*
; CHECK: %27 = alloca i8 addrspace(1)*, align 8

; CHECK: call void @use_val(i8* %alloca.0.hwasan)
; CHECK: call void @use_val_addrspace(i8 addrspace(1)** %27)


; heap pointer in struct should not be instrumented
define void @stack_instrument_addrspace_in_struct() "address_sanitize_stack" {
entry:
  %0 = alloca %Wrapper, align 8
  call void @use_val_struct(%Wrapper* %0)
  ret void
}

; CHECK-LABEL: @stack_instrument_addrspace_in_struct
; CHECK: %0 = alloca %Wrapper, align 8

; CHECK-NOT: %alloca.0.hwasan = inttoptr i64 %20 to %Wrapper*

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

; CHECK: %alloca.0.hwasan = inttoptr i64 %20 to %Wrapper**

; CHECK: call void @use_val_struct_ptr(%Wrapper** %alloca.0.hwasan)


; heap pointer in array should not be instrumented
define void @stack_instrument_addrspace_in_array() "address_sanitize_stack" {
entry:
  %0 = alloca [2 x i8 addrspace(1)*], align 8
  call void @use_val_array([2 x i8 addrspace(1)*]* %0)
  ret void
}

; CHECK-LABEL: @stack_instrument_addrspace_in_array
; CHECK: %0 = alloca [2 x i8 addrspace(1)*], align 8
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
; CHECK: call void @use_val_vector(<2 x i8 addrspace(1)*>* %0)

; This test checks global variable instrumentation capability in cangjie.
; RUN: opt < %s -passes='asan-module' -cj-asan=true --cangjie-pipeline -S | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%TypeWithAddrSpace = type { i8 addrspace(1)* }
%Wrapper = type { %TypeWithAddrSpace }

; not a user-defined global
;
@no_instrument = global i32 1
; CHECK: @no_instrument = global i32 1

@no_instrument_gc_ptr = global i8 addrspace(1)* null
; CHECK: @no_instrument_gc_ptr = global i8 addrspace(1)* null

; user-defined global, marked with sanitize_global
;
@val_global = global i32 1 #0
; CHECK: @val_global = global { i32, [12 x i8] } { i32 1, [12 x i8] zeroinitializer }, align 16 #0

@val_array = global [16 x i8] zeroinitializer #0
; CHECK: @val_array = global { [16 x i8], [16 x i8] } zeroinitializer, align 16 #0

@val_ptr = global %Wrapper* null #0
; CHECK: @val_ptr = global { %Wrapper*, [8 x i8] } zeroinitializer, align 16 #0

; cannot instrument, is a GC ptr
@gc_val_global = global i8 addrspace(1)* null #0
; CHECK: @gc_val_global = global i8 addrspace(1)* null #0

; cannot instrument, contains a GC ptr
@gc_array = global [16 x i8 addrspace(1)*] zeroinitializer #0
; CHECK: @gc_array = global [16 x i8 addrspace(1)*] zeroinitializer #0

@gc_vector = global <2 x i8 addrspace(1)*> zeroinitializer #0
; CHECK: @gc_vector = global <2 x i8 addrspace(1)*> zeroinitializer #0

@gc_struct = global %Wrapper zeroinitializer #0
; CHECK: @gc_struct = global %Wrapper zeroinitializer #0

@gc_struct_array = global [2 x %Wrapper] zeroinitializer #0
; CHECK: @gc_struct_array = global [2 x %Wrapper] zeroinitializer #0

attributes #0 = { "address_sanitize_global" }
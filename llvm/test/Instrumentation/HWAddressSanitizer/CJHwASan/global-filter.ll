; RUN: opt < %s -passes=hwasan -cj-hwasan=true --cangjie-pipeline -S | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux"

%TypeWithAddrSpace = type { i8 addrspace(1)* }
%Wrapper = type { %TypeWithAddrSpace }

; not a user-defined global
;
@no_instrument = global i32 1
@no_instrument_gc_ptr = global i8 addrspace(1)* null

; user-defined global, marked with sanitize_global
;
@val_global = global i32 1 #0
@val_array = global [16 x i8] zeroinitializer #0
@val_ptr = global %Wrapper* null #0

; cannot instrument, is a GC ptr
@gc_val_global = global i8 addrspace(1)* null #0

; cannot instrument, contains a GC ptr
@gc_array = global [16 x i8 addrspace(1)*] zeroinitializer #0
@gc_vector = global <2 x i8 addrspace(1)*> zeroinitializer #0
@gc_struct = global %Wrapper zeroinitializer #0
@gc_struct_array = global [2 x %Wrapper] zeroinitializer #0

attributes #0 = { "address_sanitize_global" }

; CHECK: @no_instrument = global i32 1
; CHECK: @no_instrument_gc_ptr = global i8 addrspace(1)* null
; CHECK: @gc_val_global = global i8 addrspace(1)* null #0
; CHECK: @gc_array = global [16 x i8 addrspace(1)*] zeroinitializer #0
; CHECK: @gc_vector = global <2 x i8 addrspace(1)*> zeroinitializer #0
; CHECK: @gc_struct = global %Wrapper zeroinitializer #0
; CHECK: @gc_struct_array = global [2 x %Wrapper] zeroinitializer #0

; CHECK: @val_global.hwasan = private global { i32, [12 x i8] } { i32 1, [12 x i8] c"\00\00\00\00\00\00\00\00\00\00\00I" }, align 16 #0
; CHECK: @val_array.hwasan = private global [16 x i8] zeroinitializer, align 16 #0
; CHECK: @val_ptr.hwasan = private global { %Wrapper*, [8 x i8] } { %Wrapper* null, [8 x i8] c"\00\00\00\00\00\00\00K" }, align 16 #0

; CHECK: @val_global = alias i32, inttoptr (i64 add (i64 ptrtoint ({ i32, [12 x i8] }* @val_global.hwasan to i64), i64 5260204364768739328) to i32*)
; CHECK: @val_array = alias [16 x i8], inttoptr (i64 add (i64 ptrtoint ([16 x i8]* @val_array.hwasan to i64), i64 5332261958806667264) to [16 x i8]*)
; CHECK: @val_ptr = alias %Wrapper*, inttoptr (i64 add (i64 ptrtoint ({ %Wrapper*, [8 x i8] }* @val_ptr.hwasan to i64), i64 5404319552844595200) to %Wrapper**)
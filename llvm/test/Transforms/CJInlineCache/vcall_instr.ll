; RUN: opt -S --iv-call-instrument-enable=true -passes='cj-runtime-lowering' < %s | FileCheck %s
; XFAIL: *

; ModuleID = 'dyncall.bc'
source_filename = "0-default"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%KlassInfo.1 = type { i32, i32, %BitMap*, %KlassInfo.0*, i8**, i64*, i64*, i8*, i64*, i32, [1 x %KlassInfo.0*] }
%BitMap = type { i32, [0 x i8] }
%KlassInfo.0 = type { i32, i32, %BitMap*, %KlassInfo.0*, i8**, i64*, i64*, i8*, i64*, i32, [0 x %KlassInfo.0*] }
%Unit.Type = type { i8 }
%ObjLayout.A = type { %ObjLayout._ZN8std.core6ObjectE }
%ObjLayout._ZN8std.core6ObjectE = type { %ObjLayout.Object }
%ObjLayout.Object = type { %KlassInfo.1* }
%ObjLayout.B = type { %ObjLayout.A }
@A.vtable = internal global [2 x i8*] [i8* null, i8* bitcast (void (%Unit.Type*, i8 addrspace(1)*)* @TestA to i8*)] #1
@A.typeName = internal global [2 x i8] c"A\00", align 1
@A.objKlass = weak_odr global %KlassInfo.0 { i32 0, i32 0, %BitMap* null, %KlassInfo.0* bitcast (%KlassInfo.1* @_ZN8std.core6ObjectE.objKlass to %KlassInfo.0*), i8** getelementptr inbounds ([2 x i8*], [2 x i8*]* @A.vtable, i32 0, i32 0), i64* null, i64* null, i8* null, i64* bitcast ([2 x i8]* @A.typeName to i64*), i32 0, [0 x %KlassInfo.0*] zeroinitializer }
@B.vtable = internal global [2 x i8*] [i8* null, i8* bitcast (void (%Unit.Type*, i8 addrspace(1)*)* @TestB to i8*)] #1
@B.typeName = internal global [2 x i8] c"B\00", align 1
@B.objKlass = weak_odr global %KlassInfo.0 { i32 0, i32 0, %BitMap* null, %KlassInfo.0* @A.objKlass, i8** getelementptr inbounds ([2 x i8*], [2 x i8*]* @B.vtable, i32 0, i32 0), i64* null, i64* null, i8* null, i64* bitcast ([2 x i8]* @B.typeName to i64*), i32 0, [0 x %KlassInfo.0*] zeroinitializer }
@_ZN8std.core6ObjectE.objKlass = external global %KlassInfo.1 #0

; Function Attrs: nounwind
declare i8* @llvm.cj.get.virtual.func(i8 addrspace(1)*, i64) #6

define void @TestA(%Unit.Type* noalias sret(%Unit.Type) %0, i8 addrspace(1)* %this) gc "cangjie" {
  ret void
}

define void @TestB(%Unit.Type* noalias sret(%Unit.Type) %0, i8 addrspace(1)* %this) gc "cangjie" {
  ret void
}

define void @InstrTest(%Unit.Type* noalias sret(%Unit.Type) %0, i8 addrspace(1)* %a) gc "cangjie" {
; CHECK: call void @CJ_MCC_IVCallInstrumentation(i8* %2, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @"InstrTest:bb0:0", i32 0, i32 0))
bb0:
  %1 = alloca %Unit.Type, align 8
  %2 = call i8* @llvm.cj.get.virtual.func(i8 addrspace(1)* noalias %a, i64 1)
  %3 = bitcast i8* %2 to void (%Unit.Type*, i8 addrspace(1)*)*
  call void %3(%Unit.Type* noalias sret(%Unit.Type) %1, i8 addrspace(1)* %a)
  ret void
}

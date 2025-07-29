; RUN: opt < %s '-passes=cj-pea' -cj-disable-partial-ea -S | FileCheck %s --check-prefixes=PEA

%BitMap = type { i32, [0 x i8] }
%_ZN7default8CrcCheckE.objKlass.reflectType = type { i32, i32, i32, i32, i32, i8* }
%ObjLayout._ZN7default8CrcCheck = type { %record._ZN8std.core5ArrayIlE, %record._ZN8std.core5ArrayIlE, %record._ZN8std.core5ArrayIlE, i64, i64, i64 }
%record._ZN8std.core5ArrayIlE = type { i8 addrspace(1)*, i64, i64 }
%ArrayLayout.Int64 = type { %ArrayBase, [0 x i64] }
%ArrayBase = type { i64 }
%TypeInfo = type { i8*, i8, i8, i16, i32, %BitMap*, i32, i8, i8, i32*, i8*, i8*, i8*, %TypeInfo*, i8*, i8* }
%TypeTemplate = type { i8*, i8, i8, i16, i16, i8*, i8*, i8*, i8* }

@_ZN7default20var_1715509008039_60E = global i8 0, align 8
@A1_lE.typeName = internal global [6 x i8] c"A1_lE\00", align 1
@_ZN7default8CrcCheck.ti = internal global %TypeInfo {i8* getelementptr inbounds ([17 x i8], [17 x i8]* @"default$CrcCheck.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$CrcCheck.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$CrcCheck.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$CrcCheck.fieldNames" to i8*)}, !RelatedType !1
@"default$CrcCheck.name" = internal global [17 x i8] c"default$CrcCheck\00", align 1
@"std.core$Object.ti" = external global %TypeInfo
@"default$CrcCheck.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$CrcCheck.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$CrcCheck.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$CrcCheck.field.1.name", i32 0, i32 0)]
@"default$CrcCheck.field.1.name" = internal global [3 x i8] c"aa\00", align 1
@"RawArray<Int64>.ti" = internal global %TypeInfo { i8* getelementptr inbounds ([16 x i8], [16 x i8]* @"RawArray<Int64>.name", i32 0, i32 0), i8 -126, i8 0, i16 0, i32 8, %BitMap* null, i32 0, i8 8, i8  0, i32* null, i8* bitcast (%TypeTemplate* @RawArray.tt to i8*), i8* null, i8* null, %TypeInfo* @Int64.ti, i8* null, i8* null }, !RelatedType !0
@"RawArray<Int64>.name" = internal global [16 x i8] c"RawArray<Int64>\00", align 1
@RawArray.tt = external global %TypeTemplate
@Int64.ti = external global %TypeInfo

declare i8 addrspace(1)* @CJ_MCC_NewObject(i8*, i32)

declare i8 addrspace(1)* @CJ_MCC_NewArray(i8*, i64)

; Function Attrs: argmemonly nounwind
declare void @llvm.cj.gcwrite.ref(i8 addrspace(1)*, i8 addrspace(1)* nocapture, i8 addrspace(1)* addrspace(1)* nocapture) #0

; Function Attrs: argmemonly nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p1i8.i64(i8 addrspace(1)* nocapture writeonly, i8, i64, i1 immarg) #1

define i64 @goo(i8 addrspace(1)* nocapture %this, i64 %input) gc "cangjie" {
bb0:
  %0 = bitcast i8 addrspace(1)* %this to { %TypeInfo*, %ObjLayout._ZN7default8CrcCheck } addrspace(1)*
  %1 = getelementptr inbounds { %TypeInfo*, %ObjLayout._ZN7default8CrcCheck }, { %TypeInfo*, %ObjLayout._ZN7default8CrcCheck } addrspace(1)* %0, i64 0, i32 1, i32 4
  %2 = load i64, i64 addrspace(1)* %1, align 8
  %3 = getelementptr inbounds { %TypeInfo*, %ObjLayout._ZN7default8CrcCheck }, { %TypeInfo*, %ObjLayout._ZN7default8CrcCheck } addrspace(1)* %0, i64 0, i32 1, i32 0, i32 2
  %4 = load i64, i64 addrspace(1)* %3, align 8
  br label %bb1

bb1:                                              ; preds = %bb0
  %5 = add i64 %4, %input
  ret i64 %5
}

; PEA: %0 = alloca { %TypeInfo*, { %ArrayBase, [33 x i64] } }
; PEA: %1 = alloca { %TypeInfo*, { %ArrayBase, [50 x i64] } }
; PEA: %2 = alloca { %TypeInfo*, { %ArrayBase, [0 x i64] } }
; PEA: %3 = alloca { %TypeInfo*, %ObjLayout._ZN7default8CrcCheck }
define i64 @foo() gc "cangjie" {
bb0:
  %0 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default8CrcCheck.ti to i8*), i32 104)
  %1 = call i8 addrspace(1)* @CJ_MCC_NewArray(i8* bitcast (%TypeInfo* @"RawArray<Int64>.ti" to i8*), i64 0)
  %2 = call i8 addrspace(1)* @CJ_MCC_NewArray(i8* bitcast (%TypeInfo* @"RawArray<Int64>.ti" to i8*), i64 50)
  %3 = call i8 addrspace(1)* @CJ_MCC_NewArray(i8* bitcast (%TypeInfo* @"RawArray<Int64>.ti" to i8*), i64 33)
  %4 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 88
  %5 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 56
  %6 = bitcast i8 addrspace(1)* %5 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %1, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %6)
  %7 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 64
  call void @llvm.memset.p1i8.i64(i8 addrspace(1)* noundef align 8 dereferenceable(16) %7, i8 0, i64 16, i1 false)
  %8 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 8
  %9 = bitcast i8 addrspace(1)* %8 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %2, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %9)
  %10 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 16
  store i8 0, i8 addrspace(1)* %10, align 8
  %11 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 24
  %12 = bitcast i8 addrspace(1)* %11 to i64 addrspace(1)*
  store i64 5000, i64 addrspace(1)* %12, align 8
  %13 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 80
  %14 = bitcast i8 addrspace(1)* %13 to i64 addrspace(1)*
  store i64 33, i64 addrspace(1)* %14, align 8
  %15 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 32
  %16 = bitcast i8 addrspace(1)* %15 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %3, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %16)
  %17 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 40
  %18 = bitcast i8 addrspace(1)* %17 to i64 addrspace(1)*
  store i64 0, i64 addrspace(1)* %18, align 8
  %19 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 48
  %20 = bitcast i8 addrspace(1)* %19 to i64 addrspace(1)*
  %21 = load i8, i8* @_ZN7default20var_1715509008039_60E, align 8
  %22 = mul i8 %21, %21
  %23 = zext i8 %22 to i64
  %24 = call i64 @goo(i8 addrspace(1)* %0, i64 %23)
  store i64 %24, i64 addrspace(1)* %20, align 8
  ret i64 %24
}

!0 = !{!"ArrayLayout.Int64"}
!1 = !{!"ObjLayout._ZN7default8CrcCheck"}

attributes #0 = { argmemonly nounwind }
attributes #1 = { argmemonly nocallback nofree nounwind willreturn writeonly }

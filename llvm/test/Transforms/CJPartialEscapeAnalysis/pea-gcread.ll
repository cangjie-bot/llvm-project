; RUN: opt < %s '-passes=cj-pea' -cj-disable-partial-ea -S | FileCheck %s --check-prefixes=PEA
; RUN: opt < %s '-passes=cj-pea' -S | FileCheck %s --check-prefixes=Partial

%record._ZN8std.core6StringE = type { %record._ZN8std.core5ArrayIhE, i64 }
%record._ZN8std.core5ArrayIhE = type { i8 addrspace(1)*, i64, i64 }
%BitMap = type { i32, [0 x i8] }
%TypeTemplate = type { i8*, i8, i8, i16, i16, i8*, i8*, i8*, i8* }
%default.pkgInfoType = type { i32, i32, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%TypeInfo = type { i8*, i8, i8, i16, i32, %BitMap*, i32, i8, i8, i32*, i8*, i8*, i8*, %TypeInfo*, i8*, i8* }
%ArrayLayout.refArray = type { %ArrayBase, [0 x i8 addrspace(1)*] }
%ArrayLayout.UInt8 = type { %ArrayBase, [0 x i8] }
%ArrayBase = type { i64 }
%ObjLayout._ZN7default3ObjE = type {i64, i64}
@roUInt8.arrayKlass = weak_odr global %TypeInfo { i8* getelementptr inbounds ([16 x i8], [16 x i8]* @"RawArray<UInt8>.name", i32 0, i32 0), i8 -126, i8 0, i16 0, i32 0, %BitMap* null, i32 0, i8 0, i8 0,     i32* null, i8* bitcast (%TypeTemplate* @RawArray.tt to i8*), i8* null, i8* null, %TypeInfo* @UInt8.ti, i8* null, i8* null }, !RelatedType !1
@"RawArray<UInt8>.name" = internal global [16 x i8] c"RawArray<UInt8>\00", align 1
@"$const_cjstring_data.0" = internal constant { i8*, i64, [533 x i8] } { i8* bitcast (%TypeInfo* @roUInt8.arrayKlass to i8*), i64 533, [533 x i8] c"\09ms    Out of memory is not equal to array size:, length is , start is , step should be 1.An exception has occurred:Array negative index accessCopy length out of boundsDstStart is greater than or equal to the size of the target arrayIllegal step JohnNegative copy lengthProperty Access - NoneExtension:\09Range size:SrcStart is greater than or equal to the size of this arrayThe result would be greater than UInt32.Max.The result would be less than UInt32.Min.The size of Array is UNYaddmulsubthe value of the step should not be zero.\0A" }
@A1_C_ZN7default3ObjEE.typeName = weak_odr global [22 x i8] c"A1_C_ZN7default3ObjEE\00", align 1
@_ZN7default3ObjE.ti = internal global %TypeInfo {i8* getelementptr inbounds ([12 x i8], [12 x i8]* @"default$Obj.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$Obj.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$Obj.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$Obj.fieldNames" to i8*) }, !RelatedType !2
@"default$Obj.name" = internal global [12 x i8] c"default$Obj\00", align 1
@"default$Obj.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$Obj.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$Obj.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$Obj.field.1.name", i32 0, i32 0)]
@"default$Obj.field.1.name" = internal global [3 x i8] c"aa\00", align 1
@"RawArray<Obj>.ti" = internal global %TypeInfo { i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"RawArray<Obj>.name", i32 0, i32 0), i8 -126, i8 0, i16 0, i32 8, %BitMap* null, i32 0, i8 8, i8 0, i32* null, i8* bitcast (%TypeTemplate* @RawArray.tt to i8*), i8* null, i8* null, %TypeInfo* @"std.core$Object.ti", i8* null, i8* null }, !RelatedType !0
@"RawArray<Obj>.name" = internal global [14 x i8] c"RawArray<Obj>\00"
@RawArray.tt = external global %TypeTemplate
@"std.core$Object.ti" = external global %TypeInfo
@"$const_cjstring.21" = internal unnamed_addr constant { { i8 addrspace(1)*, i64, i64 }, i64 } { { i8 addrspace(1)*, i64, i64 } { i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [533 x i8] }* @"$const_cjstring_data.0" to i8*) to i8 addrspace(1)*), i64 246, i64 4 }, i64 0 }
@UInt8.ti = external global %TypeInfo

declare i8 addrspace(1)* @CJ_MCC_NewObject(i8*, i32)
declare void @llvm.cj.gcwrite.ref(i8 addrspace(1)*, i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)*)
declare void @llvm.memcpy.p1i8.p0i8.i64(i8 addrspace(1)*, i8*, i64, i1)
declare i8 addrspace(1)* @CJ_MCC_NewArray(i8*, i64)
declare i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)*)
declare i1 @"_ZN7default14$noneextension6Person5equalEC_ZN7default14$noneextension6PersonE"(i8 addrspace(1)*, i8 addrspace(1)*)
declare void @llvm.memcpy.p0i8.p1i8.i64(i8*, i8 addrspace(1)*, i64, i1)

; PEA: %0 = alloca { %TypeInfo*, { %ArrayBase, [3 x i8 addrspace(1)*] } }
; PEA: %person1 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default3ObjE.ti to i8*), i32 48)
; PEA: %person2 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default3ObjE.ti to i8*), i32 48)
; PEA: %person3 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default3ObjE.ti to i8*), i32 48)
; Partial: %0 = alloca { %TypeInfo*, %ObjLayout._ZN7default3ObjE }
; Partial: %1 = alloca { %TypeInfo*, %ObjLayout._ZN7default3ObjE }
; Partial: %2 = alloca { %TypeInfo*, %ObjLayout._ZN7default3ObjE }
; Partial: %3 = alloca { %TypeInfo*, { %ArrayBase, [3 x i8 addrspace(1)*] } }
define void @foo() gc "cangjie" {
bb0:
  %a0 = alloca %record._ZN8std.core6StringE
  %a1 = alloca %record._ZN8std.core6StringE
  %person1 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default3ObjE.ti to i8*), i32 48)
  %0 = getelementptr inbounds i8, i8 addrspace(1)* %person1, i64 8
  %1 = bitcast i8 addrspace(1)* %0 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [533 x i8] }* @"$const_cjstring_data.0" to i8*) to i8 addrspace(1)*), i8 addrspace(1)* %person1, i8 addrspace(1)* addrspace(1)* %1)
  %2 = getelementptr inbounds i8, i8 addrspace(1)* %person1, i64 16
  call void @llvm.memcpy.p1i8.p0i8.i64(i8 addrspace(1)* noundef align 8 dereferenceable(24) %2, i8* noundef nonnull align 8 dereferenceable(24) bitcast (i64* getelementptr inbounds ({ { i8 addrspace(1)*, i64, i64 }, i64 }, { { i8 addrspace(1)*, i64, i64 }, i64 }* @"$const_cjstring.21", i64 0, i32 0, i32 1) to i8*), i64 24, i1 false)
  %3 = getelementptr inbounds i8, i8 addrspace(1)* %person1, i64 40
  %4 = bitcast i8 addrspace(1)* %3 to i64 addrspace(1)*
  store i64 12, i64 addrspace(1)* %4, align 8
  %person2 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default3ObjE.ti to i8*), i32 48)
  %5 = getelementptr inbounds i8, i8 addrspace(1)* %person2, i64 8
  %6 = bitcast i8 addrspace(1)* %5 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [533 x i8] }* @"$const_cjstring_data.0" to i8*) to i8 addrspace(1)*), i8 addrspace(1)* %person2, i8 addrspace(1)* addrspace(1)* %6)
  %7 = getelementptr inbounds i8, i8 addrspace(1)* %person2, i64 16
  call void @llvm.memcpy.p1i8.p0i8.i64(i8 addrspace(1)* noundef align 8 dereferenceable(24) %7, i8* noundef nonnull align 8 dereferenceable(24) bitcast (i64* getelementptr inbounds ({ { i8 addrspace(1)*, i64, i64 }, i64 }, { { i8 addrspace(1)*, i64, i64 }, i64 }* @"$const_cjstring.21", i64 0, i32 0, i32 1) to i8*), i64 24, i1 false)
  %8 = getelementptr inbounds i8, i8 addrspace(1)* %person2, i64 40
  %9 = bitcast i8 addrspace(1)* %8 to i64 addrspace(1)*
  store i64 13, i64 addrspace(1)* %9, align 8
  %person3 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default3ObjE.ti to i8*), i32 48)
  %10 = getelementptr inbounds i8, i8 addrspace(1)* %person3, i64 8
  %11 = bitcast i8 addrspace(1)* %10 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [533 x i8] }* @"$const_cjstring_data.0" to i8*) to i8 addrspace(1)*), i8 addrspace(1)* %person3, i8 addrspace(1)* addrspace(1)* %11)
  %12 = getelementptr inbounds i8, i8 addrspace(1)* %person3, i64 16
  %13 = getelementptr inbounds i8, i8 addrspace(1)* %person3, i64 40
  %14 = bitcast i8 addrspace(1)* %13 to i64 addrspace(1)*
  store i64 14, i64 addrspace(1)* %14, align 8
  %15 = call noalias i8 addrspace(1)* @CJ_MCC_NewArray(i8* bitcast (%TypeInfo* @"RawArray<Obj>.ti" to i8*), i64 3)
  %16 = bitcast i8 addrspace(1)* %15 to %ArrayLayout.refArray addrspace(1)*
  %17 = getelementptr inbounds i8, i8 addrspace(1)* %15, i64 16
  %18 = bitcast i8 addrspace(1)* %17 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %person1, i8 addrspace(1)* %15, i8 addrspace(1)* addrspace(1)* %18)
  %19 = getelementptr inbounds i8, i8 addrspace(1)* %15, i64 24
  %20 = bitcast i8 addrspace(1)* %19 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %person2, i8 addrspace(1)* %15, i8 addrspace(1)* addrspace(1)* %20)
  %21 = getelementptr inbounds i8, i8 addrspace(1)* %15, i64 32
  %22 = bitcast i8 addrspace(1)* %21 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %person3, i8 addrspace(1)* %15, i8 addrspace(1)* addrspace(1)* %22)
  br label %loop1

loop1:
  %.0 = phi i64 [0, %bb0], [%Srem, %loop1]
  %icmpslt = icmp slt i64 %.0, 100000
  %Srem = srem i64 %.0, 3
  %23 = getelementptr inbounds %ArrayLayout.refArray, %ArrayLayout.refArray addrspace(1)* %16, i64 0, i32 1, i64 %Srem
  %a = call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %15, i8 addrspace(1)* addrspace(1)* %23)
  %24 = getelementptr inbounds i8, i8 addrspace(1)* %a, i64 8
  %25 = bitcast i8 addrspace(1)* %24 to i8 addrspace(1)* addrspace(1)*
  %26 = call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %a, i8 addrspace(1)* addrspace(1)* %25)
  %27 = getelementptr inbounds %record._ZN8std.core6StringE, %record._ZN8std.core6StringE* %a1, i64 0, i32 0, i32 0
  store i8 addrspace(1)* %26, i8 addrspace(1)** %27, align 8
  %28 = getelementptr inbounds %record._ZN8std.core6StringE, %record._ZN8std.core6StringE* %a1, i64 0, i32 0, i32 1
  %29 = bitcast i64* %28 to i8*
  %30 = getelementptr inbounds i8, i8 addrspace(1)* %a, i64 16
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %29, i8 addrspace(1)* noundef align 8 dereferenceable(24) %30, i64 24, i1 false)
  %31 = getelementptr inbounds i8, i8 addrspace(1)* %person1, i64 8
  %32 = bitcast i8 addrspace(1)* %31 to i8 addrspace(1)* addrspace(1)*
  %33 = call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %person1, i8 addrspace(1)* addrspace(1)* %32)
  %34 = getelementptr inbounds %record._ZN8std.core6StringE, %record._ZN8std.core6StringE* %a0, i64 0, i32 0, i32 0
  store i8 addrspace(1)* %33, i8 addrspace(1)** %34, align 8
  %35 = getelementptr inbounds %record._ZN8std.core6StringE, %record._ZN8std.core6StringE* %a0, i64 0, i32 0, i32 1
  %36 = bitcast i64* %35 to i8*
  %37 = getelementptr inbounds i8, i8 addrspace(1)* %person1, i64 16
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %36, i8 addrspace(1)* noundef align 8 dereferenceable(24) %37, i64 24, i1 false)
  br i1 %icmpslt, label %loop1, label %bb1

bb1:
  ret void
}

!0 = !{!"ArrayLayout.refArray"}
!1 = !{!"ArrayLayout.UInt8"}
!2 = !{!"ObjLayout._ZN7default3ObjE"}

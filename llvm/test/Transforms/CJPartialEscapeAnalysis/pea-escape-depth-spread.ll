; RUN: opt < %s '-passes=cj-pea' -cj-disable-partial-ea -S | FileCheck %s

source_filename = "default"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%TypeInfo = type { i8*, i8, i8, i16, i32, %BitMap*, i32, i8, i8, i32*, i8*, i8*, i8*, %TypeInfo*, i8*, i8* }
%BitMap = type { i32, [0 x i8] }
%ObjLayout._ZN7default5HumanE = type { %"typeC" }
%ObjLayout.Env = type { i8 addrspace(1)* }
%"record._ZN8std$core5RangeItE" = type { i16, i16, i64, i1, i1, i1 }
%"record._ZN8std$core5RangeImE" = type { i64, i64, i64, i1, i1, i1 }
%"T4_R_ZN8std$core5RangeItEmcsE" = type { %"record._ZN8std$core5RangeItE", i64, i32, i16 }
%"typeB" = type { i16, %"T4_R_ZN8std$core5RangeItEmcsE", %"typeC", i8 addrspace(1)* }
%"typeC" = type { %"record._ZN8std$core5RangeImE", [2 x i8], i32, float, i1 }
%"record._ZN8std$core5ArrayIuE" = type { i8 addrspace(1)*, i64, i64 }

@"std.core$Object.ti" = external global %TypeInfo
@Env.ti = weak_odr global %TypeInfo {i8* getelementptr inbounds ([12 x i8], [12 x i8]* @"default$Env.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$Env.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$Env.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$Env.fieldNames" to i8*)}, !RelatedType !0
@"default$Env.name" = internal global [12 x i8] c"default$Env\00", align 1
@"default$Env.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$Env.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$Env.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$Env.field.1.name", i32 0, i32 0)]
@"default$Env.field.1.name" = internal global [3 x i8] c"aa\00", align 1

@_ZN7default5HumanE.ti = weak_odr global %TypeInfo {i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"default$Human.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$Human.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$Human.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$Human.fieldNames" to i8*)}, !RelatedType !1
@"default$Human.name" = internal global [14 x i8] c"default$Human\00", align 1
@"default$Human.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$Human.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$Human.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$Human.field.1.name", i32 0, i32 0)]
@"default$Human.field.1.name" = internal global [3 x i8] c"aa\00"

define void @"func"(%"typeB"* noalias nocapture writeonly sret(%"typeB") %0, i8 addrspace(1)* nocapture readnone %"param$BP", %"record._ZN8std$core5ArrayIuE" addrspace(1)* nocapture readnone %param) #25 gc "cangjie" {
; CHECK-LABEL: @func(
; CHECK-LABEL: entry
; CHECK-NEXT: %1 = alloca { %TypeInfo*, %ObjLayout.Env }, align 8
; CHECK-NEXT: %2 = alloca %typeB, align 8
entry:
  %1 = alloca %"typeB", align 8
  %2 = alloca %"typeC", align 8
  %callRet = alloca %"typeB", align 8
  %3 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 56)
  %4 = bitcast %"typeC"* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 48, i8* nonnull %4)
  %atom.sroa.0.0..sroa_idx.i = getelementptr inbounds %"typeC", %"typeC"* %2, i64 0, i32 0, i32 0
  store i64 107, i64* %atom.sroa.0.0..sroa_idx.i, align 8
  %atom.sroa.3.0..sroa_idx3.i = getelementptr inbounds %"typeC", %"typeC"* %2, i64 0, i32 0, i32 1
  store i64 123, i64* %atom.sroa.3.0..sroa_idx3.i, align 8
  %atom.sroa.4.0..sroa_idx6.i = getelementptr inbounds %"typeC", %"typeC"* %2, i64 0, i32 0, i32 2
  store i64 -57, i64* %atom.sroa.4.0..sroa_idx6.i, align 8
  %atom.sroa.5.0..sroa_idx9.i = getelementptr inbounds %"typeC", %"typeC"* %2, i64 0, i32 0, i32 3
  store i1 true, i1* %atom.sroa.5.0..sroa_idx9.i, align 8
  %atom.sroa.6.0..sroa_idx12.i = getelementptr inbounds %"typeC", %"typeC"* %2, i64 0, i32 0, i32 4
  store i1 true, i1* %atom.sroa.6.0..sroa_idx12.i, align 1
  %atom.sroa.7.0..sroa_idx15.i = getelementptr inbounds %"typeC", %"typeC"* %2, i64 0, i32 0, i32 5
  store i1 true, i1* %atom.sroa.7.0..sroa_idx15.i, align 2
  %atom.sroa.8.0..sroa_raw_cast.i = bitcast %"typeC"* %2 to i8*
  %atom.sroa.8.0..sroa_raw_idx.i = getelementptr inbounds i8, i8* %atom.sroa.8.0..sroa_raw_cast.i, i64 27
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(5) %atom.sroa.8.0..sroa_raw_idx.i, i8 0, i64 5, i1 false)
  %5 = getelementptr inbounds %"typeC", %"typeC"* %2, i64 0, i32 1, i64 0
  %6 = bitcast i8* %5 to i16*
  store i16 4883, i16* %6, align 8
  %7 = getelementptr inbounds %"typeC", %"typeC"* %2, i64 0, i32 2
  store i32 -52, i32* %7, align 4
  %8 = getelementptr inbounds %"typeC", %"typeC"* %2, i64 0, i32 3
  store float 5.700000e+01, float* %8, align 8
  %9 = getelementptr inbounds %"typeC", %"typeC"* %2, i64 0, i32 4
  store i1 true, i1* %9, align 4
  %10 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 8
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %3, i8 addrspace(1)* %10, i8* nonnull %atom.sroa.8.0..sroa_raw_cast.i, i64 48)
  %11 = bitcast %"typeC"* %2 to i8*
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %11)
  %12 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Env.ti to i8*), i32 16)
  %13 = getelementptr inbounds i8, i8 addrspace(1)* %12, i64 8
  %14 = bitcast i8 addrspace(1)* %13 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %3, i8 addrspace(1)* %12, i8 addrspace(1)* addrspace(1)* %14)
  %15 = bitcast %"typeB"* %callRet to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %15, i8 0, i64 104, i1 false)
  %16 = bitcast %"typeB"* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 104, i8* nonnull %16)
  %17 = getelementptr inbounds i8, i8 addrspace(1)* %12, i64 8
  %18 = bitcast i8 addrspace(1)* %17 to i8 addrspace(1)* addrspace(1)*
  %19 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %18, align 8
  %20 = getelementptr inbounds i8, i8 addrspace(1)* %19, i64 8
  %21 = bitcast %"typeB"* %1 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %21, i8 0, i64 104, i1 false)
  %22 = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 0
  store i16 147, i16* %22, align 8
  %tryvalue.sroa.0.0..sroa_idx.i = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 1
  %tryvalue.sroa.0.0..sroa_cast.i = bitcast %"T4_R_ZN8std$core5RangeItEmcsE"* %tryvalue.sroa.0.0..sroa_idx.i to i8*
  %tryvalue.sroa.0.sroa.0.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx.i = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 1, i32 0, i32 0
  store i16 33, i16* %tryvalue.sroa.0.sroa.0.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx.i, align 8
  %tryvalue.sroa.0.sroa.2.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx35.i = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 1, i32 0, i32 1
  store i16 27, i16* %tryvalue.sroa.0.sroa.2.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx35.i, align 2
  %tryvalue.sroa.0.sroa.3.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx.i = getelementptr inbounds i8, i8* %tryvalue.sroa.0.0..sroa_cast.i, i64 4
  %tryvalue.sroa.0.sroa.3.0.tryvalue.sroa.0.0..sroa_cast.sroa_cast.i = bitcast i8* %tryvalue.sroa.0.sroa.3.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx.i to i32*
  store i32 0, i32* %tryvalue.sroa.0.sroa.3.0.tryvalue.sroa.0.0..sroa_cast.sroa_cast.i, align 4
  %tryvalue.sroa.0.sroa.4.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx36.i = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 1, i32 0, i32 2
  store i64 7, i64* %tryvalue.sroa.0.sroa.4.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx36.i, align 8
  %tryvalue.sroa.0.sroa.5.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx37.i = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 1, i32 0, i32 3
  store i1 true, i1* %tryvalue.sroa.0.sroa.5.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx37.i, align 8
  %tryvalue.sroa.0.sroa.6.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx38.i = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 1, i32 0, i32 4
  store i1 true, i1* %tryvalue.sroa.0.sroa.6.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx38.i, align 1
  %tryvalue.sroa.0.sroa.7.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx39.i = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 1, i32 0, i32 5
  store i1 true, i1* %tryvalue.sroa.0.sroa.7.0.tryvalue.sroa.0.0..sroa_cast.sroa_idx39.i, align 2
  %tryvalue.sroa.0.sroa.8.0.tryvalue.sroa.0.0..sroa_cast.sroa_raw_idx.i = getelementptr inbounds i8, i8* %21, i64 27
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(5) %tryvalue.sroa.0.sroa.8.0.tryvalue.sroa.0.0..sroa_cast.sroa_raw_idx.i, i8 0, i64 5, i1 false)
  %tryvalue.sroa.2.0..sroa_idx14.i = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 1, i32 1
  store i64 5, i64* %tryvalue.sroa.2.0..sroa_idx14.i, align 8
  %tryvalue.sroa.3.0..sroa_idx15.i = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 1, i32 2
  store i32 121, i32* %tryvalue.sroa.3.0..sroa_idx15.i, align 8
  %tryvalue.sroa.4.0..sroa_idx16.i = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 1, i32 3
  store i16 53, i16* %tryvalue.sroa.4.0..sroa_idx16.i, align 4
  %23 = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 2
  %24 = bitcast %"typeC"* %23 to i8*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(48) %24, i8 addrspace(1)* noundef align 8 dereferenceable(48) %20, i64 48, i1 false)
  %25 = getelementptr inbounds %"typeB", %"typeB"* %1, i64 0, i32 3
  store i8 addrspace(1)* %19, i8 addrspace(1)** %25, align 8
  %26 = bitcast %"typeB"* %callRet to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(104) %26, i8* noundef nonnull align 8 dereferenceable(104) %21, i64 104, i1 false)
  %27 = bitcast %"typeB"* %1 to i8*
  call void @llvm.lifetime.end.p0i8(i64 104, i8* nonnull %27)
  %28 = bitcast %"typeB"* %0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(104) %28, i8* noundef nonnull align 8 dereferenceable(104) %15, i64 104, i1 false)
  ret void
}

declare i8 addrspace(1)* @CJ_MCC_NewObject(i8*, i32) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)*, i8 addrspace(1)* noalias nocapture writeonly, i8* noalias nocapture readonly, i64) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.cj.gcwrite.struct.p1i8(i8 addrspace(1)*, i8 addrspace(1)* noalias nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.cj.gcwrite.ref(i8 addrspace(1)*, i8 addrspace(1)* nocapture, i8 addrspace(1)* addrspace(1)* nocapture) #4

; Function Attrs: nounwind
declare void @llvm.cj.memset.p0i8(i8*, i8, i64, i1) #5

; Function Attrs: argmemonly nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #6

; Function Attrs: argmemonly nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #6

; Function Attrs: argmemonly nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #7

; Function Attrs: argmemonly nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #8

; Function Attrs: argmemonly nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p1i8.i64(i8* noalias nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64, i1 immarg) #8

!0 = !{!"ObjLayout.Env"}
!1 = !{!"ObjLayout._ZN7default5HumanE"}

attributes #0 = { "CFileKlass" }
attributes #1 = { "CFileVTable" }
attributes #2 = { "CFileITable" }
attributes #3 = { "cj-runtime" }
attributes #4 = { argmemonly nounwind }
attributes #5 = { nounwind }
attributes #6 = { argmemonly nocallback nofree nosync nounwind willreturn }
attributes #7 = { argmemonly nocallback nofree nounwind willreturn writeonly }
attributes #8 = { argmemonly nocallback nofree nounwind willreturn }

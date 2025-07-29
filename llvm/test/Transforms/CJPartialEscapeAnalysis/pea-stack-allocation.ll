; RUN: opt < %s '-passes=cj-pea' -cj-disable-partial-ea -S | FileCheck %s

%Unit.Type = type { i8 }

declare void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)*) gc "cangjie"
declare void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE"), i8*, i64) gc "cangjie"
declare void @CJ_MCC_ThrowException(i8 addrspace(1)*)
declare i8 addrspace(1)* @CJ_MCC_NewObject(i8*, i32)
declare void @llvm.cj.gcwrite.ref(i8 addrspace(1)*, i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)*)
declare void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)*, i8 addrspace(1)*, i8* , i64)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1 immarg)
declare void @llvm.cj.memset(i8*, i8, i64, i1)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64)
declare i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*) gc "cangjie"
declare i8 addrspace(1)* @CJ_MCC_NewObjArray(i64, i8*)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1 immarg)

%TypeTemplate = type { i8*, i8, i8, i16, i16, i8*, i8*, i8*, i8* }
%TypeInfo = type { i8*, i8, i8, i16, i32, %BitMap*, i32, i8, i8, i32*, i8*, i8*, i8*, %TypeInfo*, i8*, i8* }
%BitMap = type { i32, [0 x i8] }
%ArrayBase = type { i64 }
%ObjLayout.Location = type { i8 addrspace(1)*, %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE" }
%ObjLayout._ZN7default8LocationE = type { %TypeInfo*, i8 addrspace(1)*, %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE" }
%"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE" = type { i8 addrspace(1)*, i64, i64 }
%"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" = type { %ArrayBase, [0 x %"record._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE"] }
%"record._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" = type { i8 addrspace(1)*, i64, i64 }
%ObjLayout.Point = type { i64, i64 }
%ObjLayout._ZN7default5PointE = type { %TypeInfo*, i64, i64 }
%ArrayLayout.refArray = type { %ArrayBase, [0 x i8 addrspace(1)*] }
%ObjLayout.Human = type { i8 addrspace(1)* }
%ObjLayout._ZN7default5HumanE = type { %TypeInfo*, i8 addrspace(1)* }
%"record._ZN11std$FS$core6StringE" = type { i8 addrspace(1)*, i64 }
%ObjLayout.people = type { i8 addrspace(1)*, i8 addrspace(1)*, i8 addrspace(1)* }
%ObjLayout.Except = type { i8 addrspace(1)*, i8 addrspace(1)*, i8 addrspace(1)* }

@"std.core$Object.ti" = external global %TypeInfo
@people.ti = weak_odr global %TypeInfo {i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"default$people.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$people.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$people.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$people.fieldNames" to i8*)}, !RelatedType !1
@"default$people.name" = internal global [14 x i8] c"default$peopl\00", align 1
@"default$people.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$people.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$people.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$people.field.1.name", i32 0, i32 0)]
@"default$people.field.1.name" = internal global [3 x i8] c"aa\00", align 1

@Location.ti = weak_odr global %TypeInfo {i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"default$Location.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$Location.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$Location.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$Location.fieldNames" to i8*)}, !RelatedType !2
@"default$Location.name" = internal global [14 x i8] c"default$Locat\00", align 1
@"default$Location.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$Location.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$Location.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$Location.field.1.name", i32 0, i32 0)]
@"default$Location.field.1.name" = internal global [3 x i8] c"aa\00", align 1

@Point.ti = weak_odr global %TypeInfo {i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"default$Point.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$Point.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$Point.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$Point.fieldNames" to i8*)}, !RelatedType !3
@"default$Point.name" = internal global [14 x i8] c"default$Point\00", align 1
@"default$Point.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$Point.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$Point.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$Point.field.1.name", i32 0, i32 0)]
@"default$Point.field.1.name" = internal global [3 x i8] c"aa\00", align 1

@"RawArray<Point>.ti" = internal global %TypeInfo { i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"RawArray<Point>.name", i32 0, i32 0), i8 -126, i8 0, i16 0, i32 8, %BitMap* null, i32 0, i8 8, i8 0, i32* null, i8* bitcast (%TypeTemplate* @RawArray.tt to i8*), i8* null, i8* null, %TypeInfo* @"std.core$Object.ti", i8* null, i8* null }, !RelatedType !0
@"RawArray<Point>.name" = internal global [14 x i8] c"RawArray<Obj>\00"
@RawArray.tt = external global %TypeTemplate

@Except.ti = weak_odr global %TypeInfo {i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"default$Except.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$Except.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$Except.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$Except.fieldNames" to i8*)}, !RelatedType !4
@"default$Except.name" = internal global [14 x i8] c"default$Excep\00", align 1
@"default$Except.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$Except.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$Except.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$Except.field.1.name", i32 0, i32 0)]
@"default$Except.field.1.name" = internal global [3 x i8] c"aa\00"

@Human.ti = weak_odr global %TypeInfo {i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"default$Human.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$Human.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$Human.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$Human.fieldNames" to i8*)}, !RelatedType !5
@"default$Human.name" = internal global [14 x i8] c"default$Human\00", align 1
@"default$Human.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$Human.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$Human.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$Human.field.1.name", i32 0, i32 0)]
@"default$Human.field.1.name" = internal global [3 x i8] c"aa\00"

define void @_ZN7default5Human12reproductionEC_ZN7default6PlanetEC_ZN7default6PlanetE(%Unit.Type* noalias sret(%Unit.Type) %0, i8 addrspace(1)* %this, i8 addrspace(1)* %s, i8 addrspace(1)* %ns) gc "cangjie" {
; CHECK-LABEL: @_ZN7default5Human12reproductionEC_ZN7default6PlanetEC_ZN7default6PlanetE(
; CHECK-LABEL: entry
; CHECK-NEXT: %1 = alloca { %TypeInfo*, %ObjLayout.people }, align 8
; CHECK-NEXT: %2 = alloca { %TypeInfo*, %ObjLayout.Human }, align 8
; CHECK-NEXT: %3 = alloca { %TypeInfo*, %ObjLayout.Human }, align 8
; CHECK-NEXT: %4 = alloca { %TypeInfo*, %ObjLayout.Human }, align 8
; CHECK-NOT: @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @people.ti to i8*)

entry:
  %callRet = alloca %Unit.Type, align 8
  %1 = call i64 @_ZN7default5Human14countNeighborsEC_ZN7default6PlanetE(i8 addrspace(1)* %this, i8 addrspace(1)* %s)
  %2 = and i64 %1, -2
  %3 = icmp eq i64 %2, 2
  br i1 %3, label %land.rhs2, label %if1558end

land.rhs2:                                        ; preds = %entry
  %4 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 8
  %5 = bitcast i8 addrspace(1)* %4 to %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)*
  %6 = load %ObjLayout._ZN7default8LocationE addrspace(1)*, %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)* %5, align 8
  %7 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %6, i64 0, i32 1
  %8 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %7, align 8
  %9 = call i1 @_ZN7default6Planet17isPopulationAliveEC_ZN7default5PointE(i8 addrspace(1)* %ns, i8 addrspace(1)* %8)
  br i1 %9, label %if1558end, label %if1558then

if1558then:                                       ; preds = %land.rhs2
  %10 = bitcast i8 addrspace(1)* %4 to %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)*
  %11 = load %ObjLayout._ZN7default8LocationE addrspace(1)*, %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)* %10, align 8
  %12 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %11, i64 0, i32 1
  %13 = bitcast i8 addrspace(1)* addrspace(1)* %12 to %ObjLayout._ZN7default5PointE addrspace(1)* addrspace(1)*
  %14 = load %ObjLayout._ZN7default5PointE addrspace(1)*, %ObjLayout._ZN7default5PointE addrspace(1)* addrspace(1)* %13, align 8
  %15 = getelementptr inbounds i8, i8 addrspace(1)* %ns, i64 16
  %16 = getelementptr inbounds %ObjLayout._ZN7default5PointE, %ObjLayout._ZN7default5PointE addrspace(1)* %14, i64 0, i32 1
  %17 = load i64, i64 addrspace(1)* %16, align 8
  %icmpslt5 = icmp slt i64 %17, 0
  br i1 %icmpslt5, label %if7477then, label %lor.rhs

lor.rhs:                                          ; preds = %if1558then
  %18 = getelementptr inbounds i8, i8 addrspace(1)* %ns, i64 32
  %19 = bitcast i8 addrspace(1)* %18 to i64 addrspace(1)*
  %20 = load i64, i64 addrspace(1)* %19, align 8
  %icmpsge.not = icmp slt i64 %17, %20
  br i1 %icmpsge.not, label %if7477end, label %if7477then

if7477then:                                       ; preds = %if1558then, %lor.rhs
  %21 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Except.ti to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %21)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %21)
  unreachable

if7477end:                                        ; preds = %lor.rhs
  %22 = bitcast i8 addrspace(1)* %15 to %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* addrspace(1)*
  %23 = load %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)*, %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* addrspace(1)* %22, align 8
  %24 = getelementptr inbounds i8, i8 addrspace(1)* %ns, i64 24
  %25 = bitcast i8 addrspace(1)* %24 to i64 addrspace(1)*
  %26 = load i64, i64 addrspace(1)* %25, align 8
  %add = add i64 %26, %17
  %arr.get.sroa.0.0..sroa_idx = getelementptr inbounds %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE", %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* %23, i64 0, i32 1, i64 %add, i32 0
  %arr.get.sroa.0.0.copyload = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arr.get.sroa.0.0..sroa_idx, align 8
  %arr.get.sroa.4.0..sroa_idx13 = getelementptr inbounds %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE", %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* %23, i64 0, i32 1, i64 %add, i32 2
  %arr.get.sroa.4.0.copyload = load i64, i64 addrspace(1)* %arr.get.sroa.4.0..sroa_idx13, align 8
  %27 = getelementptr inbounds %ObjLayout._ZN7default5PointE, %ObjLayout._ZN7default5PointE addrspace(1)* %14, i64 0, i32 2
  %28 = load i64, i64 addrspace(1)* %27, align 8
  %icmpslt9 = icmp slt i64 %28, 0
  %icmpsge12 = icmp sge i64 %28, %arr.get.sroa.4.0.copyload
  %conv14 = or i1 %icmpslt9, %icmpsge12
  br i1 %conv14, label %if7523then, label %if7523end

if7523then:                                       ; preds = %if7477end
  %29 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Except.ti to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %29)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %29)
  unreachable

if7523end:                                        ; preds = %if7477end
  %arr.get.sroa.3.0..sroa_idx12 = getelementptr inbounds %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE", %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* %23, i64 0, i32 1, i64 %add, i32 1
  %arr.get.sroa.3.0.copyload = load i64, i64 addrspace(1)* %arr.get.sroa.3.0..sroa_idx12, align 8
  %add16 = add i64 %arr.get.sroa.3.0.copyload, %28
  %30 = bitcast i8 addrspace(1)* %arr.get.sroa.0.0.copyload to %ArrayLayout.refArray addrspace(1)*
  %arr.idx.set.gep = getelementptr inbounds %ArrayLayout.refArray, %ArrayLayout.refArray addrspace(1)* %30, i64 0, i32 1, i64 %add16
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %this, i8 addrspace(1)* %arr.get.sroa.0.0.copyload, i8 addrspace(1)* addrspace(1)* %arr.idx.set.gep)
  br label %if1558end

if1558end:                                        ; preds = %land.rhs2, %entry, %if7523end
  %31 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 8
  %32 = bitcast i8 addrspace(1)* %31 to %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)*
  %33 = load %ObjLayout._ZN7default8LocationE addrspace(1)*, %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)* %32, align 8
  %34 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %33, i64 0, i32 2, i32 2
  %35 = load i64, i64 addrspace(1)* %34, align 8
  %icmpsge17 = icmp slt i64 %35, 1
  br i1 %icmpsge17, label %if7570then, label %if7570end

  if7570then:                                       ; preds = %if1558end
  %36 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Except.ti to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %36)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %36)
  unreachable

if7570end:                                        ; preds = %if1558end
  %37 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %33, i64 0, i32 2
  %38 = bitcast %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE" addrspace(1)* %37 to %ArrayLayout.refArray addrspace(1)* addrspace(1)*
  %39 = load %ArrayLayout.refArray addrspace(1)*, %ArrayLayout.refArray addrspace(1)* addrspace(1)* %38, align 8
  %40 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %33, i64 0, i32 2, i32 1
  %41 = load i64, i64 addrspace(1)* %40, align 8
  %arr.idx.get.gep19 = getelementptr inbounds %ArrayLayout.refArray, %ArrayLayout.refArray addrspace(1)* %39, i64 0, i32 1, i64 %41
  %42 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arr.idx.get.gep19, align 8
  %43 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Human.ti to i8*), i32 16)
  %44 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Location.ti to i8*), i32 40)
  call fastcc void @_ZN7default8Location4initEC_ZN7default5PointE(i8 addrspace(1)* %44, i8 addrspace(1)* %42)
  %45 = getelementptr inbounds i8, i8 addrspace(1)* %43, i64 8
  %46 = bitcast i8 addrspace(1)* %45 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %44, i8 addrspace(1)* %43, i8 addrspace(1)* addrspace(1)* %46)
  %47 = bitcast i8 addrspace(1)* %31 to %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)*
  %48 = load %ObjLayout._ZN7default8LocationE addrspace(1)*, %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)* %47, align 8
  %49 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %48, i64 0, i32 2, i32 2
  %50 = load i64, i64 addrspace(1)* %49, align 8
  %icmpsge20 = icmp slt i64 %50, 2
  br i1 %icmpsge20, label %if7644then, label %if7644end

if7644then:                                       ; preds = %if7570end
  %51 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Except.ti to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %51)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %51)
  unreachable

if7644end:                                        ; preds = %if7570end
  %52 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %48, i64 0, i32 2
  %53 = bitcast %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE" addrspace(1)* %52 to %ArrayLayout.refArray addrspace(1)* addrspace(1)*
  %54 = load %ArrayLayout.refArray addrspace(1)*, %ArrayLayout.refArray addrspace(1)* addrspace(1)* %53, align 8
  %55 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %48, i64 0, i32 2, i32 1
  %56 = load i64, i64 addrspace(1)* %55, align 8
  %add22 = add i64 %56, 1
  %arr.idx.get.gep23 = getelementptr inbounds %ArrayLayout.refArray, %ArrayLayout.refArray addrspace(1)* %54, i64 0, i32 1, i64 %add22
  %57 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arr.idx.get.gep23, align 8
  %58 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Human.ti to i8*), i32 16)
  %59 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Location.ti to i8*), i32 40)
  call fastcc void @_ZN7default8Location4initEC_ZN7default5PointE(i8 addrspace(1)* %59, i8 addrspace(1)* %57)
  %60 = getelementptr inbounds i8, i8 addrspace(1)* %58, i64 8
  %61 = bitcast i8 addrspace(1)* %60 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %59, i8 addrspace(1)* %58, i8 addrspace(1)* addrspace(1)* %61)
  %62 = bitcast i8 addrspace(1)* %31 to %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)*
  %63 = load %ObjLayout._ZN7default8LocationE addrspace(1)*, %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)* %62, align 8
  %64 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %63, i64 0, i32 2, i32 2
  %65 = load i64, i64 addrspace(1)* %64, align 8
  %icmpsge25 = icmp slt i64 %65, 3
  br i1 %icmpsge25, label %if7718then, label %if7718end

if7718then:                                       ; preds = %if7644end
  %66 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Except.ti to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %66)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %66)
  unreachable

if7718end:                                        ; preds = %if7644end
  %67 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %63, i64 0, i32 2
  %68 = bitcast %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE" addrspace(1)* %67 to %ArrayLayout.refArray addrspace(1)* addrspace(1)*
  %69 = load %ArrayLayout.refArray addrspace(1)*, %ArrayLayout.refArray addrspace(1)* addrspace(1)* %68, align 8
  %70 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %63, i64 0, i32 2, i32 1
  %71 = load i64, i64 addrspace(1)* %70, align 8
  %add27 = add i64 %71, 2
  %arr.idx.get.gep28 = getelementptr inbounds %ArrayLayout.refArray, %ArrayLayout.refArray addrspace(1)* %69, i64 0, i32 1, i64 %add27
  %72 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arr.idx.get.gep28, align 8
  %73 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Human.ti to i8*), i32 16)
  %74 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Location.ti to i8*), i32 40)
  call fastcc void @_ZN7default8Location4initEC_ZN7default5PointE(i8 addrspace(1)* %74, i8 addrspace(1)* %72)
  %75 = getelementptr inbounds i8, i8 addrspace(1)* %73, i64 8
  %76 = bitcast i8 addrspace(1)* %75 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %74, i8 addrspace(1)* %73, i8 addrspace(1)* addrspace(1)* %76)
  %77 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @people.ti to i8*), i32 32)
  %78 = getelementptr inbounds i8, i8 addrspace(1)* %77, i64 8
  %79 = bitcast i8 addrspace(1)* %78 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %43, i8 addrspace(1)* %77, i8 addrspace(1)* addrspace(1)* %79)
  %80 = getelementptr inbounds i8, i8 addrspace(1)* %77, i64 16
  %81 = bitcast i8 addrspace(1)* %80 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %58, i8 addrspace(1)* %77, i8 addrspace(1)* addrspace(1)* %81)
  %82 = getelementptr inbounds i8, i8 addrspace(1)* %77, i64 24
  %83 = bitcast i8 addrspace(1)* %82 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %73, i8 addrspace(1)* %77, i8 addrspace(1)* addrspace(1)* %83)
  %84 = bitcast i8 addrspace(1)* %78 to %ObjLayout._ZN7default5HumanE addrspace(1)* addrspace(1)*
  %85 = load %ObjLayout._ZN7default5HumanE addrspace(1)*, %ObjLayout._ZN7default5HumanE addrspace(1)* addrspace(1)* %84, align 8
  %86 = getelementptr inbounds %ObjLayout._ZN7default5HumanE, %ObjLayout._ZN7default5HumanE addrspace(1)* %85, i64 0, i32 1
  %87 = bitcast i8 addrspace(1)* addrspace(1)* %86 to %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)*
  %88 = load %ObjLayout._ZN7default8LocationE addrspace(1)*, %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)* %87, align 8
  %89 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %88, i64 0, i32 1
  %90 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %89, align 8
  %91 = getelementptr inbounds i8, i8 addrspace(1)* %90, i64 8
  %92 = bitcast i8 addrspace(1)* %91 to i64 addrspace(1)*
  %93 = load i64, i64 addrspace(1)* %92, align 8
  %icmpsge30 = icmp sgt i64 %93, -1
  br i1 %icmpsge30, label %land.rhs32, label %if1680end

land.rhs32:                                       ; preds = %if7718end
  %94 = getelementptr inbounds i8, i8 addrspace(1)* %90, i64 16
  %95 = bitcast i8 addrspace(1)* %94 to i64 addrspace(1)*
  %96 = load i64, i64 addrspace(1)* %95, align 8
  %icmpsge33 = icmp sgt i64 %96, -1
  br i1 %icmpsge33, label %land.rhs37, label %if1680end

land.rhs37:                                       ; preds = %land.rhs32
  %97 = getelementptr inbounds i8, i8 addrspace(1)* %ns, i64 40
  %98 = bitcast i8 addrspace(1)* %97 to i64 addrspace(1)*
  %99 = load i64, i64 addrspace(1)* %98, align 8
  %icmpslt38 = icmp slt i64 %93, %99
  br i1 %icmpslt38, label %land.rhs42, label %if1680end

land.rhs42:                                       ; preds = %land.rhs37
  %100 = getelementptr inbounds i8, i8 addrspace(1)* %ns, i64 48
  %101 = bitcast i8 addrspace(1)* %100 to i64 addrspace(1)*
  %102 = load i64, i64 addrspace(1)* %101, align 8
  %icmpslt43 = icmp slt i64 %96, %102
  br i1 %icmpslt43, label %land.rhs47, label %if1680end

land.rhs47:                                       ; preds = %land.rhs42
  %103 = call i1 @_ZN7default6Planet17isPopulationAliveEC_ZN7default5PointE(i8 addrspace(1)* %s, i8 addrspace(1)* %90)
  br i1 %103, label %if1680end, label %if1680then

if1680then:                                       ; preds = %land.rhs47
  %104 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Location.ti to i8*), i32 40)
  call fastcc void @_ZN7default8Location4initEC_ZN7default5PointE(i8 addrspace(1)* %104, i8 addrspace(1)* %90)
  %105 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Human.ti to i8*), i32 16)
  %106 = getelementptr inbounds i8, i8 addrspace(1)* %105, i64 8
  %107 = bitcast i8 addrspace(1)* %106 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %104, i8 addrspace(1)* %105, i8 addrspace(1)* addrspace(1)* %107)
  call void @_ZN7default6Planet11occupyPlaceEC_ZN7default5PointEC_ZN7default5HumanE(%Unit.Type* noalias nonnull sret(%Unit.Type) %callRet, i8 addrspace(1)* %ns, i8 addrspace(1)* %90, i8 addrspace(1)* %105)
  br label %if1680end

if1680end:                                        ; preds = %land.rhs37, %if7718end, %land.rhs32, %land.rhs47, %land.rhs42, %if1680then
  ret void
}

define internal i64 @_ZN7default5Human14countNeighborsEC_ZN7default6PlanetE(i8 addrspace(1)* %this, i8 addrspace(1)* %s) gc "cangjie" {
entry:
  %callRet = alloca %"record._ZN11std$FS$core6StringE", align 8
  %0 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %0, i8 0, i64 16, i1 false)
  br label %block1451body

block1451body:                                    ; preds = %if1491end, %entry
  %atom.6799E.0 = phi i64 [ 0, %entry ], [ %add, %if1491end ]
  %atom.6801E.0 = phi i64 [ 0, %entry ], [ %atom.6801E.1, %if1491end ]
  %icmpslt = icmp slt i64 %atom.6799E.0, 8
  br i1 %icmpslt, label %while1503body, label %block1451end

while1503body:                                    ; preds = %block1451body
  %add = add i64 %atom.6799E.0, 1
  %1 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 8
  %2 = bitcast i8 addrspace(1)* %1 to %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)*
  %3 = load %ObjLayout._ZN7default8LocationE addrspace(1)*, %ObjLayout._ZN7default8LocationE addrspace(1)* addrspace(1)* %2, align 8
  %4 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %3, i64 0, i32 2
  %icmpslt1 = icmp slt i64 %atom.6799E.0, 0
  br i1 %icmpslt1, label %if7304then, label %lor.rhs

lor.rhs:                                          ; preds = %while1503body
  %5 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %3, i64 0, i32 2, i32 2
  %6 = load i64, i64 addrspace(1)* %5, align 8
  %icmpsge.not = icmp slt i64 %atom.6799E.0, %6
  br i1 %icmpsge.not, label %if7304end, label %if7304then

if7304then:                                       ; preds = %while1503body, %lor.rhs
  %7 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Except.ti to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %7)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %7)
  unreachable

if7304end:                                        ; preds = %lor.rhs
  %8 = bitcast %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE" addrspace(1)* %4 to %ArrayLayout.refArray addrspace(1)* addrspace(1)*
  %9 = load %ArrayLayout.refArray addrspace(1)*, %ArrayLayout.refArray addrspace(1)* addrspace(1)* %8, align 8
  %10 = getelementptr inbounds %ObjLayout._ZN7default8LocationE, %ObjLayout._ZN7default8LocationE addrspace(1)* %3, i64 0, i32 2, i32 1
  %11 = load i64, i64 addrspace(1)* %10, align 8
  %add2 = add i64 %11, %atom.6799E.0
  %arr.idx.get.gep = getelementptr inbounds %ArrayLayout.refArray, %ArrayLayout.refArray addrspace(1)* %9, i64 0, i32 1, i64 %add2
  %12 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arr.idx.get.gep, align 8
  %13 = getelementptr inbounds i8, i8 addrspace(1)* %12, i64 8
  %14 = bitcast i8 addrspace(1)* %13 to i64 addrspace(1)*
  %15 = load i64, i64 addrspace(1)* %14, align 8
  %icmpsge3 = icmp sgt i64 %15, -1
  br i1 %icmpsge3, label %land.rhs, label %if1491end

land.rhs:                                         ; preds = %if7304end
  %16 = getelementptr inbounds i8, i8 addrspace(1)* %12, i64 16
  %17 = bitcast i8 addrspace(1)* %16 to i64 addrspace(1)*
  %18 = load i64, i64 addrspace(1)* %17, align 8
  %icmpsge5 = icmp sgt i64 %18, -1
  br i1 %icmpsge5, label %land.rhs8, label %if1491end

land.rhs8:                                        ; preds = %land.rhs
  %19 = getelementptr inbounds i8, i8 addrspace(1)* %s, i64 40
  %20 = bitcast i8 addrspace(1)* %19 to i64 addrspace(1)*
  %21 = load i64, i64 addrspace(1)* %20, align 8
  %icmpslt9 = icmp slt i64 %15, %21
  br i1 %icmpslt9, label %land.rhs13, label %if1491end

land.rhs13:                                       ; preds = %land.rhs8
  %22 = getelementptr inbounds i8, i8 addrspace(1)* %s, i64 48
  %23 = bitcast i8 addrspace(1)* %22 to i64 addrspace(1)*
  %24 = load i64, i64 addrspace(1)* %23, align 8
  %icmpslt14 = icmp slt i64 %18, %24
  br i1 %icmpslt14, label %land.rhs18, label %if1491end

land.rhs18:                                       ; preds = %land.rhs13
  %25 = call i1 @_ZN7default6Planet17isPopulationAliveEC_ZN7default5PointE(i8 addrspace(1)* %s, i8 addrspace(1)* %12)
  br i1 %25, label %if1491then, label %if1491end

if1491then:                                       ; preds = %land.rhs18
  %26 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %atom.6801E.0, i64 1)
  %.fca.1.extract = extractvalue { i64, i1 } %26, 1
  br i1 %.fca.1.extract, label %overflow, label %normal

normal:                                           ; preds = %if1491then
  %.fca.0.extract = extractvalue { i64, i1 } %26, 0
  br label %if1491end

overflow:                                         ; preds = %if1491then
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet, i8* null, i64 3)
  %27 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %28 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %27)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %28)
  unreachable

if1491end:                                        ; preds = %land.rhs8, %if7304end, %land.rhs, %land.rhs18, %land.rhs13, %normal
  %atom.6801E.1 = phi i64 [ %.fca.0.extract, %normal ], [ %atom.6801E.0, %land.rhs18 ], [ %atom.6801E.0, %land.rhs13 ], [ %atom.6801E.0, %land.rhs8 ], [ %atom.6801E.0, %land.rhs ], [ %atom.6801E.0, %if7304end ]
  br label %block1451body

block1451end:                                     ; preds = %block1451body
  ret i64 %atom.6801E.0
}

define i1 @_ZN7default6Planet17isPopulationAliveEC_ZN7default5PointE(i8 addrspace(1)* %this, i8 addrspace(1)* %t) gc "cangjie" {
entry:
  %0 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 16
  %1 = getelementptr inbounds i8, i8 addrspace(1)* %t, i64 8
  %2 = bitcast i8 addrspace(1)* %1 to i64 addrspace(1)*
  %3 = load i64, i64 addrspace(1)* %2, align 8
  %icmpslt = icmp slt i64 %3, 0
  br i1 %icmpslt, label %if7387then, label %lor.rhs

lor.rhs:                                          ; preds = %entry
  %4 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 32
  %5 = bitcast i8 addrspace(1)* %4 to i64 addrspace(1)*
  %6 = load i64, i64 addrspace(1)* %5, align 8
  %icmpsge.not = icmp slt i64 %3, %6
  br i1 %icmpsge.not, label %if7387end, label %if7387then

if7387then:                                       ; preds = %entry, %lor.rhs
  %7 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Except.ti to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %7)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %7)
  unreachable

if7387end:                                        ; preds = %lor.rhs
  %8 = bitcast i8 addrspace(1)* %0 to %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* addrspace(1)*
  %9 = load %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)*, %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* addrspace(1)* %8, align 8
  %10 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 24
  %11 = bitcast i8 addrspace(1)* %10 to i64 addrspace(1)*
  %12 = load i64, i64 addrspace(1)* %11, align 8
  %add = add i64 %12, %3
  %arr.get.sroa.4.0..sroa_idx5 = getelementptr inbounds %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE", %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* %9, i64 0, i32 1, i64 %add, i32 2
  %arr.get.sroa.4.0.copyload = load i64, i64 addrspace(1)* %arr.get.sroa.4.0..sroa_idx5, align 8
  %13 = getelementptr inbounds i8, i8 addrspace(1)* %t, i64 16
  %14 = bitcast i8 addrspace(1)* %13 to i64 addrspace(1)*
  %15 = load i64, i64 addrspace(1)* %14, align 8
  %icmpslt2 = icmp slt i64 %15, 0
  %icmpsge5 = icmp sge i64 %15, %arr.get.sroa.4.0.copyload
  %conv7 = or i1 %icmpslt2, %icmpsge5
  br i1 %conv7, label %if7432then, label %if7432end

if7432then:                                       ; preds = %if7387end
  %16 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Except.ti to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %16)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %16)
  unreachable

if7432end:                                        ; preds = %if7387end
  %arr.idx.get.gep = getelementptr inbounds %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE", %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* %9, i64 0, i32 1, i64 %add
  %arr.get.sroa.3.0..sroa_idx4 = getelementptr inbounds %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE", %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* %9, i64 0, i32 1, i64 %add, i32 1
  %arr.get.sroa.3.0.copyload = load i64, i64 addrspace(1)* %arr.get.sroa.3.0..sroa_idx4, align 8
  %17 = bitcast %"record._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* %arr.idx.get.gep to %ArrayLayout.refArray addrspace(1)* addrspace(1)*
  %arr.get.sroa.0.0.copyload10 = load %ArrayLayout.refArray addrspace(1)*, %ArrayLayout.refArray addrspace(1)* addrspace(1)* %17, align 8
  %add9 = add i64 %arr.get.sroa.3.0.copyload, %15
  %arr.idx.get.gep10 = getelementptr inbounds %ArrayLayout.refArray, %ArrayLayout.refArray addrspace(1)* %arr.get.sroa.0.0.copyload10, i64 0, i32 1, i64 %add9
  %18 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arr.idx.get.gep10, align 8
  %.not = icmp eq i8 addrspace(1)* %18, null
  %19 = xor i1 %.not, true
  ret i1 %19
}

define internal fastcc void @_ZN7default8Location4initEC_ZN7default5PointE(i8 addrspace(1)* %this, i8 addrspace(1)* %curr) unnamed_addr gc "cangjie" {
entry:
  %callRet68 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet62 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet56 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet49 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet43 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet36 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet29 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet23 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet17 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet11 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet5 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet = alloca %"record._ZN11std$FS$core6StringE", align 8
  %0 = alloca %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE", align 8
  %atom.6874E = alloca %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE", align 8
  %1 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet68 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %1, i8 0, i64 16, i1 false)
  %2 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet62 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %2, i8 0, i64 16, i1 false)
  %3 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet56 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %3, i8 0, i64 16, i1 false)
  %4 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet49 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %4, i8 0, i64 16, i1 false)
  %5 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet43 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %5, i8 0, i64 16, i1 false)
  %6 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet36 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %6, i8 0, i64 16, i1 false)
  %7 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet29 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %7, i8 0, i64 16, i1 false)
  %8 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet23 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %8, i8 0, i64 16, i1 false)
  %9 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet17 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %9, i8 0, i64 16, i1 false)
  %10 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet11 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %10, i8 0, i64 16, i1 false)
  %11 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet5 to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %11, i8 0, i64 16, i1 false)
  %12 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %12, i8 0, i64 16, i1 false)
  %.0.sroa_cast = bitcast %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE"* %0 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 dereferenceable(24) %.0.sroa_cast, i8 0, i64 24, i1 false)
  %13 = bitcast %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE"* %atom.6874E to i8*
  call void @llvm.cj.memset(i8* nonnull align 8 %13, i8 0, i64 24, i1 false)
  %14 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 8
  %15 = bitcast i8 addrspace(1)* %14 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %curr, i8 addrspace(1)* %this, i8 addrspace(1)* addrspace(1)* %15)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 dereferenceable(24) %13, i8* nonnull align 8 dereferenceable(24) %.0.sroa_cast, i64 24, i1 false)
  %16 = call i8 addrspace(1)* @CJ_MCC_NewObjArray(i64 8, i8* bitcast (%TypeInfo* @"RawArray<Point>.ti" to i8*))
  %17 = getelementptr inbounds i8, i8 addrspace(1)* %curr, i64 8
  %18 = bitcast i8 addrspace(1)* %17 to i64 addrspace(1)*
  %19 = load i64, i64 addrspace(1)* %18, align 8
  %20 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %19, i64 -1)
  %.fca.0.extract = extractvalue { i64, i1 } %20, 0
  %.fca.1.extract = extractvalue { i64, i1 } %20, 1
  br i1 %.fca.1.extract, label %overflow0E, label %normal0E

normal0E:                                         ; preds = %entry
  %21 = getelementptr inbounds i8, i8 addrspace(1)* %curr, i64 16
  %22 = bitcast i8 addrspace(1)* %21 to i64 addrspace(1)*
  %23 = load i64, i64 addrspace(1)* %22, align 8
  %24 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %23, i64 -1)
  %.fca.1.extract2 = extractvalue { i64, i1 } %24, 1
  br i1 %.fca.1.extract2, label %overflow0E3, label %normal0E4

overflow0E:                                       ; preds = %entry
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet, i8* null, i64 3)
  %25 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %26 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %25)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %26)
  unreachable

normal0E4:                                        ; preds = %normal0E
  %.fca.0.extract1 = extractvalue { i64, i1 } %24, 0
  %27 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Point.ti to i8*), i32 24)
  %28 = getelementptr inbounds i8, i8 addrspace(1)* %27, i64 8
  %29 = bitcast i8 addrspace(1)* %28 to i64 addrspace(1)*
  store i64 %.fca.0.extract, i64 addrspace(1)* %29, align 8
  %30 = getelementptr inbounds i8, i8 addrspace(1)* %27, i64 16
  %31 = bitcast i8 addrspace(1)* %30 to i64 addrspace(1)*
  store i64 %.fca.0.extract1, i64 addrspace(1)* %31, align 8
  %arr336.idx0E = getelementptr inbounds i8, i8 addrspace(1)* %16, i64 16
  %32 = bitcast i8 addrspace(1)* %arr336.idx0E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %27, i8 addrspace(1)* %16, i8 addrspace(1)* addrspace(1)* %32)
  %33 = load i64, i64 addrspace(1)* %22, align 8
  %34 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %33, i64 -1)
  %.fca.1.extract6 = extractvalue { i64, i1 } %34, 1
  br i1 %.fca.1.extract6, label %overflow0E9, label %normal0E10

overflow0E3:                                      ; preds = %normal0E
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet5, i8* null, i64 3)
  %35 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet5 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %36 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %35)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %36)
  unreachable

normal0E10:                                       ; preds = %normal0E4
  %.fca.0.extract5 = extractvalue { i64, i1 } %34, 0
  %37 = load i64, i64 addrspace(1)* %18, align 8
  %38 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Point.ti to i8*), i32 24)
  %39 = getelementptr inbounds i8, i8 addrspace(1)* %38, i64 8
  %40 = bitcast i8 addrspace(1)* %39 to i64 addrspace(1)*
  store i64 %37, i64 addrspace(1)* %40, align 8
  %41 = getelementptr inbounds i8, i8 addrspace(1)* %38, i64 16
  %42 = bitcast i8 addrspace(1)* %41 to i64 addrspace(1)*
  store i64 %.fca.0.extract5, i64 addrspace(1)* %42, align 8
  %arr336.idx1E = getelementptr inbounds i8, i8 addrspace(1)* %16, i64 24
  %43 = bitcast i8 addrspace(1)* %arr336.idx1E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %38, i8 addrspace(1)* %16, i8 addrspace(1)* addrspace(1)* %43)
  %44 = load i64, i64 addrspace(1)* %18, align 8
  %45 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %44, i64 1)
  %.fca.0.extract9 = extractvalue { i64, i1 } %45, 0
  %.fca.1.extract10 = extractvalue { i64, i1 } %45, 1
  br i1 %.fca.1.extract10, label %overflow0E15, label %normal0E16

overflow0E9:                                      ; preds = %normal0E4
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet11, i8* null, i64 3)
  %46 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet11 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %47 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %46)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %47)
  unreachable

normal0E16:                                       ; preds = %normal0E10
  %48 = load i64, i64 addrspace(1)* %22, align 8
  %49 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %48, i64 -1)
  %.fca.1.extract12 = extractvalue { i64, i1 } %49, 1
  br i1 %.fca.1.extract12, label %overflow0E21, label %normal0E22

overflow0E15:                                     ; preds = %normal0E10
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet17, i8* null, i64 3)
  %50 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet17 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %51 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %50)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %51)
  unreachable

normal0E22:                                       ; preds = %normal0E16
  %.fca.0.extract11 = extractvalue { i64, i1 } %49, 0
  %52 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Point.ti to i8*), i32 24)
  %53 = getelementptr inbounds i8, i8 addrspace(1)* %52, i64 8
  %54 = bitcast i8 addrspace(1)* %53 to i64 addrspace(1)*
  store i64 %.fca.0.extract9, i64 addrspace(1)* %54, align 8
  %55 = getelementptr inbounds i8, i8 addrspace(1)* %52, i64 16
  %56 = bitcast i8 addrspace(1)* %55 to i64 addrspace(1)*
  store i64 %.fca.0.extract11, i64 addrspace(1)* %56, align 8
  %arr336.idx2E = getelementptr inbounds i8, i8 addrspace(1)* %16, i64 32
  %57 = bitcast i8 addrspace(1)* %arr336.idx2E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %52, i8 addrspace(1)* %16, i8 addrspace(1)* addrspace(1)* %57)
  %58 = load i64, i64 addrspace(1)* %18, align 8
  %59 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %58, i64 -1)
  %.fca.1.extract16 = extractvalue { i64, i1 } %59, 1
  br i1 %.fca.1.extract16, label %overflow0E27, label %normal0E28

overflow0E21:                                     ; preds = %normal0E16
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet23, i8* null, i64 3)
  %60 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet23 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %61 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %60)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %61)
  unreachable

normal0E28:                                       ; preds = %normal0E22
  %.fca.0.extract15 = extractvalue { i64, i1 } %59, 0
  %62 = load i64, i64 addrspace(1)* %22, align 8
  %63 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Point.ti to i8*), i32 24)
  %64 = getelementptr inbounds i8, i8 addrspace(1)* %63, i64 8
  %65 = bitcast i8 addrspace(1)* %64 to i64 addrspace(1)*
  store i64 %.fca.0.extract15, i64 addrspace(1)* %65, align 8
  %66 = getelementptr inbounds i8, i8 addrspace(1)* %63, i64 16
  %67 = bitcast i8 addrspace(1)* %66 to i64 addrspace(1)*
  store i64 %62, i64 addrspace(1)* %67, align 8
  %arr336.idx3E = getelementptr inbounds i8, i8 addrspace(1)* %16, i64 40
  %68 = bitcast i8 addrspace(1)* %arr336.idx3E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %63, i8 addrspace(1)* %16, i8 addrspace(1)* addrspace(1)* %68)
  %69 = load i64, i64 addrspace(1)* %18, align 8
  %70 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %69, i64 1)
  %.fca.1.extract20 = extractvalue { i64, i1 } %70, 1
  br i1 %.fca.1.extract20, label %overflow0E34, label %normal0E35

overflow0E27:                                     ; preds = %normal0E22
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet29, i8* null, i64 3)
  %71 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet29 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %72 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %71)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %72)
  unreachable

normal0E35:                                       ; preds = %normal0E28
  %.fca.0.extract19 = extractvalue { i64, i1 } %70, 0
  %73 = load i64, i64 addrspace(1)* %22, align 8
  %74 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Point.ti to i8*), i32 24)
  %75 = getelementptr inbounds i8, i8 addrspace(1)* %74, i64 8
  %76 = bitcast i8 addrspace(1)* %75 to i64 addrspace(1)*
  store i64 %.fca.0.extract19, i64 addrspace(1)* %76, align 8
  %77 = getelementptr inbounds i8, i8 addrspace(1)* %74, i64 16
  %78 = bitcast i8 addrspace(1)* %77 to i64 addrspace(1)*
  store i64 %73, i64 addrspace(1)* %78, align 8
  %arr336.idx4E = getelementptr inbounds i8, i8 addrspace(1)* %16, i64 48
  %79 = bitcast i8 addrspace(1)* %arr336.idx4E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %74, i8 addrspace(1)* %16, i8 addrspace(1)* addrspace(1)* %79)
  %80 = load i64, i64 addrspace(1)* %18, align 8
  %81 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %80, i64 -1)
  %.fca.0.extract23 = extractvalue { i64, i1 } %81, 0
  %.fca.1.extract24 = extractvalue { i64, i1 } %81, 1
  br i1 %.fca.1.extract24, label %overflow0E41, label %normal0E42

overflow0E34:                                     ; preds = %normal0E28
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet36, i8* null, i64 3)
  %82 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet36 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %83 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %82)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %83)
  unreachable

normal0E42:                                       ; preds = %normal0E35
  %84 = load i64, i64 addrspace(1)* %22, align 8
  %85 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %84, i64 1)
  %.fca.1.extract26 = extractvalue { i64, i1 } %85, 1
  br i1 %.fca.1.extract26, label %overflow0E47, label %normal0E48

overflow0E41:                                     ; preds = %normal0E35
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet43, i8* null, i64 3)
  %86 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet43 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %87 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %86)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %87)
  unreachable

normal0E48:                                       ; preds = %normal0E42
  %.fca.0.extract25 = extractvalue { i64, i1 } %85, 0
  %88 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Point.ti to i8*), i32 24)
  %89 = getelementptr inbounds i8, i8 addrspace(1)* %88, i64 8
  %90 = bitcast i8 addrspace(1)* %89 to i64 addrspace(1)*
  store i64 %.fca.0.extract23, i64 addrspace(1)* %90, align 8
  %91 = getelementptr inbounds i8, i8 addrspace(1)* %88, i64 16
  %92 = bitcast i8 addrspace(1)* %91 to i64 addrspace(1)*
  store i64 %.fca.0.extract25, i64 addrspace(1)* %92, align 8
  %arr336.idx5E = getelementptr inbounds i8, i8 addrspace(1)* %16, i64 56
  %93 = bitcast i8 addrspace(1)* %arr336.idx5E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %88, i8 addrspace(1)* %16, i8 addrspace(1)* addrspace(1)* %93)
  %94 = load i64, i64 addrspace(1)* %22, align 8
  %95 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %94, i64 1)
  %.fca.1.extract30 = extractvalue { i64, i1 } %95, 1
  br i1 %.fca.1.extract30, label %overflow0E54, label %normal0E55

overflow0E47:                                     ; preds = %normal0E42
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet49, i8* null, i64 3)
  %96 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet49 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %97 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %96)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %97)
  unreachable

normal0E55:                                       ; preds = %normal0E48
  %.fca.0.extract29 = extractvalue { i64, i1 } %95, 0
  %98 = load i64, i64 addrspace(1)* %18, align 8
  %99 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Point.ti to i8*), i32 24)
  %100 = getelementptr inbounds i8, i8 addrspace(1)* %99, i64 8
  %101 = bitcast i8 addrspace(1)* %100 to i64 addrspace(1)*
  store i64 %98, i64 addrspace(1)* %101, align 8
  %102 = getelementptr inbounds i8, i8 addrspace(1)* %99, i64 16
  %103 = bitcast i8 addrspace(1)* %102 to i64 addrspace(1)*
  store i64 %.fca.0.extract29, i64 addrspace(1)* %103, align 8
  %arr336.idx6E = getelementptr inbounds i8, i8 addrspace(1)* %16, i64 64
  %104 = bitcast i8 addrspace(1)* %arr336.idx6E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %99, i8 addrspace(1)* %16, i8 addrspace(1)* addrspace(1)* %104)
  %105 = load i64, i64 addrspace(1)* %18, align 8
  %106 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %105, i64 1)
  %.fca.1.extract34 = extractvalue { i64, i1 } %106, 1
  br i1 %.fca.1.extract34, label %overflow0E60, label %normal0E61

overflow0E54:                                     ; preds = %normal0E48
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet56, i8* null, i64 3)
  %107 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet56 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %108 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %107)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %108)
  unreachable

normal0E61:                                       ; preds = %normal0E55
  %109 = load i64, i64 addrspace(1)* %22, align 8
  %110 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %109, i64 1)
  %.fca.1.extract36 = extractvalue { i64, i1 } %110, 1
  br i1 %.fca.1.extract36, label %overflow0E66, label %normal0E67

overflow0E60:                                     ; preds = %normal0E55
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet62, i8* null, i64 3)
  %111 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet62 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %112 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %111)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %112)
  unreachable

normal0E67:                                       ; preds = %normal0E61
  %.fca.0.extract35 = extractvalue { i64, i1 } %110, 0
  %.fca.0.extract33 = extractvalue { i64, i1 } %106, 0
  %113 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Point.ti to i8*), i32 24)
  %114 = getelementptr inbounds i8, i8 addrspace(1)* %113, i64 8
  %115 = bitcast i8 addrspace(1)* %114 to i64 addrspace(1)*
  store i64 %.fca.0.extract33, i64 addrspace(1)* %115, align 8
  %116 = getelementptr inbounds i8, i8 addrspace(1)* %113, i64 16
  %117 = bitcast i8 addrspace(1)* %116 to i64 addrspace(1)*
  store i64 %.fca.0.extract35, i64 addrspace(1)* %117, align 8
  %arr336.idx7E = getelementptr inbounds i8, i8 addrspace(1)* %16, i64 72
  %118 = bitcast i8 addrspace(1)* %arr336.idx7E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %113, i8 addrspace(1)* %16, i8 addrspace(1)* addrspace(1)* %118)
  %119 = getelementptr inbounds %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE", %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE"* %atom.6874E, i64 0, i32 0
  store i8 addrspace(1)* %16, i8 addrspace(1)** %119, align 8
  %120 = getelementptr inbounds %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE", %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE"* %atom.6874E, i64 0, i32 1
  store i64 0, i64* %120, align 8
  %121 = getelementptr inbounds %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE", %"record._ZN7default11std$FS$core5ArrayIC_ZN7default5PointEE"* %atom.6874E, i64 0, i32 2
  store i64 8, i64* %121, align 8
  %122 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 16
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %this, i8 addrspace(1)* %122, i8* nonnull %13, i64 24)
  ret void

overflow0E66:                                     ; preds = %normal0E61
  call void @"_ZN11std$FS$core6String23createStringFromLiteral"(%"record._ZN11std$FS$core6StringE"* sret(%"record._ZN11std$FS$core6StringE") %callRet68, i8* null, i64 3)
  %123 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet68 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %124 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %123)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %124)
  unreachable
}

define internal void @_ZN7default6Planet11occupyPlaceEC_ZN7default5PointEC_ZN7default5HumanE(%Unit.Type* sret(%Unit.Type) %0, i8 addrspace(1)* %this, i8 addrspace(1)* %t, i8 addrspace(1)* %h) gc "cangjie" {
entry:
  %1 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 16
  %2 = getelementptr inbounds i8, i8 addrspace(1)* %t, i64 8
  %3 = bitcast i8 addrspace(1)* %2 to i64 addrspace(1)*
  %4 = load i64, i64 addrspace(1)* %3, align 8
  %icmpslt = icmp slt i64 %4, 0
  br i1 %icmpslt, label %if.then7937E, label %lor.rhs7936E

lor.rhs7936E:                                     ; preds = %entry
  %5 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 32
  %6 = bitcast i8 addrspace(1)* %5 to i64 addrspace(1)*
  %7 = load i64, i64 addrspace(1)* %6, align 8
  %icmpsge.not = icmp slt i64 %4, %7
  br i1 %icmpsge.not, label %if.end7937E, label %if.then7937E

if.then7937E:                                     ; preds = %entry, %lor.rhs7936E
  %8 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Except.ti to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %8)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %8)
  unreachable

if.end7937E:                                      ; preds = %lor.rhs7936E
  %9 = bitcast i8 addrspace(1)* %1 to %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* addrspace(1)*
  %10 = load %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)*, %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* addrspace(1)* %9, align 8
  %11 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 24
  %12 = bitcast i8 addrspace(1)* %11 to i64 addrspace(1)*
  %13 = load i64, i64 addrspace(1)* %12, align 8
  %add = add i64 %13, %4
  %arr.get.sroa.0.0..sroa_idx = getelementptr inbounds %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE", %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* %10, i64 0, i32 1, i64 %add, i32 0
  %arr.get.sroa.0.0.copyload = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arr.get.sroa.0.0..sroa_idx, align 8
  %arr.get.sroa.4.0..sroa_idx5 = getelementptr inbounds %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE", %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* %10, i64 0, i32 1, i64 %add, i32 2
  %arr.get.sroa.4.0.copyload = load i64, i64 addrspace(1)* %arr.get.sroa.4.0..sroa_idx5, align 8
  %14 = getelementptr inbounds i8, i8 addrspace(1)* %t, i64 16
  %15 = bitcast i8 addrspace(1)* %14 to i64 addrspace(1)*
  %16 = load i64, i64 addrspace(1)* %15, align 8
  %icmpslt2 = icmp slt i64 %16, 0
  %icmpsge3 = icmp sge i64 %16, %arr.get.sroa.4.0.copyload
  %conv4 = or i1 %icmpslt2, %icmpsge3
  br i1 %conv4, label %if.then7983E, label %if.end7983E

if.then7983E:                                     ; preds = %if.end7937E
  %17 = call i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Except.ti to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %17)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %17)
  unreachable

if.end7983E:                                      ; preds = %if.end7937E
  %arr.get.sroa.3.0..sroa_idx4 = getelementptr inbounds %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE", %"ArrayLayout._ZN7default11std$FS$core5ArrayIN_ZN11std$FS$core6OptionIC_ZN7default5HumanEEE" addrspace(1)* %10, i64 0, i32 1, i64 %add, i32 1
  %arr.get.sroa.3.0.copyload = load i64, i64 addrspace(1)* %arr.get.sroa.3.0..sroa_idx4, align 8
  %add5 = add i64 %arr.get.sroa.3.0.copyload, %16
  %18 = bitcast i8 addrspace(1)* %arr.get.sroa.0.0.copyload to %ArrayLayout.refArray addrspace(1)*
  %arr.idx.set.gep = getelementptr inbounds %ArrayLayout.refArray, %ArrayLayout.refArray addrspace(1)* %18, i64 0, i32 1, i64 %add5
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %h, i8 addrspace(1)* %arr.get.sroa.0.0.copyload, i8 addrspace(1)* addrspace(1)* %arr.idx.set.gep)
  ret void
}

!0 = !{!"ArrayLayout.refArray"}
!1 = !{!"ObjLayout.people"}
!2 = !{!"ObjLayout.Location"}
!3 = !{!"ObjLayout.Point"}
!4 = !{!"ObjLayout.Except"}
!5 = !{!"ObjLayout.Human"}

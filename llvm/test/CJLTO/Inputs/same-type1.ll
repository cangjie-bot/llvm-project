%KlassInfo.0 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i64*, i32, [0 x i8*] }
%BitMap = type { i32, [0 x i8] }
%KlassInfo.1 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i64*, i32, [1 x i8*] }
%"record._ZN13std$FS$random11std$FS$core5ArrayIhE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN13std$FS$random11std$FS$core5ArrayImE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN11std$FS$core6StringE" = type { i8 addrspace(1)*, i64 }
%"record._ZN13std$FS$random11std$FS$core6OptionIdE" = type { i1, double }
%ArrayLayout.UInt64 = type { %ArrayBase, [0 x i64] }
%ArrayBase = type { %ObjLayout.Object, i64 }
%ObjLayout.Object = type { %KlassInfo.0* }
%ArrayLayout.UInt8 = type { %ArrayBase, [0 x i8] }

@"$const_string.15" = private unnamed_addr constant [4 x i8] c"add\00", align 1
@"$const_string.16" = private unnamed_addr constant [4 x i8] c"sub\00", align 1
@"$const_string.22" = private unnamed_addr constant [9 x i8] c"typecast\00", align 1
@UInt64.arrayKlass = weak_odr global %KlassInfo.0 { i32 2, i32 8, %BitMap* null, i8* bitcast (%KlassInfo.0* @array_uint64.primKlass to i8*), i8** null, i64* null, i64* null, i64* bitcast ([6 x i8]* @A1_mE.className to i64*), i32 0, [0 x i8*] zeroinitializer }
@A1_mE.className = weak_odr global [6 x i8] c"A1_mE\00", align 1
@array_uint64.primKlass = weak_odr global %KlassInfo.0 { i32 1, i32 8, %BitMap* null, i8* null, i8** null, i64* null, i64* null, i64* @array_uint64.uniqueAddr, i32 0, [0 x i8*] zeroinitializer }
@array_uint64.uniqueAddr = weak_odr global i64 0
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" = external global %KlassInfo.0

declare i8* @CJ_MCC_GetObjClass(i8 addrspace(1)*)
declare i8 addrspace(1)* @CJ_MCC_NewArray64Stub(i64, i8*)
declare i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8*, i32)
declare void @CJ_MCC_ThrowException(i8 addrspace(1)*)
declare void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)*) local_unnamed_addr gc "cangjie"
declare void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias sret(%"record._ZN11std$FS$core6StringE"), i8*, i64) local_unnamed_addr gc "cangjie"
declare void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)*, i8 addrspace(1)* noalias nocapture writeonly, i8* noalias nocapture readonly, i64)
declare void @llvm.cj.gcwrite.i64.i64(i64, i8 addrspace(1)* nocapture, i64 addrspace(1)* nocapture)
declare void @llvm.cj.gcwrite.i8.i8(i8, i8 addrspace(1)* nocapture, i8 addrspace(1)* nocapture)
declare void @llvm.cj.memset.p0i8(i8*, i8, i64, i1)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare void @llvm.memcpy.p0i8.p1i8.i64(i8* noalias nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64, i1 immarg)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64)
declare { i64, i1 } @llvm.uadd.with.overflow.i64(i64, i64)
declare i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*) local_unnamed_addr gc "cangjie"

define void @goo1(i8 addrspace(1)* %this, i64 %seed) gc "cangjie" {
entry:
  %enumTmp50 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet49 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp40 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet39 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp34 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet33 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp29 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet28 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp23 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet22 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp19 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet18 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp13 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet12 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp5 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet4 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp3 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet2 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp = alloca %"record._ZN11std$FS$core6StringE"
  %callRet = alloca %"record._ZN11std$FS$core6StringE"
  %0 = alloca %"record._ZN13std$FS$random11std$FS$core5ArrayImE"
  %atom.5655E = alloca %"record._ZN13std$FS$random11std$FS$core5ArrayImE"
  %enum.val = alloca %"record._ZN13std$FS$random11std$FS$core6OptionIdE"
  %enumTmp50.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp50 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp50.0.sroa_cast, i8 0, i64 16, i1 false)
  %1 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet49 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %1, i8 0, i64 16, i1 false)
  %enumTmp40.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp40 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp40.0.sroa_cast, i8 0, i64 16, i1 false)
  %2 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet39 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %2, i8 0, i64 16, i1 false)
  %enumTmp34.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp34 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp34.0.sroa_cast, i8 0, i64 16, i1 false)
  %callRet33.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %callRet33 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %callRet33.0.sroa_cast, i8 0, i64 16, i1 false)
  %enumTmp29.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp29 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp29.0.sroa_cast, i8 0, i64 16, i1 false)
  %3 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet28 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %3, i8 0, i64 16, i1 false)
  %enumTmp23.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp23 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp23.0.sroa_cast, i8 0, i64 16, i1 false)
  %callRet22.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %callRet22 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %callRet22.0.sroa_cast, i8 0, i64 16, i1 false)
  %enumTmp19.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp19 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp19.0.sroa_cast, i8 0, i64 16, i1 false)
  %callRet18.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %callRet18 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %callRet18.0.sroa_cast, i8 0, i64 16, i1 false)
  %enumTmp13.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp13 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp13.0.sroa_cast, i8 0, i64 16, i1 false)
  %callRet12.0.sroa_cast37 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet12 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %callRet12.0.sroa_cast37, i8 0, i64 16, i1 false)
  %enumTmp5.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp5 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp5.0.sroa_cast, i8 0, i64 16, i1 false)
  %4 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet4 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %4, i8 0, i64 16, i1 false)
  %enumTmp3.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp3 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp3.0.sroa_cast, i8 0, i64 16, i1 false)
  %callRet2.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %callRet2 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %callRet2.0.sroa_cast, i8 0, i64 16, i1 false)
  %enumTmp.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp.0.sroa_cast, i8 0, i64 16, i1 false)
  %callRet.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %callRet to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %callRet.0.sroa_cast, i8 0, i64 16, i1 false)
  %.0.sroa_cast = bitcast %"record._ZN13std$FS$random11std$FS$core5ArrayImE"* %0 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %.0.sroa_cast, i8 0, i64 24, i1 false)
  %5 = bitcast %"record._ZN13std$FS$random11std$FS$core5ArrayImE"* %atom.5655E to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %5, i8 0, i64 24, i1 false)
  %6 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 56
  %7 = bitcast i8 addrspace(1)* %6 to i64 addrspace(1)*
  call void @llvm.cj.gcwrite.i64.i64(i64 %seed, i8 addrspace(1)* %this, i64 addrspace(1)* %7)
  %8 = getelementptr inbounds %"record._ZN13std$FS$random11std$FS$core6OptionIdE", %"record._ZN13std$FS$random11std$FS$core6OptionIdE"* %enum.val, i64 0, i32 0
  store i1 true, i1* %8
  %9 = getelementptr inbounds %"record._ZN13std$FS$random11std$FS$core6OptionIdE", %"record._ZN13std$FS$random11std$FS$core6OptionIdE"* %enum.val, i64 0, i32 1
  store double 0.000000e+00, double* %9
  %10 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 40
  %11 = bitcast %"record._ZN13std$FS$random11std$FS$core6OptionIdE"* %enum.val to i8*
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %this, i8 addrspace(1)* %10, i8* nonnull %11, i64 16)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %5, i8* noundef nonnull align 8 dereferenceable(24) %.0.sroa_cast, i64 24, i1 false)
  %12 = getelementptr inbounds %"record._ZN13std$FS$random11std$FS$core5ArrayImE", %"record._ZN13std$FS$random11std$FS$core5ArrayImE"* %atom.5655E, i64 0, i32 1
  store i64 0, i64* %12
  %13 = call noalias i8 addrspace(1)* @CJ_MCC_NewArray64Stub(i64 312, i8* bitcast (%KlassInfo.0* @UInt64.arrayKlass to i8*))
  %14 = getelementptr inbounds %"record._ZN13std$FS$random11std$FS$core5ArrayImE", %"record._ZN13std$FS$random11std$FS$core5ArrayImE"* %atom.5655E, i64 0, i32 0
  store i8 addrspace(1)* %13, i8 addrspace(1)** %14
  %15 = getelementptr inbounds %"record._ZN13std$FS$random11std$FS$core5ArrayImE", %"record._ZN13std$FS$random11std$FS$core5ArrayImE"* %atom.5655E, i64 0, i32 2
  store i64 312, i64* %15
  %16 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 8
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %this, i8 addrspace(1)* %16, i8* nonnull %5, i64 24)
  %17 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 24
  %18 = bitcast i8 addrspace(1)* %17 to i64 addrspace(1)*
  %19 = load i64, i64 addrspace(1)* %18
  %icmpuge = icmp eq i64 %19, 0
  br i1 %icmpuge, label %if.then7294E, label %if.else7294E

if.then7294E:                                     ; preds = %entry
  %20 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %20)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %20)
  unreachable

if.else7294E:                                     ; preds = %entry
  %21 = load i64, i64 addrspace(1)* %7
  %22 = bitcast i8 addrspace(1)* %16 to i8 addrspace(1)* addrspace(1)*
  %23 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %22
  %24 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 16
  %25 = bitcast i8 addrspace(1)* %24 to i64 addrspace(1)*
  %26 = load i64, i64 addrspace(1)* %25
  %27 = bitcast i8 addrspace(1)* %23 to %ArrayLayout.UInt64 addrspace(1)*
  %arr.idx.set.gep = getelementptr inbounds %ArrayLayout.UInt64, %ArrayLayout.UInt64 addrspace(1)* %27, i64 0, i32 1, i64 %26
  call void @llvm.cj.gcwrite.i64.i64(i64 %21, i8 addrspace(1)* %23, i64 addrspace(1)* %arr.idx.set.gep)
  %28 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 32
  %29 = bitcast i8 addrspace(1)* %28 to i64 addrspace(1)*
  call void @llvm.cj.gcwrite.i64.i64(i64 1, i8 addrspace(1)* %this, i64 addrspace(1)* %29)
  %30 = load i64, i64 addrspace(1)* %29
  %icmpslt35 = icmp slt i64 %30, 312
  br i1 %icmpslt35, label %while.body4736E, label %block.end4688E

while.body4736E:                                  ; preds = %if.else7294E, %normal0E48
  %31 = phi i64 [ %49, %normal0E48 ], [ %30, %if.else7294E ]
  %32 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %31, i64 -1)
  %.fca.0.extract = extractvalue { i64, i1 } %32, 0
  %.fca.1.extract = extractvalue { i64, i1 } %32, 1
  br i1 %.fca.1.extract, label %overflow0E, label %normal0E, !prof !1

normal0E:                                         ; preds = %while.body4736E
  %33 = load i64, i64 addrspace(1)* %18
  %icmpuge7.not = icmp ult i64 %.fca.0.extract, %33
  br i1 %icmpuge7.not, label %if.else7328E, label %if.then7328E

overflow0E:                                       ; preds = %while.body4736E
  call void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.16", i64 0, i64 0), i64 3)
  %34 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet4 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %35 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %34)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %35)
  unreachable

if.then7328E:                                     ; preds = %normal0E
  %36 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %36)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %36)
  unreachable

if.else7328E:                                     ; preds = %normal0E
  %37 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %22
  %38 = load i64, i64 addrspace(1)* %25
  %39 = bitcast i8 addrspace(1)* %37 to %ArrayLayout.UInt64 addrspace(1)*
  %i2ui.lt = icmp slt i64 %31, 0
  br i1 %i2ui.lt, label %if.ovf.lt0E27, label %else.ovf.gt0E31

if.ovf.lt0E27:                                    ; preds = %if.else7328E
  call void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet28, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @"$const_string.22", i64 0, i64 0), i64 8)
  %40 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet28 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %41 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %40)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %41)
  unreachable

else.ovf.gt0E31:                                  ; preds = %if.else7328E
  %add = add i64 %38, %.fca.0.extract
  %arr.idx.get.gep = getelementptr inbounds %ArrayLayout.UInt64, %ArrayLayout.UInt64 addrspace(1)* %39, i64 0, i32 1, i64 %add
  %42 = load i64, i64 addrspace(1)* %arr.idx.get.gep
  %lshr = lshr i64 %42, 62
  %xor = xor i64 %lshr, %42
  %mul = mul i64 %xor, 6364136223846793005
  %43 = call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %mul, i64 %31)
  %.fca.0.extract11 = extractvalue { i64, i1 } %43, 0
  %.fca.1.extract12 = extractvalue { i64, i1 } %43, 1
  br i1 %.fca.1.extract12, label %overflow0E37, label %normal0E38, !prof !1

normal0E38:                                       ; preds = %else.ovf.gt0E31
  %icmpuge42.not = icmp ult i64 %31, %33
  br i1 %icmpuge42.not, label %if.else7402E, label %if.then7402E

overflow0E37:                                     ; preds = %else.ovf.gt0E31
  call void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet39, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.15", i64 0, i64 0), i64 3)
  %44 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet39 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %45 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %44)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %45)
  unreachable

if.then7402E:                                     ; preds = %normal0E38
  %46 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %46)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %46)
  unreachable

if.else7402E:                                     ; preds = %normal0E38
  %add43 = add i64 %38, %31
  %arr.idx.set.gep44 = getelementptr inbounds %ArrayLayout.UInt64, %ArrayLayout.UInt64 addrspace(1)* %39, i64 0, i32 1, i64 %add43
  call void @llvm.cj.gcwrite.i64.i64(i64 %.fca.0.extract11, i8 addrspace(1)* %37, i64 addrspace(1)* %arr.idx.set.gep44)
  %47 = load i64, i64 addrspace(1)* %29
  %48 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %47, i64 1)
  %.fca.1.extract16 = extractvalue { i64, i1 } %48, 1
  br i1 %.fca.1.extract16, label %overflow0E47, label %normal0E48, !prof !1

normal0E48:                                       ; preds = %if.else7402E
  %.fca.0.extract15 = extractvalue { i64, i1 } %48, 0
  call void @llvm.cj.gcwrite.i64.i64(i64 %.fca.0.extract15, i8 addrspace(1)* %this, i64 addrspace(1)* %29)
  %49 = load i64, i64 addrspace(1)* %29
  %icmpslt = icmp slt i64 %49, 312
  br i1 %icmpslt, label %while.body4736E, label %block.end4688E

overflow0E47:                                     ; preds = %if.else7402E
  call void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet49, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.15", i64 0, i64 0), i64 3)
  %50 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet49 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %51 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %50)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %51)
  unreachable

block.end4688E:                                   ; preds = %normal0E48, %if.else7294E
  ret void
}

define void @goo2(%"record._ZN13std$FS$random11std$FS$core5ArrayIhE"* noalias nocapture writeonly sret(%"record._ZN13std$FS$random11std$FS$core5ArrayIhE") %0, i8 addrspace(1)* %this, i8 addrspace(1)* nocapture readnone %"array$BP", %"record._ZN13std$FS$random11std$FS$core5ArrayIhE" addrspace(1)* nocapture readonly %array) gc "cangjie" {
entry:
  %enumTmp = alloca %"record._ZN11std$FS$core6StringE"
  %callRet = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp.0.sroa_cast, i8 0, i64 16, i1 false)
  %callRet.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %callRet to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %callRet.0.sroa_cast, i8 0, i64 16, i1 false)
  %1 = getelementptr inbounds %"record._ZN13std$FS$random11std$FS$core5ArrayIhE", %"record._ZN13std$FS$random11std$FS$core5ArrayIhE" addrspace(1)* %array, i64 0, i32 2
  %2 = load i64, i64 addrspace(1)* %1
  %icmpslt5 = icmp sgt i64 %2, 0
  br i1 %icmpslt5, label %while.body2474E.lr.ph, label %block.end2448E

while.body2474E.lr.ph:                            ; preds = %entry
  %3 = getelementptr inbounds %"record._ZN13std$FS$random11std$FS$core5ArrayIhE", %"record._ZN13std$FS$random11std$FS$core5ArrayIhE" addrspace(1)* %array, i64 0, i32 0
  %4 = getelementptr inbounds %"record._ZN13std$FS$random11std$FS$core5ArrayIhE", %"record._ZN13std$FS$random11std$FS$core5ArrayIhE" addrspace(1)* %array, i64 0, i32 1
  br label %while.body2474E

while.body2474E:                                  ; preds = %while.body2474E.lr.ph, %while.body2474E
  %atom.5600E.06 = phi i64 [ 0, %while.body2474E.lr.ph ], [ %16, %while.body2474E ]
  %5 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %this)
  %6 = getelementptr i8, i8* %5, i64 24
  %7 = bitcast i8* %6 to i8***
  %8 = load i8**, i8*** %7
  %9 = getelementptr i8*, i8** %8, i64 5
  %10 = bitcast i8** %9 to i8 (i8 addrspace(1)*)**
  %11 = load i8 (i8 addrspace(1)*)*, i8 (i8 addrspace(1)*)** %10
  %12 = call i8 %11(i8 addrspace(1)* %this)
  %13 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %3
  %14 = load i64, i64 addrspace(1)* %4
  %add = add i64 %14, %atom.5600E.06
  %15 = bitcast i8 addrspace(1)* %13 to %ArrayLayout.UInt8 addrspace(1)*
  %arr.idx.set.gep = getelementptr inbounds %ArrayLayout.UInt8, %ArrayLayout.UInt8 addrspace(1)* %15, i64 0, i32 1, i64 %add
  call void @llvm.cj.gcwrite.i8.i8(i8 %12, i8 addrspace(1)* %13, i8 addrspace(1)* %arr.idx.set.gep)
  %16 = add nuw nsw i64 %atom.5600E.06, 1
  %17 = load i64, i64 addrspace(1)* %1
  %icmpslt = icmp slt i64 %16, %17
  br i1 %icmpslt, label %while.body2474E, label %block.end2448E

block.end2448E:                                   ; preds = %while.body2474E, %entry
  %18 = bitcast %"record._ZN13std$FS$random11std$FS$core5ArrayIhE"* %0 to i8*
  %19 = bitcast %"record._ZN13std$FS$random11std$FS$core5ArrayIhE" addrspace(1)* %array to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %18, i8 addrspace(1)* noundef align 8 dereferenceable(24) %19, i64 24, i1 false)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"CJBC", i32 1}
!1 = !{!"branch_weights", i32 1, i32 2000}

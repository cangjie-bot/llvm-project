; RUN: opt -enable-new-pm=false --cj-barrier-opt -S < %s | FileCheck %s
; RUN: opt -passes=cj-barrier-opt -S < %s | FileCheck %s

%"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIT2_hhEE" = type { i8 addrspace(1)*, i64, i64 }
%ArrayLayout.T2_hhE = type { %ArrayBase, [0 x %T2_hhE] }
%T2_hhE = type { i8, i8 }
%ArrayBase = type { %ObjLayout.Object, i64 }
%ObjLayout.Object = type { %KlassInfo.0* }
%BitMap = type { i32, [0 x i8] }
%KlassInfo.0 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i64*, i32, [0 x i8*] }
%ArrayLayout.UInt8 = type { %ArrayBase, [0 x i8] }
%T2_clE = type { i32, i64 }
%"record._ZN11std$FS$core6StringE" = type { i8 addrspace(1)*, i64 }
%KlassInfo.1 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i64*, i32, [1 x i8*] }
%"ObjLayout._ZN25std$FS$unittest.prop_test22__Auto__Environment_94E" = type { %"ObjLayout._ZN11std$FS$core6ObjectE", i8 }
%"ObjLayout._ZN11std$FS$core6ObjectE" = type { %ObjLayout.Object }

@"$const_string.24" = private unnamed_addr constant [4 x i8] c"sub\00", align 1
@"$const_string.25" = private unnamed_addr constant [4 x i8] c"add\00", align 1
@UInt8.arrayKlass = weak_odr global %KlassInfo.0 { i32 2, i32 1, %BitMap* null, i8* bitcast (%KlassInfo.0* @array_uint8.primKlass to i8*), i8** null, i64* null, i64* null, i64* bitcast ([6 x i8]* @A1_hE.className to i64*), i32 0, [0 x i8*] zeroinitializer }
@A1_cE.className = weak_odr global [6 x i8] c"A1_cE\00", align 1
@A1_hE.className = weak_odr global [6 x i8] c"A1_hE\00", align 1
@"_ZN11std$FS$core17OverflowExceptionE.objKlass" = external global %KlassInfo.0
@"_ZN11std$FS$core24IllegalArgumentExceptionE.objKlass" = external global %KlassInfo.0
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" = external global %KlassInfo.0
@"_ZN11std$FS$core6String5emptyE" = external global %"record._ZN11std$FS$core6StringE"
@"_ZN23std$$unittest.prop_test22$__STRING_LITERAL__$21E" = internal global %"record._ZN11std$FS$core6StringE" zeroinitializer
@"_ZN25std$FS$unittest.prop_test17firstToSecondByteE" = internal global %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIT2_hhEE" zeroinitializer
@"_ZN25std$FS$unittest.prop_test22__Auto__Environment_94E.objKlass" = internal global %KlassInfo.0 { i32 36, i32 24, %BitMap* inttoptr (i64 -9223372036854775806 to %BitMap*), i8* bitcast (%KlassInfo.1* @"_ZN11std$FS$core6ObjectE.objKlass" to i8*), i8** null, i64* null, i64* null, i64* null, i32 0, [0 x i8*] zeroinitializer }
@"_ZN11std$FS$core6ObjectE.objKlass" = external global %KlassInfo.1
@array_uint8.primKlass = weak_odr global %KlassInfo.0 { i32 1, i32 1, %BitMap* null, i8* null, i8** null, i64* null, i64* null, i64* @array_uint8.uniqueAddr, i32 0, [0 x i8*] zeroinitializer }
@array_uint8.uniqueAddr = weak_odr global i64 0

declare i32 @personality_function()
declare i8 addrspace(1)* @CJ_MCC_BeginCatch(i8* %0) local_unnamed_addr #0
declare void @CJ_MCC_EndCatch() local_unnamed_addr #0
declare i8* @CJ_MCC_GetExceptionWrapper() local_unnamed_addr #0
declare i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %0) local_unnamed_addr #0
declare i1 @CJ_MCC_IsInstanceOf(i8 addrspace(1)* %0, i8* %1) #0
declare i8 addrspace(1)* @CJ_MCC_NewArray8Stub(i64 %0, i8* %1)
declare i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* %0, i32 %1)
declare void @CJ_MCC_ThrowException(i8 addrspace(1)* %0) local_unnamed_addr
declare void @CJ_MCC_ThrowStackOverflowError()
declare cangjiegccc void @MCC_SafepointStub() local_unnamed_addr
declare void @"_ZN11std$FS$core24IllegalArgumentException4initER_ZN11std$FS$core6StringE"(i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)
declare void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)*)
declare void @"_ZN11std$FS$core6Extend4Char8fromUtf8ER_ZN11std$FS$core5ArrayIhEl"(%T2_clE*, i8 addrspace(1)*, %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE" addrspace(1)*, i64)
declare void @"_ZN11std$FS$core6Extend5Int648toStringEv"(%"record._ZN11std$FS$core6StringE"*, i64)
declare void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"*, i8*, i64)
declare void @"_ZN11std$FS$core6String6concatER_ZN11std$FS$core6StringE"(%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)
declare void @llvm.cj.gcwrite.i8.i8(i8 %0, i8 addrspace(1)* nocapture %1, i8 addrspace(1)* nocapture %2)
declare void @llvm.cj.gcwrite.p1i8.p1i8(i8 addrspace(1)*, i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)*)
declare void @llvm.lifetime.end.p0i8(i64, i8*)
declare void @llvm.lifetime.start.p0i8(i64, i8*)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)
declare { i8, i1 } @llvm.uadd.with.overflow.i8(i8, i8)
declare { i8, i1 } @llvm.usub.with.overflow.i8(i8, i8)
declare i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)

; CHECK: call void @llvm.cj.gcwrite.p1i8.p1i8(i8 addrspace(1)* %this, i8 addrspace(1)* %50, i8 addrspace(1)* addrspace(1)* %52)
; CHECK: call void @llvm.cj.gcwrite.i8.i8(i8 %switchValue.0, i8 addrspace(1)* %50, i8 addrspace(1)* %53)
; CHECK: call void @llvm.cj.gcwrite.i8.i8(i8 %switchValue.0.i, i8 addrspace(1)* %49, i8 addrspace(1)* %arr.idx.set.gep.i)

define i32 @"_ZN25std$FS$unittest.prop_test6Extend6Random8nextUtf8El"(i8 addrspace(1)* %this, i64 %byteSize) gc "cangjie" personality i32 ()* @personality_function {
entry:
  %callRet13.i.i = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet13.i.i52 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet13.i.i to i8*
  %callRet7.i.i = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet7.i.i51 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet7.i.i to i8*
  %callRet.i = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet.i53 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet.i to i8*
  %callRet63 = alloca %T2_clE, align 8
  %arr = alloca %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE", align 8
  %callRet48 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet38 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet28 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet18 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet10 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet7 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %callRet = alloca %"record._ZN11std$FS$core6StringE", align 8
  %0 = bitcast %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE"* %arr to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %0, i8 0, i64 24, i1 false)
  %1 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet48 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %1, i8 0, i64 16, i1 false)
  %2 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet38 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %2, i8 0, i64 16, i1 false)
  %3 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet28 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %3, i8 0, i64 16, i1 false)
  %4 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet18 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %4, i8 0, i64 16, i1 false)
  %5 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet10 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %5, i8 0, i64 16, i1 false)
  %6 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet7 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %6, i8 0, i64 16, i1 false)
  %7 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %7, i8 0, i64 16, i1 false)
  %atom.288984E.sroa.0.0..sroa_idx11 = getelementptr inbounds %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE", %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE"* %arr, i64 0, i32 0
  %atom.288984E.sroa.4.0..sroa_idx14 = getelementptr inbounds %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE", %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE"* %arr, i64 0, i32 1
  %atom.288984E.sroa.5.0..sroa_idx17 = getelementptr inbounds %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE", %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE"* %arr, i64 0, i32 2
  %8 = addrspacecast %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE"* %arr to %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE" addrspace(1)*
  %9 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %10 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet7 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %11 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet10 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  call void @CJ_MCC_ThrowStackOverflowError()
  call cangjiegccc void @MCC_SafepointStub()
  br label %block.body3

block.body3:                                      ; preds = %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp, %entry
  switch i64 %byteSize, label %default_thunk [
    i64 1, label %case_0_thunk
    i64 2, label %case_1_thunk
    i64 3, label %case_2_thunk
    i64 4, label %case_3_thunk
  ]

default_thunk:                                    ; preds = %block.body3
  %12 = invoke noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core24IllegalArgumentExceptionE.objKlass" to i8*), i32 56)
          to label %invoke.continue unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

invoke.continue:                                  ; preds = %default_thunk
  invoke void @"_ZN11std$FS$core6Extend5Int648toStringEv"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet, i64 %byteSize)
          to label %invoke.continue6 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

invoke.continue6:                                 ; preds = %invoke.continue
  invoke void @"_ZN11std$FS$core6String6concatER_ZN11std$FS$core6StringE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet7, i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* addrspacecast (%"record._ZN11std$FS$core6StringE"* @"_ZN23std$$unittest.prop_test22$__STRING_LITERAL__$21E" to %"record._ZN11std$FS$core6StringE" addrspace(1)*), i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %9)
          to label %invoke.continue9 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

invoke.continue9:                                 ; preds = %invoke.continue6
  invoke void @"_ZN11std$FS$core6String6concatER_ZN11std$FS$core6StringE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet10, i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %10, i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* addrspacecast (%"record._ZN11std$FS$core6StringE"* @"_ZN11std$FS$core6String5emptyE" to %"record._ZN11std$FS$core6StringE" addrspace(1)*))
          to label %invoke.continue13 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

invoke.continue13:                                ; preds = %invoke.continue9
  invoke void @"_ZN11std$FS$core24IllegalArgumentException4initER_ZN11std$FS$core6StringE"(i8 addrspace(1)* %12, i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %11)
          to label %.noexc37.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

case_0_thunk:                                     ; preds = %block.body3
  %13 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %this)
  %14 = getelementptr i8, i8* %13, i64 24
  %15 = bitcast i8* %14 to i8***
  %16 = load i8**, i8*** %15, align 8
  %17 = getelementptr i8*, i8** %16, i64 13
  %18 = bitcast i8** %17 to i8 (i8 addrspace(1)*, i8)**
  %19 = load i8 (i8 addrspace(1)*, i8)*, i8 (i8 addrspace(1)*, i8)** %18, align 8
  %20 = invoke i8 %19(i8 addrspace(1)* %this, i8 62)
          to label %invoke.continue17 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

invoke.continue17:                                ; preds = %case_0_thunk
  %21 = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %20, i8 65)
  %.fca.1.extract = extractvalue { i8, i1 } %21, 1
  br i1 %.fca.1.extract, label %overflow, label %switch_end, !prof !0

overflow:                                         ; preds = %invoke.continue17
  invoke void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet18, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.25", i64 0, i64 0), i64 3)
          to label %.noexc36.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

case_1_thunk:                                     ; preds = %block.body3
  %22 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %this)
  %23 = getelementptr i8, i8* %22, i64 24
  %24 = bitcast i8* %23 to i8***
  %25 = load i8**, i8*** %24, align 8
  %26 = getelementptr i8*, i8** %25, i64 13
  %27 = bitcast i8** %26 to i8 (i8 addrspace(1)*, i8)**
  %28 = load i8 (i8 addrspace(1)*, i8)*, i8 (i8 addrspace(1)*, i8)** %27, align 8
  %29 = invoke i8 %28(i8 addrspace(1)* %this, i8 30)
          to label %invoke.continue23 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

invoke.continue23:                                ; preds = %case_1_thunk
  %30 = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %29, i8 -62)
  %.fca.1.extract3 = extractvalue { i8, i1 } %30, 1
  br i1 %.fca.1.extract3, label %overflow26, label %switch_end, !prof !0

overflow26:                                       ; preds = %invoke.continue23
  invoke void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet28, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.25", i64 0, i64 0), i64 3)
          to label %.noexc36.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

case_2_thunk:                                     ; preds = %block.body3
  %31 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %this)
  %32 = getelementptr i8, i8* %31, i64 24
  %33 = bitcast i8* %32 to i8***
  %34 = load i8**, i8*** %33, align 8
  %35 = getelementptr i8*, i8** %34, i64 13
  %36 = bitcast i8** %35 to i8 (i8 addrspace(1)*, i8)**
  %37 = load i8 (i8 addrspace(1)*, i8)*, i8 (i8 addrspace(1)*, i8)** %36, align 8
  %38 = invoke i8 %37(i8 addrspace(1)* %this, i8 16)
          to label %invoke.continue33 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

invoke.continue33:                                ; preds = %case_2_thunk
  %39 = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %38, i8 -32)
  %.fca.1.extract6 = extractvalue { i8, i1 } %39, 1
  br i1 %.fca.1.extract6, label %overflow36, label %switch_end, !prof !0

overflow36:                                       ; preds = %invoke.continue33
  invoke void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet38, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.25", i64 0, i64 0), i64 3)
          to label %.noexc36.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

case_3_thunk:                                     ; preds = %block.body3
  %40 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %this)
  %41 = getelementptr i8, i8* %40, i64 24
  %42 = bitcast i8* %41 to i8***
  %43 = load i8**, i8*** %42, align 8
  %44 = getelementptr i8*, i8** %43, i64 13
  %45 = bitcast i8** %44 to i8 (i8 addrspace(1)*, i8)**
  %46 = load i8 (i8 addrspace(1)*, i8)*, i8 (i8 addrspace(1)*, i8)** %45, align 8
  %47 = invoke i8 %46(i8 addrspace(1)* %this, i8 4)
          to label %invoke.continue43 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

invoke.continue43:                                ; preds = %case_3_thunk
  %48 = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %47, i8 -16)
  %.fca.1.extract9 = extractvalue { i8, i1 } %48, 1
  br i1 %.fca.1.extract9, label %overflow46, label %switch_end, !prof !0

overflow46:                                       ; preds = %invoke.continue43
  invoke void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet48, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.25", i64 0, i64 0), i64 3)
          to label %.noexc36.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

switch_end:                                       ; preds = %invoke.continue43, %invoke.continue33, %invoke.continue23, %invoke.continue17
  %.pn = phi { i8, i1 } [ %21, %invoke.continue17 ], [ %30, %invoke.continue23 ], [ %39, %invoke.continue33 ], [ %48, %invoke.continue43 ]
  %switchValue.0 = extractvalue { i8, i1 } %.pn, 0
  %b0 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN25std$FS$unittest.prop_test22__Auto__Environment_94E.objKlass" to i8*), i32 24)
  %49 = invoke noalias i8 addrspace(1)* @CJ_MCC_NewArray8Stub(i64 %byteSize, i8* bitcast (%KlassInfo.0* @UInt8.arrayKlass to i8*))
          to label %invoke.continue57 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

invoke.continue57:                                ; preds = %switch_end, %invoke.continue57
  %a = phi i8 [ %switchValue.0, %switch_end ], [ %a.i, %invoke.continue57 ]
  %b = phi i8 addrspace(1)* [ %b0, %switch_end ], [ %b1, %invoke.continue57 ]
  %50 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN25std$FS$unittest.prop_test22__Auto__Environment_94E.objKlass" to i8*), i32 24)
  %b.0 = getelementptr inbounds i8, i8 addrspace(1)* %b, i64 16
  call void @llvm.cj.gcwrite.i8.i8(i8 %switchValue.0, i8 addrspace(1)* %b, i8 addrspace(1)* %b.0)
  %a.i = add nuw nsw i8 %a, 1
  %b1 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN25std$FS$unittest.prop_test22__Auto__Environment_94E.objKlass" to i8*), i32 24)
  %icmpeq.a = icmp eq i8 %a.i, 50
  br i1 %icmpeq.a, label %invoke.continue57, label %invoke.continue59

invoke.continue59:                                ; preds = %invoke.continue57
  %51 = getelementptr inbounds i8, i8 addrspace(1)* %50, i64 8
  %52 = bitcast i8 addrspace(1)* %51 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.p1i8.p1i8(i8 addrspace(1)* %this, i8 addrspace(1)* %50, i8 addrspace(1)* addrspace(1)* %52)
  %53 = getelementptr inbounds i8, i8 addrspace(1)* %50, i64 16
  call void @llvm.cj.gcwrite.i8.i8(i8 %switchValue.0, i8 addrspace(1)* %50, i8 addrspace(1)* %53)
  %54 = getelementptr inbounds i8, i8 addrspace(1)* %49, i64 8
  %55 = bitcast i8 addrspace(1)* %54 to i64 addrspace(1)*
  %56 = load i64, i64 addrspace(1)* %55, align 8
  %icmpslt4.i = icmp sgt i64 %56, 0
  br i1 %icmpslt4.i, label %while.body.lr.ph.i, label %invoke.continue61

while.body.lr.ph.i:                               ; preds = %invoke.continue59
  %57 = bitcast i8 addrspace(1)* %49 to %ArrayLayout.UInt8 addrspace(1)*
  %58 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %52, align 8
  %59 = load i8, i8 addrspace(1)* %53, align 1
  %60 = zext i8 %59 to i64
  br label %while.body.i

while.body.i:                                     ; preds = %arr.if.else.i, %while.body.lr.ph.i
  %atom.284140E.05.i = phi i64 [ 0, %while.body.lr.ph.i ], [ %add.i, %arr.if.else.i ]
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %callRet.i53)
  switch i64 %atom.284140E.05.i, label %default_thunk.i [
    i64 0, label %"std/unittest.prop_test$lambda.23.exit"
    i64 1, label %case_1_thunk.i
  ]

default_thunk.i:                                  ; preds = %while.body.i
  %61 = invoke i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %58)
          to label %.noexc23 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

.noexc23:                                         ; preds = %default_thunk.i
  %62 = getelementptr i8, i8* %61, i64 24
  %63 = bitcast i8* %62 to i8***
  %64 = load i8**, i8*** %63, align 8
  %65 = getelementptr i8*, i8** %64, i64 13
  %66 = bitcast i8** %65 to i8 (i8 addrspace(1)*, i8)**
  %67 = load i8 (i8 addrspace(1)*, i8)*, i8 (i8 addrspace(1)*, i8)** %66, align 8
  %68 = invoke i8 %67(i8 addrspace(1)* %58, i8 64)
          to label %.noexc24 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

.noexc24:                                         ; preds = %.noexc23
  %69 = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %68, i8 -128)
  %.fca.1.extract.i = extractvalue { i8, i1 } %69, 1
  br i1 %.fca.1.extract.i, label %overflow.i, label %normal.i, !prof !0

normal.i:                                         ; preds = %.noexc24
  %.fca.0.extract.i = extractvalue { i8, i1 } %69, 0
  br label %"std/unittest.prop_test$lambda.23.exit"

overflow.i:                                       ; preds = %.noexc24
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %callRet.i53, i8 0, i64 16, i1 false)
  invoke void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet.i, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.25", i64 0, i64 0), i64 3)
          to label %.noexc36.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

case_1_thunk.i:                                   ; preds = %while.body.i
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %callRet13.i.i52)
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %callRet7.i.i51)
  %70 = load i64, i64* getelementptr inbounds (%"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIT2_hhEE", %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIT2_hhEE"* @"_ZN25std$FS$unittest.prop_test17firstToSecondByteE", i64 0, i32 2), align 16
  %icmpuge.not.i.i = icmp ugt i64 %70, %60
  br i1 %icmpuge.not.i.i, label %if.else.i.i, label %if.then.i.i

if.then.i.i:                                      ; preds = %case_1_thunk.i
  %71 = invoke noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
          to label %.noexc28 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

.noexc28:                                         ; preds = %if.then.i.i
  invoke void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %71)
          to label %.noexc37.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

if.else.i.i:                                      ; preds = %case_1_thunk.i
  %72 = load %ArrayLayout.T2_hhE addrspace(1)*, %ArrayLayout.T2_hhE addrspace(1)** bitcast (%"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIT2_hhEE"* @"_ZN25std$FS$unittest.prop_test17firstToSecondByteE" to %ArrayLayout.T2_hhE addrspace(1)**), align 16
  %73 = load i64, i64* getelementptr inbounds (%"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIT2_hhEE", %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIT2_hhEE"* @"_ZN25std$FS$unittest.prop_test17firstToSecondByteE", i64 0, i32 1), align 8
  %add.i.i = add i64 %73, %60
  %arr.get.sroa.0.0..sroa_idx.i.i = getelementptr inbounds %ArrayLayout.T2_hhE, %ArrayLayout.T2_hhE addrspace(1)* %72, i64 0, i32 1, i64 %add.i.i, i32 0
  %arr.get.sroa.0.0.copyload.i.i = load i8, i8 addrspace(1)* %arr.get.sroa.0.0..sroa_idx.i.i, align 1
  %arr.get.sroa.2.0..sroa_idx.i.i = getelementptr inbounds %ArrayLayout.T2_hhE, %ArrayLayout.T2_hhE addrspace(1)* %72, i64 0, i32 1, i64 %add.i.i, i32 1
  %arr.get.sroa.2.0.copyload.i.i = load i8, i8 addrspace(1)* %arr.get.sroa.2.0..sroa_idx.i.i, align 1
  %74 = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 %arr.get.sroa.2.0.copyload.i.i, i8 %arr.get.sroa.0.0.copyload.i.i)
  %.fca.1.extract.i.i = extractvalue { i8, i1 } %74, 1
  br i1 %.fca.1.extract.i.i, label %overflow.i.i, label %normal.i.i, !prof !0

normal.i.i:                                       ; preds = %if.else.i.i
  %75 = invoke i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %58)
          to label %.noexc31 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

.noexc31:                                         ; preds = %normal.i.i
  %.fca.0.extract.i.i = extractvalue { i8, i1 } %74, 0
  %76 = getelementptr i8, i8* %75, i64 24
  %77 = bitcast i8* %76 to i8***
  %78 = load i8**, i8*** %77, align 8
  %79 = getelementptr i8*, i8** %78, i64 13
  %80 = bitcast i8** %79 to i8 (i8 addrspace(1)*, i8)**
  %81 = load i8 (i8 addrspace(1)*, i8)*, i8 (i8 addrspace(1)*, i8)** %80, align 8
  %82 = invoke i8 %81(i8 addrspace(1)* %58, i8 %.fca.0.extract.i.i)
          to label %.noexc32 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

.noexc32:                                         ; preds = %.noexc31
  %83 = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %82, i8 %arr.get.sroa.0.0.copyload.i.i)
  %.fca.1.extract5.i.i = extractvalue { i8, i1 } %83, 1
  br i1 %.fca.1.extract5.i.i, label %overflow11.i.i, label %"_ZN25std$FS$unittest.prop_test6Extend6Random18nextUtf8SecondByteEh.exit.i", !prof !0

overflow.i.i:                                     ; preds = %if.else.i.i
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %callRet7.i.i51, i8 0, i64 16, i1 false)
  invoke void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet7.i.i, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.24", i64 0, i64 0), i64 3)
          to label %.noexc36.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

overflow11.i.i:                                   ; preds = %.noexc32
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %callRet13.i.i52, i8 0, i64 16, i1 false)
  invoke void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet13.i.i, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.25", i64 0, i64 0), i64 3)
          to label %.noexc36.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

.noexc36.invoke:                                  ; preds = %overflow, %overflow26, %overflow36, %overflow46, %overflow11.i.i, %overflow.i.i, %overflow.i
  %.in55 = phi %"record._ZN11std$FS$core6StringE"* [ %callRet.i, %overflow.i ], [ %callRet7.i.i, %overflow.i.i ], [ %callRet13.i.i, %overflow11.i.i ], [ %callRet18, %overflow ], [ %callRet28, %overflow26 ], [ %callRet38, %overflow36 ], [ %callRet48, %overflow46 ]
  %84 = addrspacecast %"record._ZN11std$FS$core6StringE"* %.in55 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %85 = invoke i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %84)
          to label %.noexc37.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

.noexc37.invoke:                                  ; preds = %.noexc36.invoke, %invoke.continue13, %.noexc19, %.noexc28
  %86 = phi i8 addrspace(1)* [ %71, %.noexc28 ], [ %12, %invoke.continue13 ], [ %88, %.noexc19 ], [ %85, %.noexc36.invoke ]
  invoke void @CJ_MCC_ThrowException(i8 addrspace(1)* %86)
          to label %.noexc37.cont unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

.noexc37.cont:                                    ; preds = %.noexc37.invoke
  unreachable

"_ZN25std$FS$unittest.prop_test6Extend6Random18nextUtf8SecondByteEh.exit.i": ; preds = %.noexc32
  %.fca.0.extract4.i.i = extractvalue { i8, i1 } %83, 0
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %callRet13.i.i52)
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %callRet7.i.i51)
  br label %"std/unittest.prop_test$lambda.23.exit"

"std/unittest.prop_test$lambda.23.exit":          ; preds = %while.body.i, %normal.i, %"_ZN25std$FS$unittest.prop_test6Extend6Random18nextUtf8SecondByteEh.exit.i"
  %switchValue.0.i = phi i8 [ %.fca.0.extract.i, %normal.i ], [ %.fca.0.extract4.i.i, %"_ZN25std$FS$unittest.prop_test6Extend6Random18nextUtf8SecondByteEh.exit.i" ], [ %59, %while.body.i ]
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %callRet.i53)
  %87 = load i64, i64 addrspace(1)* %55, align 8
  %.not.i = icmp slt i64 %atom.284140E.05.i, %87
  br i1 %.not.i, label %arr.if.else.i, label %arr.if.then.i

arr.if.then.i:                                    ; preds = %"std/unittest.prop_test$lambda.23.exit"
  %88 = invoke noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
          to label %.noexc19 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

.noexc19:                                         ; preds = %arr.if.then.i
  invoke void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %88)
          to label %.noexc37.invoke unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

arr.if.else.i:                                    ; preds = %"std/unittest.prop_test$lambda.23.exit"
  %arr.idx.set.gep.i = getelementptr inbounds %ArrayLayout.UInt8, %ArrayLayout.UInt8 addrspace(1)* %57, i64 0, i32 1, i64 %atom.284140E.05.i
  call void @llvm.cj.gcwrite.i8.i8(i8 %switchValue.0.i, i8 addrspace(1)* %49, i8 addrspace(1)* %arr.idx.set.gep.i)
  %add.i = add nuw nsw i64 %atom.284140E.05.i, 1
  %89 = load i64, i64 addrspace(1)* %55, align 8
  %icmpslt.i = icmp slt i64 %add.i, %89
  call cangjiegccc void @MCC_SafepointStub()
  br i1 %icmpslt.i, label %while.body.i, label %invoke.continue61

invoke.continue61:                                ; preds = %arr.if.else.i, %invoke.continue59
  store i8 addrspace(1)* %49, i8 addrspace(1)** %atom.288984E.sroa.0.0..sroa_idx11, align 8
  store i64 0, i64* %atom.288984E.sroa.4.0..sroa_idx14, align 8
  store i64 %byteSize, i64* %atom.288984E.sroa.5.0..sroa_idx17, align 8
  invoke void @"_ZN11std$FS$core6Extend4Char8fromUtf8ER_ZN11std$FS$core5ArrayIhEl"(%T2_clE* noalias nonnull sret(%T2_clE) %callRet63, i8 addrspace(1)* null, %"record._ZN25std$FS$unittest.prop_test11std$FS$core5ArrayIhE" addrspace(1)* %8, i64 0)
          to label %invoke.continue65 unwind label %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

invoke.continue65:                                ; preds = %invoke.continue61
  %90 = getelementptr inbounds %T2_clE, %T2_clE* %callRet63, i64 0, i32 0
  %91 = load i32, i32* %90, align 8
  ret i32 %91

landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp: ; preds = %.noexc31, %normal.i.i, %.noexc23, %default_thunk.i, %.noexc36.invoke, %.noexc37.invoke, %overflow11.i.i, %overflow.i.i, %.noexc28, %if.then.i.i, %overflow.i, %.noexc19, %arr.if.then.i, %invoke.continue61, %switch_end, %overflow46, %case_3_thunk, %overflow36, %case_2_thunk, %overflow26, %case_1_thunk, %overflow, %case_0_thunk, %invoke.continue13, %invoke.continue9, %invoke.continue6, %invoke.continue, %default_thunk
  %lpad.loopexit.split-lp56 = landingpad token
          catch i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core17OverflowExceptionE.objKlass" to i8*)
  %92 = call i8* @CJ_MCC_GetExceptionWrapper()
  %93 = call i8 addrspace(1)* @CJ_MCC_BeginCatch(i8* %92)
  %94 = call i1 @CJ_MCC_IsInstanceOf(i8 addrspace(1)* %93, i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core17OverflowExceptionE.objKlass" to i8*))
  call cangjiegccc void @MCC_SafepointStub()
  br i1 %94, label %block.body3, label %if.else

if.else:                                          ; preds = %landingPad.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp
  call void @CJ_MCC_EndCatch()
  invoke void @CJ_MCC_ThrowException(i8 addrspace(1)* %93)
          to label %invoke.continue71 unwind label %finally.rethrow

invoke.continue71:                                ; preds = %if.else
  unreachable

finally.rethrow:                                  ; preds = %if.else
  %95 = landingpad token
          catch i8* null
  %96 = call i8* @CJ_MCC_GetExceptionWrapper()
  %97 = call i8 addrspace(1)* @CJ_MCC_BeginCatch(i8* %96)
  call void @CJ_MCC_EndCatch()
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %97)
  unreachable
}

attributes #0 = { "cj-runtime" "gc-leaf-function" }

!0 = !{!"branch_weights", i32 1, i32 2000}

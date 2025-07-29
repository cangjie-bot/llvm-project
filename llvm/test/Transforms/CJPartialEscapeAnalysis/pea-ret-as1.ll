; RUN: opt < %s '-passes=cj-pea' -cj-disable-partial-ea -S | FileCheck %s

%BitMap = type { i32, [0 x i8] }
%TypeInfo = type { i8*, i8, i8, i16, i32, %BitMap*, i32, i8, i8, i32*, i8*, i8*, i8*, %TypeInfo*, i8*, i8* }
%ObjLayout._ZN7default8CrcCheck = type { %record._ZN8std.core5ArrayIlE, %record._ZN8std.core5ArrayIlE, %record._ZN8std.core5ArrayIlE, i64, i64, i64 }
%record._ZN8std.core5ArrayIlE = type { i8 addrspace(1)*, i64, i64 }

@_ZN7default20var_1715509008039_60E = global i8 0, align 8
@_ZN7default8CrcCheck.ti = internal global %TypeInfo {i8* getelementptr inbounds ([17 x i8], [17 x i8]* @"default$CrcCheck.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$CrcCheck.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$CrcCheck.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$CrcCheck.fieldNames" to i8*)}
@"default$CrcCheck.name" = internal global [17 x i8] c"default$CrcCheck\00", align 1
@"std.core$Object.ti" = external global %TypeInfo
@"default$CrcCheck.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$CrcCheck.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$CrcCheck.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$CrcCheck.field.1.name", i32 0, i32 0)]
@"default$CrcCheck.field.1.name" = internal global [3 x i8] c"aa\00", align 1
@_ZN7default10typeScriptE = global i8 addrspace(1)* null, align 8


%record._ZN8std.core6StringE = type { %record._ZN8std.core5ArrayIhE, i64 }
%record._ZN8std.core5ArrayIhE = type { i8 addrspace(1)*, i64, i64 }
%record._ZN14std.collection12HashMapEntryIR_ZN8std.core6StringEN_ZN8std.core6OptionIC_ZN8std.core3AnyEEE = type { i64, i64, %record._ZN8std.core6StringE, i8 addrspace(1)* }



declare i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8*, i32)

declare i8 addrspace(1)* @CJ_MCC_NewArray64Stub(i64, i8*)

declare i8 addrspace(1)* @llvm.cj.gcread.static.ref(i8 addrspace(1)** nocapture %0)

declare void @llvm.cj.gcwrite.static.ref(i8 addrspace(1)* %0, i8 addrspace(1)** nocapture %1)

define i8 addrspace(1)* @_ZN7default13getTypeScriptEv() gc "cangjie" {
bb0:
  %0 = call i8 addrspace(1)* @llvm.cj.gcread.static.ref(i8 addrspace(1)** nonnull @_ZN7default10typeScriptE)
  %.not = icmp eq i8 addrspace(1)* %0, null
  br i1 %.not, label %bb3, label %bb2

bb3:
  %1 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%TypeInfo* @_ZN7default8CrcCheck.ti to i8*), i32 912)
  call void @llvm.cj.gcwrite.static.ref(i8 addrspace(1)* %1, i8 addrspace(1)** nonnull @_ZN7default10typeScriptE)
  %2 = call i8 addrspace(1)* @llvm.cj.gcread.static.ref(i8 addrspace(1)** nonnull @_ZN7default10typeScriptE)
  %.not2 = icmp eq i8 addrspace(1)* %2, null
  br i1 %.not2, label %bb4, label %bb2

bb2:
  %.0 = phi i8 addrspace(1)* [ %0, %bb0 ], [ %2, %bb3 ]
  ret i8 addrspace(1)* %.0

bb4:
  unreachable
}

; Function Attrs: argmemonly nounwind
declare void @llvm.cj.gcwrite.ref(i8 addrspace(1)*, i8 addrspace(1)* nocapture, i8 addrspace(1)* addrspace(1)* nocapture) #0

; Function Attrs: argmemonly nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p1i8.i64(i8 addrspace(1)* nocapture writeonly, i8, i64, i1 immarg) #1

declare i8 addrspace(1)* @CJ_MCC_NewArrayStub(i64 %0, i8* %1)

define void @foo() gc "cangjie" {
; CHECK-LABEL: @foo(
; CHECK-LABEL: bb0
; CHECK-NOT: %0 = alloca %ObjLayout._ZN7default8CrcCheckE
bb0:
  %0 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%TypeInfo* @_ZN7default8CrcCheck.ti to i8*), i32 24)
  %1 = call i8 addrspace(1)* @_ZN7default13getTypeScriptEv()
  %2 = getelementptr inbounds i8, i8 addrspace(1)* %1, i64 736
  %3 = bitcast i8 addrspace(1)* %2 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %0, i8 addrspace(1)* %1, i8 addrspace(1)* addrspace(1)* %3)
  ret void
}

attributes #0 = { argmemonly nounwind }
attributes #1 = { argmemonly nocallback nofree nounwind willreturn writeonly }

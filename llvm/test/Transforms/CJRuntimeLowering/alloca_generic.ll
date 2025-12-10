; RUN: opt -passes=cj-runtime-lowering -S < %s | FileCheck %s


%Record = type { i8 addrspace(1)*, i64 }
%TypeInfo = type { i8*, i8, i8, i16, i32, i8*, i32, i8, i8, i32*, i8*, i8*, i8*, i8*, i8*, i8* }
@Int64.ti = external global %TypeInfo, !RelatedType !0 #0

; Function Attrs: nounwind
declare i8 addrspace(1)* @llvm.cj.alloca.generic(i8*, i32)

declare i8 addrspace(1)* @moo(i8 addrspace(1)*, %TypeInfo*) gc "cangjie"
declare void @koo(i8 addrspace(1)* noalias sret(i8), %TypeInfo*) gc "cangjie"

; CHECK:  bb0:
; CHECK:   %0 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Int64.ti to i8*), i32 16)

define i8 addrspace(1)* @foo(i64 %x) gc "cangjie" {
bb0:
  %0 = call i8 addrspace(1)* @llvm.cj.alloca.generic(i8* bitcast (%TypeInfo* @Int64.ti to i8*), i32 8)
  %1 = bitcast i8 addrspace(1)* %0 to i8* addrspace(1)*
  %ti.payload = getelementptr i8*, i8* addrspace(1)* %1, i32 1
  %2 = bitcast i8* addrspace(1)* %ti.payload to i64 addrspace(1)*
  store i64 %x, i64 addrspace(1)* %2, align 8
  %3 = call i8 addrspace(1)* @moo(i8 addrspace(1)* %0, %TypeInfo* @Int64.ti)
  ret i8 addrspace(1)* %3
}

; CHECK:  bb0:
; CHECK:   %0 = alloca { %TypeInfo*, i64 }, align 8

define i64 @foo2(i64 %x) gc "cangjie" {
bb0:
  %0 = call i8 addrspace(1)* @llvm.cj.alloca.generic(i8* bitcast (%TypeInfo* @Int64.ti to i8*), i32 8)
  %1 = bitcast i8 addrspace(1)* %0 to i8* addrspace(1)*
  %ti.payload = getelementptr i8*, i8* addrspace(1)* %1, i32 1
  %2 = bitcast i8* addrspace(1)* %ti.payload to i64 addrspace(1)*
  store i64 %x, i64 addrspace(1)* %2, align 8
  call void @koo(i8 addrspace(1)* noalias sret(i8) %0, %TypeInfo* @Int64.ti)
  ret i64 %x
}

; CHECK:  bb0:
; CHECK:   %0 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Int64.ti to i8*), i32 16)

define i8 addrspace(1)* @foo3(i64 %x) gc "cangjie" {
bb0:
  %0 = call i8 addrspace(1)* @llvm.cj.alloca.generic(i8* bitcast (%TypeInfo* @Int64.ti to i8*), i32 8)
  %1 = bitcast i8 addrspace(1)* %0 to i8* addrspace(1)*
  %ti.payload = getelementptr i8*, i8* addrspace(1)* %1, i32 1
  %2 = bitcast i8* addrspace(1)* %ti.payload to i64 addrspace(1)*
  store i64 %x, i64 addrspace(1)* %2, align 8
  call void @koo(i8 addrspace(1)* noalias sret(i8) %0, %TypeInfo* @Int64.ti)
  ret i8 addrspace(1)* %0
}

; CHECK:  bb0:
; CHECK:   %0 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @Int64.ti to i8*), i32 16)

define void @foo4(%Record* noalias sret(%Record) %r, i64 %x) gc "cangjie" {
bb0:
  %0 = call i8 addrspace(1)* @llvm.cj.alloca.generic(i8* bitcast (%TypeInfo* @Int64.ti to i8*), i32 8)
  %1 = bitcast i8 addrspace(1)* %0 to i8* addrspace(1)*
  %ti.payload = getelementptr i8*, i8* addrspace(1)* %1, i32 1
  %2 = bitcast i8* addrspace(1)* %ti.payload to i64 addrspace(1)*
  store i64 %x, i64 addrspace(1)* %2, align 8
  %3 = bitcast %Record* %r to i8 addrspace(1)**
  store i8 addrspace(1)* %0, i8 addrspace(1)** %3, align 8
  ret void
}

attributes #0 = { "CFileKlass" "NotModifiableClass" }

!0 = !{!"Int64.Type"}

; RUN: opt < %s '-passes=cj-pea' -cj-disable-partial-ea -S | FileCheck %s

%BitMap = type { i32, [0 x i8] }
%TypeInfo = type { i8*, i8, i8, i16, i32, %BitMap*, i32, i8, i8, i32*, i8*, i8*, i8*, %TypeInfo*, i8*, i8* }
%ObjLayout.obj = type {i32, i32, i32, i32}
@"obj.ti" = external global %TypeInfo, !RelatedType !0

; CHECK-NOT: [[TMP0:%.*]] = load %TypeInfo*, %TypeInfo** [[TMP1:%.*]], !invariant.load !1
define void @foo() gc "cangjie" {
  %1 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @"obj.ti" to i8*), i32 16)
  %2 = bitcast i8 addrspace(1)* %1 to %TypeInfo* addrspace(1)*
  %3 = addrspacecast %TypeInfo* addrspace(1)* %2 to %TypeInfo**
  %4 = load %TypeInfo*, %TypeInfo** %3, !invariant.load !1
  ret void
}

declare i8 addrspace(1)* @CJ_MCC_NewObject(i8*, i32)

!0 = !{!"ObjLayout.obj"}
!1 = !{}
; RUN: opt < %s -insert-cj-tbaa --cangjie-pipeline  -S | FileCheck %s

%TempType = type { i64, i8 addrspace(1)* }

define void @foo(i8 addrspace(1)* %0) gc "cangjie" {
entry:
  %1 = bitcast i8 addrspace(1)* %0 to i8* addrspace(1)*
  %2 = getelementptr i8*, i8* addrspace(1)* %1, i32 1
  %3 = bitcast i8* addrspace(1)* %2 to %TempType addrspace(1)*
  %4 = getelementptr inbounds %TempType, %TempType addrspace(1)* %3, i32 0, i32 0
  store i64 0, i64 addrspace(1)* %4, align 8
  %5 = bitcast i8* addrspace(1)* %2 to { i64, i8 addrspace(1)* } addrspace(1)*
  %6 = getelementptr inbounds { i64, i8 addrspace(1)* }, { i64, i8 addrspace(1)* } addrspace(1)* %5, i32 0, i32 0
  ; CHECK-NOT: %7 = load i64, i64 addrspace(1)* %6, align 4, !tbaa
  %7 = load i64, i64 addrspace(1)* %6
  ret void
}
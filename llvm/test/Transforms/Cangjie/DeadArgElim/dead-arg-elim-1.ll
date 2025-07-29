; RUN: opt < %s -passes=deadargelim --cangjie-pipeline -S | FileCheck %s

%record = type { i64, i8 addrspace(1)* }

; CHECK: define internal void @test(%record* %arg1, i8 addrspace(1)* %p)
define internal void @test(i8* %arg0, %record* %arg1, i8 addrspace(1)* %p) {
  %ptr = getelementptr inbounds %record, %record* %arg1, i32 0, i32 1
  store i8 addrspace(1)* %p, i8 addrspace(1)** %ptr
  ret void
}

; CHECK: define internal void @test1(%record addrspace(1)* %arg0, i8 addrspace(1)* %arg1, i8 addrspace(1)* %p)
define internal void @test1(%record addrspace(1)* %arg0, i8 addrspace(1)* %arg1, i8 addrspace(1)* %p) {
  %ptr = getelementptr inbounds %record, %record addrspace(1)* %arg0, i32 0, i32 1
  store i8 addrspace(1)* %p, i8 addrspace(1)* addrspace(1)* %ptr
  ret void
}

; CHECK: define internal void @test2(%record addrspace(1)* %arg0, i8 addrspace(1)* %arg1, i8 addrspace(1)* %p)
define internal void @test2(%record addrspace(1)* %arg0, i8 addrspace(1)* %arg1, %record* %arg2, i8 addrspace(1)* %p) {
  %ptr = getelementptr inbounds %record, %record addrspace(1)* %arg0, i32 0, i32 1
  store i8 addrspace(1)* %p, i8 addrspace(1)* addrspace(1)* %ptr
  ret void
}

; CHECK: define internal void @test3(i8 addrspace(1)* %p)
define internal void @test3(%record addrspace(1)* %arg0, i8 addrspace(1)* %arg1, i8 addrspace(1)* %p) {
  %ptr = alloca i8 addrspace(1)*
  store i8 addrspace(1)* %p, i8 addrspace(1)** %ptr
  ret void
}

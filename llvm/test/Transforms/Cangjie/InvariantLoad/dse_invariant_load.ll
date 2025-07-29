; RUN: opt < %s -dse --cangjie-pipeline -S | FileCheck %s

; CHECK: store i32 %init, i32* %var.ptr, align 4
define i32 @test_invariant_load_dse_1(i32 noundef %init) local_unnamed_addr {
  %var.ptr = alloca i32, align 4
  store i32 %init, i32* %var.ptr, align 4
  %1 = load i32, i32* %var.ptr, align 4, !invariant.load !0
  ret i32 %1
}

declare i8 addrspace(1)* @fake_get_obj()
declare i8* @fake_get_typeinfo(i8**)

%fake_typeinfo = type { i8*, i8, i8, i16 }
@"fake_ti" = global %fake_typeinfo { i8* null, i8 0, i8 0, i16 0 }

; CHECK: store %fake_typeinfo* @fake_ti, %fake_typeinfo** %1, align 8
define i8* @test_invariant_load_dse_2() local_unnamed_addr {
  %1 = alloca %fake_typeinfo*, align 8
  %2 = alloca [1 x %fake_typeinfo*], align 8
  store %fake_typeinfo* @"fake_ti", %fake_typeinfo** %1, align 8
  %3 = call i8 addrspace(1)* @fake_get_obj()
  %4 = icmp eq i8 addrspace(1)* %3, null
  %5 = bitcast %fake_typeinfo** %1 to i8*
  %6 = addrspacecast i8* %5 to i8 addrspace(1)*
  %7 = select i1 %4, i8 addrspace(1)* %6, i8 addrspace(1)* %3
  %8 = bitcast i8 addrspace(1)* %7 to %fake_typeinfo* addrspace(1)*
  %9 = load %fake_typeinfo*, %fake_typeinfo* addrspace(1)* %8, align 8, !invariant.load !0
  %10 = getelementptr inbounds [1 x %fake_typeinfo*], [1 x %fake_typeinfo*]* %2, i64 0, i64 0
  store %fake_typeinfo* %9, %fake_typeinfo** %10, align 8
  %11 = bitcast [1 x %fake_typeinfo*]* %2 to i8**
  %12 = call i8* @fake_get_typeinfo(i8** %11)
  ret i8* %12
}

!0 = !{}
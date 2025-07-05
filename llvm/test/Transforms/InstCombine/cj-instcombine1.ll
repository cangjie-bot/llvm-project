; RUN: opt < %s -passes=instcombine -S | FileCheck %s

%"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE" = type { %"record._ZN7default11std$FS$core6OptionIcE", i8 addrspace(1)*, i8, i32, i16, double, i64 }
%"record._ZN7default11std$FS$core6OptionIcE" = type { i1, i32 }

declare void @llvm.memcpy.p0i8.p1i8.i64(i8*, i8 addrspace(1)*, i64, i1)

;CHECK-NOT: %1 = bitcast %"record._ZN7default11std$FS$core6OptionIcE" addrspace(1)* %"fld$0" to i8 addrspace(1)* addrspace(1)*

define weak_odr hidden void @foo(%"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE"* noalias sret(%"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE") %0, i8 addrspace(1)* %"fld$0$BP", %"record._ZN7default11std$FS$core6OptionIcE" addrspace(1)* %"fld$0", i8 addrspace(1)* %"fld$1", i8 %"fld$2", i32 %"fld$3", i16 %"fld$4", double %"fld$5", i64 %"fld$6") gc "cangjie" {
entry:
  %"fld$01" = getelementptr inbounds %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE", %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE"* %0, i32 0, i32 0
  %1 = bitcast %"record._ZN7default11std$FS$core6OptionIcE"* %"fld$01" to i8*
  %2 = bitcast %"record._ZN7default11std$FS$core6OptionIcE" addrspace(1)* %"fld$0" to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* align 4 %1, i8 addrspace(1)* align 4 %2, i64 8, i1 false)
  %"fld$12" = getelementptr inbounds %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE", %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE"* %0, i32 0, i32 1
  store i8 addrspace(1)* %"fld$1", i8 addrspace(1)** %"fld$12", align 8
  %"fld$23" = getelementptr inbounds %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE", %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE"* %0, i32 0, i32 2
  store i8 %"fld$2", i8* %"fld$23", align 1
  %"fld$34" = getelementptr inbounds %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE", %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE"* %0, i32 0, i32 3
  store i32 %"fld$3", i32* %"fld$34", align 4
  %"fld$45" = getelementptr inbounds %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE", %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE"* %0, i32 0, i32 4
  store i16 %"fld$4", i16* %"fld$45", align 2
  %"fld$56" = getelementptr inbounds %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE", %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE"* %0, i32 0, i32 5
  store double %"fld$5", double* %"fld$56", align 8
  %"fld$67" = getelementptr inbounds %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE", %"T7_N_ZN11std$FS$core6OptionIcEC_ZN7default21Class_1695327792688_9EactdlE"* %0, i32 0, i32 6
  store i64 %"fld$6", i64* %"fld$67", align 8
  ret void
}

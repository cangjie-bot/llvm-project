; RUN: opt < %s -passes=instcombine -S | FileCheck %s

%"record._ZN16models$FS$molnet10SquareLossE" = type { i1, i1 }
%"record._ZN16models$FS$molnet17WithForceLossCellE" = type { %"record._ZN16models$FS$molnet10SquareLossE", %"record._ZN16models$FS$molnet10SquareLossE", float, float, %"record._ZN16models$FS$molnet13MolCalculatorE" }
%"record._ZN16models$FS$molnet13MolCalculatorE" = type { %"record._ZN16models$FS$molnet6AirNetE", i1, float, float, i1, i1, i1, i64, %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16models$FS$molnet13AtomDistancesE" }
%"record._ZN16models$FS$molnet6AirNetE" = type { %"record._ZN16CangjieTB$FS$ops6TensorE", i1, i32, i1, i1, i1, float, i32, %"record._ZN16models$FS$molnet23LogGaussianDistributionE", i32, %"record._ZN16models$FS$molnet12SmoothCutoffE", i1, i64, %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16models$FS$molnet17AirNetInteractionE", %"record._ZN16models$FS$molnet17AirNetInteractionE", %"record._ZN16models$FS$molnet17AirNetInteractionE", %"record._ZN16models$FS$molnet15AtomwiseReadoutE", %"record._ZN22CangjieTB$FS$nn.layers9EmbeddingE", %"record._ZN16models$FS$molnet6FilterE" }
%"record._ZN16CangjieTB$FS$ops6TensorE" = type { i1, i32, i8 addrspace(1)* }
%"record._ZN16models$FS$molnet13AtomDistancesE" = type { i8 }
%"record._ZN16models$FS$molnet23LogGaussianDistributionE" = type { float, float, float, float, i1, i1, %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16CangjieTB$FS$ops6TensorE" }
%"record._ZN16models$FS$molnet12SmoothCutoffE" = type { float }
%"record._ZN16models$FS$molnet17AirNetInteractionE" = type { %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16CangjieTB$FS$ops6TensorE", i32, i1, float, i1, i1, i1, float, %"record._ZN22CangjieTB$FS$nn.layers5DenseE", %"record._ZN16models$FS$molnet19PositionalEmbeddingE", %"record._ZN16models$FS$molnet18MultiheadAttentionE", %"record._ZN22CangjieTB$FS$nn.layers5DenseE" }
%"record._ZN16models$FS$molnet15AtomwiseReadoutE" = type { i32, %"record._ZN16models$FS$molnet3MLPE" }
%"record._ZN22CangjieTB$FS$nn.layers9EmbeddingE" = type { %"record._ZN16CangjieTB$FS$ops6TensorE", i64, i64, i1 }
%"record._ZN16models$FS$molnet6FilterE" = type { i32, %"record._ZN16models$FS$molnet3MLPE", %"record._ZN22CangjieTB$FS$nn.layers5DenseE" }
%"record._ZN22CangjieTB$FS$nn.layers5DenseE" = type { %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16CangjieTB$FS$ops6TensorE", i1, %"record._ZN11std$FS$core6StringE" }
%"record._ZN16models$FS$molnet19PositionalEmbeddingE" = type { %"record._ZN16models$FS$molnet12MolLayerNormE", %"record._ZN22CangjieTB$FS$nn.layers5DenseE", %"record._ZN22CangjieTB$FS$nn.layers5DenseE", %"record._ZN22CangjieTB$FS$nn.layers5DenseE" }
%"record._ZN16models$FS$molnet18MultiheadAttentionE" = type { i64, %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16models$FS$molnet11std$FS$core5ArrayIlE", %"record._ZN16models$FS$molnet11std$FS$core5ArrayIlE", %"record._ZN22CangjieTB$FS$nn.layers5DenseE" }
%"record._ZN16models$FS$molnet3MLPE" = type { %"record._ZN22CangjieTB$FS$nn.layers5DenseE", %"record._ZN22CangjieTB$FS$nn.layers5DenseE" }
%"record._ZN11std$FS$core6StringE" = type { i8 addrspace(1)*, i64 }
%"record._ZN16models$FS$molnet12MolLayerNormE" = type { float, %"record._ZN16CangjieTB$FS$ops6TensorE", %"record._ZN16CangjieTB$FS$ops6TensorE" }
%"record._ZN16models$FS$molnet11std$FS$core5ArrayIlE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN16models$FS$molnet17WithForceLossCellEE" = type { %"record._ZN16models$FS$molnet10SquareLossE", %"record._ZN16models$FS$molnet10SquareLossE", %"record._ZN16models$FS$molnet10SquareLossE", %"record._ZN16models$FS$molnet10SquareLossE", float, float, %"record._ZN16models$FS$molnet13MolCalculatorE" }

declare void @"_ZN16models$FS$molnet10SquareLoss4initER_ZN11std$FS$core6StringE"(i8 addrspace(1)*, %"record._ZN16models$FS$molnet10SquareLossE" addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)
declare void @"_ZN16models$FS$molnet10SquareLoss4initER_ZN11std$FS$core6StringE$reduction_0v"(%"record._ZN11std$FS$core6StringE"*)
declare void @llvm.cj.memset.p0i8(i8*, i8, i64, i1)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1)
declare void @llvm.memcpy.p0i8.p1i8.i64(i8*, i8 addrspace(1)*, i64, i1)

;CHECK:      %24 = bitcast %"record._ZN16models$FS$molnet17WithForceLossCellEE"* %tmpsroa to i64*
;CHECK-NEXT: %25 = load i64, i64* %tmpsroatuple
;CHECK-NEXT: store i64 %25, i64* %24

define void @foo(%"record._ZN16models$FS$molnet17WithForceLossCellE"* noalias sret(%"record._ZN16models$FS$molnet17WithForceLossCellE") %0, %"record._ZN16models$FS$molnet17WithForceLossCellEE"* %tmpsroa, i8 addrspace(1)* %"backbone$BP", %"record._ZN16models$FS$molnet13MolCalculatorE" addrspace(1)* %backbone, i8 addrspace(1)* %"energyFn$BP", %"record._ZN16models$FS$molnet10SquareLossE" addrspace(1)* %energyFn, i8 addrspace(1)* %"forceFn$BP", %"record._ZN16models$FS$molnet10SquareLossE" addrspace(1)* %forceFn, float %ratioEnergy) gc "cangjie" {
entry:
  %tmpsroatuple = alloca i64, align 8
  %tuple.sroa.0 = alloca i32, align 8
  %tmpcast20 = bitcast i32* %tuple.sroa.0 to { %"record._ZN16models$FS$molnet10SquareLossE", %"record._ZN16models$FS$molnet10SquareLossE" }*
  %tuple.sroa.69 = alloca %"record._ZN16models$FS$molnet13MolCalculatorE", align 8
  %backbone_ = alloca %"record._ZN16models$FS$molnet13MolCalculatorE", align 8
  %1 = alloca %"record._ZN16models$FS$molnet13MolCalculatorE", align 8
  %forceFn_18 = alloca i16, align 8
  %2 = alloca i16, align 8
  %tmpcast17 = bitcast i16* %2 to %"record._ZN16models$FS$molnet10SquareLossE"*
  %callRet5 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %energyFn_15 = alloca i16, align 8
  %3 = alloca i16, align 8
  %tmpcast = bitcast i16* %3 to %"record._ZN16models$FS$molnet10SquareLossE"*
  %callRet = alloca %"record._ZN11std$FS$core6StringE", align 8
  %4 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %4, i8 0, i64 16, i1 false)
  call void @"_ZN16models$FS$molnet10SquareLoss4initER_ZN11std$FS$core6StringE$reduction_0v"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet)
  store i16 0, i16* %3, align 8
  store i64 8888, i64* %tmpsroatuple, align 8
  %5 = addrspacecast %"record._ZN16models$FS$molnet10SquareLossE"* %tmpcast to %"record._ZN16models$FS$molnet10SquareLossE" addrspace(1)*
  %6 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  call void @"_ZN16models$FS$molnet10SquareLoss4initER_ZN11std$FS$core6StringE"(i8 addrspace(1)* null, %"record._ZN16models$FS$molnet10SquareLossE" addrspace(1)* %5, i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %6)
  %7 = load i16, i16* %3, align 8
  store i16 %7, i16* %energyFn_15, align 8
  %8 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet5 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %8, i8 0, i64 16, i1 false)
  call void @"_ZN16models$FS$molnet10SquareLoss4initER_ZN11std$FS$core6StringE$reduction_0v"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet5)
  store i16 0, i16* %2, align 8
  %9 = addrspacecast %"record._ZN16models$FS$molnet10SquareLossE"* %tmpcast17 to %"record._ZN16models$FS$molnet10SquareLossE" addrspace(1)*
  %10 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet5 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  call void @"_ZN16models$FS$molnet10SquareLoss4initER_ZN11std$FS$core6StringE"(i8 addrspace(1)* null, %"record._ZN16models$FS$molnet10SquareLossE" addrspace(1)* %9, i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %10)
  %11 = load i16, i16* %2, align 8
  store i16 %11, i16* %forceFn_18, align 8
  %backbone_.0.backbone_.0..sroa_cast = bitcast %"record._ZN16models$FS$molnet13MolCalculatorE"* %backbone_ to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %backbone_.0.backbone_.0..sroa_cast, i8 0, i64 2224, i1 false)
  %.0..sroa_cast = bitcast %"record._ZN16models$FS$molnet13MolCalculatorE"* %1 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %.0..sroa_cast, i8 0, i64 2224, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(2224) %backbone_.0.backbone_.0..sroa_cast, i8* noundef nonnull align 8 dereferenceable(2224) %.0..sroa_cast, i64 2224, i1 false)
  %12 = bitcast %"record._ZN16models$FS$molnet13MolCalculatorE" addrspace(1)* %backbone to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(2224) %backbone_.0.backbone_.0..sroa_cast, i8 addrspace(1)* noundef align 8 dereferenceable(2224) %12, i64 2224, i1 false)
  %13 = bitcast %"record._ZN16models$FS$molnet10SquareLossE" addrspace(1)* %energyFn to i16 addrspace(1)*
  %14 = load i16, i16 addrspace(1)* %13, align 1
  store i16 %14, i16* %energyFn_15, align 8
  %15 = bitcast %"record._ZN16models$FS$molnet10SquareLossE" addrspace(1)* %forceFn to i16 addrspace(1)*
  %16 = load i16, i16 addrspace(1)* %15, align 1
  store i16 %16, i16* %forceFn_18, align 8
  %sub = fsub float 1.000000e+00, %ratioEnergy
  %tuple.sroa.0.0..sroa_cast14 = bitcast i32* %tuple.sroa.0 to i8*
  store i32 0, i32* %tuple.sroa.0, align 8
  %tuple.sroa.69.0..sroa_cast13 = bitcast %"record._ZN16models$FS$molnet13MolCalculatorE"* %tuple.sroa.69 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %tuple.sroa.69.0..sroa_cast13, i8 0, i64 2224, i1 false)
  %17 = bitcast i32* %tuple.sroa.0 to i16*
  %18 = load i16, i16* %energyFn_15, align 8
  store i16 %18, i16* %17, align 8
  %tuple.sroa.0.2..sroa_idx = getelementptr inbounds { %"record._ZN16models$FS$molnet10SquareLossE", %"record._ZN16models$FS$molnet10SquareLossE" }, { %"record._ZN16models$FS$molnet10SquareLossE", %"record._ZN16models$FS$molnet10SquareLossE" }* %tmpcast20, i64 0, i32 1
  %19 = bitcast %"record._ZN16models$FS$molnet10SquareLossE"* %tuple.sroa.0.2..sroa_idx to i16*
  %20 = load i16, i16* %forceFn_18, align 8
  store i16 %20, i16* %19, align 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(2224) %tuple.sroa.69.0..sroa_cast13, i8* noundef nonnull align 8 dereferenceable(2224) %backbone_.0.backbone_.0..sroa_cast, i64 2224, i1 false)
  %21 = bitcast %"record._ZN16models$FS$molnet17WithForceLossCellE"* %0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %21, i8* align 8 %tuple.sroa.0.0..sroa_cast14, i64 4, i1 false)
  %tmpsroa.0 = bitcast %"record._ZN16models$FS$molnet17WithForceLossCellEE"* %tmpsroa to i8*
  %tmpsroatuple.0 = bitcast i64* %tmpsroatuple to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %tmpsroa.0, i8* align 8 %tmpsroatuple.0, i64 8, i1 false)
  %tuple.sroa.4.0..sroa_idx6 = getelementptr inbounds %"record._ZN16models$FS$molnet17WithForceLossCellE", %"record._ZN16models$FS$molnet17WithForceLossCellE"* %0, i64 0, i32 2
  store float %ratioEnergy, float* %tuple.sroa.4.0..sroa_idx6, align 4
  %tuple.sroa.5.0..sroa_idx7 = getelementptr inbounds %"record._ZN16models$FS$molnet17WithForceLossCellE", %"record._ZN16models$FS$molnet17WithForceLossCellE"* %0, i64 0, i32 3
  store float %sub, float* %tuple.sroa.5.0..sroa_idx7, align 8
  %tuple.sroa.6.0..sroa_idx = getelementptr inbounds i8, i8* %21, i64 12
  %tuple.sroa.6.0..sroa_cast8 = bitcast i8* %tuple.sroa.6.0..sroa_idx to i32*
  store i32 0, i32* %tuple.sroa.6.0..sroa_cast8, align 4
  %tuple.sroa.69.0..sroa_idx = getelementptr inbounds %"record._ZN16models$FS$molnet17WithForceLossCellE", %"record._ZN16models$FS$molnet17WithForceLossCellE"* %0, i64 0, i32 4
  %tuple.sroa.69.0..sroa_cast10 = bitcast %"record._ZN16models$FS$molnet13MolCalculatorE"* %tuple.sroa.69.0..sroa_idx to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %tuple.sroa.69.0..sroa_cast10, i8* align 8 %tuple.sroa.69.0..sroa_cast13, i64 2224, i1 false)
  ret void
}

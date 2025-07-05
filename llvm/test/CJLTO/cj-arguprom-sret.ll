; RUN: opt < %s --cangjie-pipeline --passes=argpromotion -S | FileCheck %s

define internal void @add(i32* sret(i32) %r, {i32, i32}* %this) gc "cangjie" {
; CHECK-LABEL: @add(
; CHECK-NEXT:    [[AB:%.*]] = add i32 [[THIS_0_VAL:%.*]], [[THIS_4_VAL:%.*]]
; CHECK-NEXT:    store i32 [[AB]], i32* [[R:%.*]], align 4
; CHECK-NEXT:    ret void
;
  %ap = getelementptr {i32, i32}, {i32, i32}* %this, i32 0, i32 0
  %bp = getelementptr {i32, i32}, {i32, i32}* %this, i32 0, i32 1
  %a = load i32, i32* %ap
  %b = load i32, i32* %bp
  %ab = add i32 %a, %b
  store i32 %ab, i32* %r
  ret void
}

define void @f() gc "cangjie" {
; CHECK-LABEL: @f(
; CHECK-NEXT:    [[R:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[PAIR:%.*]] = alloca { i32, i32 }, align 8
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr { i32, i32 }, { i32, i32 }* [[PAIR]], i64 0, i32 0
; CHECK-NEXT:    [[PAIR_VAL:%.*]] = load i32, i32* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr { i32, i32 }, { i32, i32 }* [[PAIR]], i64 0, i32 1
; CHECK-NEXT:    [[PAIR_VAL1:%.*]] = load i32, i32* [[TMP2]], align 4
; CHECK-NEXT:    call void @add(i32* sret(i32) [[R]], i32 [[PAIR_VAL]], i32 [[PAIR_VAL1]])
; CHECK-NEXT:    ret void
;
  %r = alloca i32
  %pair = alloca {i32, i32}

  call void @add(i32* sret(i32) %r, {i32, i32}* %pair)
  ret void
}
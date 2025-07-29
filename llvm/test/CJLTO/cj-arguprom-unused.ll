; RUN: opt < %s --cangjie-pipeline --passes=argpromotion -S | FileCheck %s

%record = type { i8 addrspace(1)*, i64 }

define internal i64 @callee(i1 %c, i1 %d, i8 addrspace(1)* %unused, %record addrspace(1)* %used) gc "cangjie" {
; CHECK-LABEL: @callee(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = getelementptr [[RECORD:%.*]], [[RECORD]] addrspace(1)* [[USED:%.*]], i64 0, i32 1
; CHECK-NEXT:    [[Y:%.*]] = load i64, i64 addrspace(1)* [[X]], align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    ret i64 [[Y]]
; CHECK:       else:
; CHECK-NEXT:    ret i64 -1
;
entry:
  %x = getelementptr %record, %record addrspace(1)* %used, i64 0, i32 1
  %y = load i64, i64 addrspace(1)* %x
  br i1 %c, label %if, label %else

if:
  ret i64 %y

else:
  ret i64 -1
}

define i32 @caller(i1 %c, i1 %d, i8 addrspace(1)* %0, %record addrspace(1)* %1) gc "cangjie" {
; CHECK-LABEL: @caller(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @callee(i1 [[C:%.*]], i1 [[D:%.*]], i8 addrspace(1)* [[TMP0:%.*]], [[RECORD:%.*]] addrspace(1)* [[TMP1:%.*]])
; CHECK-NEXT:    ret i32 1
;
entry:
  call i64 @callee(i1 %c, i1 %d, i8 addrspace(1)* %0, %record addrspace(1)* %1)
  ret i32 1
}

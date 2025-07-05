; RUN: not not opt --cj-barrier-opt -S < %s -disable-output 2>&1 | FileCheck %s -check-prefixes=ABORT

%record3 = type { i32, i8 addrspace(1)* }
%record2 = type { i32, %record3 }
%record1 = type { i32, i8 addrspace(1)*, %record2 }

%BitMap = type { i32, [0 x i8] }
%KlassInfo.0 = type { i32, i32, %BitMap*, %KlassInfo.0*, i8**, i64*, i64*, i64*, i32, [0 x %KlassInfo.0*] }
%KlassInfo.1 = type { i32, i32, %BitMap*, %KlassInfo.0*, i8**, i64*, i64*, i64*, i32, [1 x %KlassInfo.0*] }
@"Klass1.objKlass" = external global %KlassInfo.1
@Global0 = internal global %record3 zeroinitializer
@"Klass0.objKlass" = external global %KlassInfo.0

declare void @llvm.memcpy.p0p1i8.p0p1i8.i64(i8 addrspace(1)** noalias nocapture writeonly, i8 addrspace(1)** noalias nocapture readonly, i64, i1 immarg)
declare void @llvm.memcpy.p1i8.p1i8.i64(i8 addrspace(1)* noalias nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64, i1 immarg)
declare i1 @CJ_MCC_IsInstanceOf(i8 addrspace(1)*, i8*) #1
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)
declare cangjiegccc void @MCC_SafepointStub()
declare i32 @personality_function()
declare i8 addrspace(1)* @CJ_MCC_BeginCatch(i8*)
declare void @CJ_MCC_EndCatch()
declare void @CJ_MCC_ThrowException(i8 addrspace(1)*)
declare i8* @CJ_MCC_GetExceptionWrapper()
declare i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8*, i32)

define void @foo1(i8 addrspace(1)* %this, %record3 addrspace(1)* %0) #0 gc "cangjie" personality i32 ()* @personality_function {
entry:
  %test0 = alloca %record3
  %test1 = bitcast %record3* %test0 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %test1, i8 0, i64 32, i1 false)
  %test2 = load i8, i8 addrspace(1)* %this
  %cond = icmp ne i8 %test2, 0
  br i1 %cond, label %if, label %else

if:                                        ; preds = %entry
  %test3 = getelementptr inbounds %record3, %record3* %test0, i64 0, i32 1
  br label %thunk

else:                                        ; preds = %entry
  %test4.0 = invoke i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"Klass0.objKlass" to i8*), i32 56)
                     to label %thunk0 unwind label %finallyOne

thunk0:                                        ; preds = %else
  %test4.1 = bitcast i8 addrspace(1)* %test4.0 to %record3 addrspace(1)*
  %test4.2 = addrspacecast %record3 addrspace(1)* %test4.1 to %record3*
  %test4 = getelementptr inbounds %record3, %record3* %test4.2, i64 0, i32 1
  br label %thunk

thunk:                                        ; preds = %if, %thunk0
  %test5 = phi i8 addrspace(1)** [ %test3, %if ], [ %test4, %thunk0 ]
  br label %body

body:                                         ; preds = %thunk, %body
  %test = phi i8 [%test2, %thunk], [%test.1, %body]
  %1 = bitcast i8 addrspace(1)* %this to %record1 addrspace(1)*
  %2 = getelementptr inbounds %record1, %record1 addrspace(1)* %1, i32 0, i32 2
  %3 = getelementptr inbounds %record2, %record2 addrspace(1)* %2, i32 0, i32 1
  %4 = bitcast  %record3 addrspace(1)* %3 to i8 addrspace(1)*
  %5 = bitcast  %record3 addrspace(1)* %0 to i8 addrspace(1)*
  call void @llvm.memcpy.p1i8.p1i8.i64(i8 addrspace(1)* align 8 %4, i8 addrspace(1)* align 8 %5, i64 8, i1 false)
  %6 = getelementptr inbounds %record3, %record3 addrspace(1)* %0, i64 0, i32 1
  %7 = addrspacecast i8 addrspace(1)* addrspace(1)* %6 to i8 addrspace(1)**
  call void @llvm.memcpy.p0p1i8.p0p1i8.i64(i8 addrspace(1)** align 8 %test5, i8 addrspace(1)** align 8 %7, i64 8, i1 false)
  %cond1 = icmp eq i8 %test, 0
  %test.1 = add i8 %test, 1
  call cangjiegccc void @MCC_SafepointStub()
  br i1 %cond1, label %body, label %end

end:                                         ; preds = %body
  ret void

finallyOne:                                 ; preds = %else
  %8 = landingpad token
       catch i8* bitcast (%KlassInfo.0* @"Klass0.objKlass" to i8*)
       catch i8* null
  %9 = call i8* @CJ_MCC_GetExceptionWrapper()
  %10 = call i8 addrspace(1)* @CJ_MCC_BeginCatch(i8* %9)
  call void @CJ_MCC_EndCatch()
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %10)
  unreachable
}

; ABORT: LLVM ERROR: Need write barrier in function
; ABORT: error: Aborted

attributes #0 = { "hasRcdParam" }
attributes #1 = { "cj-runtime" "gc-leaf-function" }
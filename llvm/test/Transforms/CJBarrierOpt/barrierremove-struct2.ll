; RUN: opt -enable-new-pm=false --cj-barrier-opt -S < %s | FileCheck %s
; RUN: opt -passes=cj-barrier-opt -S < %s | FileCheck %s

%"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" = type { i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE", i64, i64, i1, i64 }
%"record._ZN11std$FS$core6StringE" = type { %"record._ZN11std$FS$core5ArrayIhE", i64 }
%"record._ZN11std$FS$core5ArrayIhE" = type { i8 addrspace(1)*, i64, i64 }
%"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" = type { %"ObjLayout._ZN11std$FS$core6ObjectE", i64, i64, i64, i64, %"record._ZN11std$FS$core5ArrayIlE", %"record._ZN11std$FS$core5ArrayIT4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEEE" }
%"ObjLayout._ZN11std$FS$core6ObjectE" = type { %ObjLayout.Object }
%ObjLayout.Object = type { %KlassInfo.0* }
%KlassInfo.0 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i8*, i64*, i32, [0 x i8*] }
%BitMap = type { i32, [0 x i8] }
%"record._ZN11std$FS$core5ArrayIlE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN11std$FS$core5ArrayIT4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEEE" = type { i8 addrspace(1)*, i64, i64 }
%"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" = type { %ArrayBase, [0 x %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"] }
%ArrayBase = type { %ObjLayout.Object, i64 }
%"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" = type { i64, i64, %"record._ZN11std$FS$core6StringE", i8 addrspace(1)* }
%ArrayLayout.Int64 = type { %ArrayBase, [0 x i64] }
%KlassInfo.1 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i8*, i64*, i32, [1 x i8*] }
%"_ZN11std$FS$core6ObjectE.objKlass.reflectType" = type { i32, i32, i32, i32, i32, i8*, i32, i32, void (i8 addrspace(1)*)*, [5 x i8]*, [2 x i8]*, %"_ZN11std$FS$core6ObjectE.objKlass.0.init.ParamInfoType"*, %KlassInfo.1*, i8* }
%"_ZN11std$FS$core6ObjectE.objKlass.0.init.ParamInfoType" = type { i32, [26 x i8]*, [7 x i8]*, i8* }
%"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.reflectType" = type { i32, i32, i32, i32, i32, i8*, i32, i32, void (i8 addrspace(1)*)*, [5 x i8]*, [2 x i8]*, %"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.0.init.ParamInfoType"*, %KlassInfo.0*, i8*, i32, i32, void (i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)*, [5 x i8]*, [2 x i8]*, %"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.1.init.ParamInfoType"*, %KlassInfo.0*, i8* }
%"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.0.init.ParamInfoType" = type { i32, [46 x i8]*, [26 x i8]*, i8* }
%"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.1.init.ParamInfoType" = type { i32, [46 x i8]*, [26 x i8]*, i8*, i32, [26 x i8]*, [8 x i8]*, i8* }
%"_ZN11std$FS$core9ExceptionE.objKlass.reflectType" = type { i32, i32, i32, i32, i32, i8*, i32, i32, void (i8 addrspace(1)*)*, [5 x i8]*, [2 x i8]*, %"_ZN11std$FS$core9ExceptionE.objKlass.0.init.ParamInfoType"*, %KlassInfo.1*, i8*, i32, i32, void (i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)*, [5 x i8]*, [2 x i8]*, %"_ZN11std$FS$core9ExceptionE.objKlass.1.init.ParamInfoType"*, %KlassInfo.1*, i8*, i32, i32, void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)*, [12 x i8]*, [26 x i8]*, %"_ZN11std$FS$core9ExceptionE.objKlass.2.$messageget.ParamInfoType"*, %KlassInfo.1*, i8*, i32, i32, void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)*, [9 x i8]*, [26 x i8]*, %"_ZN11std$FS$core9ExceptionE.objKlass.3.toString.ParamInfoType"*, %KlassInfo.1*, i8*, i32, i32, void (%Unit.Type*, i8 addrspace(1)*)*, [16 x i8]*, [2 x i8]*, %"_ZN11std$FS$core9ExceptionE.objKlass.4.printStackTrace.ParamInfoType"*, %KlassInfo.1*, i8*, i32, i32, void (%"record._ZN11std$FS$core5ArrayIC_ZN11std$FS$core17StackTraceElementEE"*, i8 addrspace(1)*)*, [14 x i8]*, [63 x i8]*, %"_ZN11std$FS$core9ExceptionE.objKlass.5.getStackTrace.ParamInfoType"*, %KlassInfo.1*, i8* }
%"_ZN11std$FS$core9ExceptionE.objKlass.0.init.ParamInfoType" = type { i32, [29 x i8]*, [10 x i8]*, i8* }
%"_ZN11std$FS$core9ExceptionE.objKlass.1.init.ParamInfoType" = type { i32, [29 x i8]*, [10 x i8]*, i8*, i32, [26 x i8]*, [8 x i8]*, i8* }
%"_ZN11std$FS$core9ExceptionE.objKlass.2.$messageget.ParamInfoType" = type { i32, [29 x i8]*, [10 x i8]*, i8* }
%"_ZN11std$FS$core9ExceptionE.objKlass.3.toString.ParamInfoType" = type { i32, [29 x i8]*, [10 x i8]*, i8* }
%"_ZN11std$FS$core9ExceptionE.objKlass.4.printStackTrace.ParamInfoType" = type { i32, [29 x i8]*, [10 x i8]*, i8* }
%"_ZN11std$FS$core9ExceptionE.objKlass.5.getStackTrace.ParamInfoType" = type { i32, [29 x i8]*, [10 x i8]*, i8* }
%"record._ZN11std$FS$core5ArrayIC_ZN11std$FS$core17StackTraceElementEE" = type { i8 addrspace(1)*, i64, i64 }
%Unit.Type = type { i8 }
%"_ZN11std$FS$core3AnyE.objKlass.reflectType" = type { i32, i32, i32, i32, i32, i8* }
%"_ZN11std$FS$core8ToStringE.objKlass.reflectType" = type { i32, i32, i32, i32, i32, i8*, i32, i32, i8*, [9 x i8]*, [26 x i8]*, %"_ZN11std$FS$core8ToStringE.objKlass.0.toString.ParamInfoType"*, %KlassInfo.0*, i8* }
%"_ZN11std$FS$core8ToStringE.objKlass.0.toString.ParamInfoType" = type { i32, [28 x i8]*, [9 x i8]*, i8* }
%"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.reflectType" = type { i32, i32, i32, i32, i32, i8*, i32, i32, void (i8 addrspace(1)*)*, [5 x i8]*, [2 x i8]*, %"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.0.init.ParamInfoType"*, %KlassInfo.0*, i8*, i32, i32, void (i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)*, [5 x i8]*, [2 x i8]*, %"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.1.init.ParamInfoType"*, %KlassInfo.0*, i8* }
%"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.1.init.ParamInfoType" = type { i32, [58 x i8]*, [32 x i8]*, i8*, i32, [26 x i8]*, [8 x i8]*, i8* }
%"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.0.init.ParamInfoType" = type { i32, [58 x i8]*, [32 x i8]*, i8* }

@"$const_cjstring.8" = internal constant { { i8 addrspace(1)*, i64, i64 }, i64 } { { i8 addrspace(1)*, i64, i64 } { i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [1709 x i8] }* @"$const_cjstring_data.0.3" to i8*) to i8 addrspace(1)*), i64 969, i64 3 }, i64 0 }
@"$const_cjstring.7.2" = internal constant { { i8 addrspace(1)*, i64, i64 }, i64 } { { i8 addrspace(1)*, i64, i64 } { i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [1709 x i8] }* @"$const_cjstring_data.0.3" to i8*) to i8 addrspace(1)*), i64 574, i64 3 }, i64 0 }
@"$const_cjstring_data.0.312" = internal constant { i8*, i64, [31 x i8] } { i8* bitcast (%KlassInfo.0* @roUInt8.arrayKlass to i8*), i64 31, [31 x i8] c"ConcurrentModificationException" }
@roUInt8.arrayKlass = internal global %KlassInfo.0 { i32 2, i32 1, %BitMap* null, i8* bitcast (%KlassInfo.0* @array_int8.primKlass to i8*), i8** null, i64* null, i64* null, i8* null, i64* null, i32 0, [0 x i8*] zeroinitializer }
@array_int8.primKlass = internal global %KlassInfo.0 { i32 1, i32 1, %BitMap* null, i8* null, i8** null, i64* null, i64* null, i8* null, i64* @array_int8.uniqueAddr, i32 0, [0 x i8*] zeroinitializer }
@array_int8.uniqueAddr = internal global i64 0
@"$const_cjstring_data.0.3" = internal constant { i8*, i64, [1709 x i8] } { i8* bitcast (%KlassInfo.0* @roUInt8.arrayKlass to i8*), i64 1709, [1709 x i8] c"The result would be less than UIntNative.Min.[ parameter out of range  stop:Json String is empty!the json data is Non-standard, please check:\0AParse Error: [Line]: The Value of JsonObject does not existFail to convert to JsonFloat is not equal to array size:Array negative index accessOvershift: Value of right operand is greater than or equal to the width of left operand!Negative copy length\\0Fail to convert to JsonArray, [Pos]: \\vDstStart is greater than or equal to the size of the target arrayJsonExceptionOvershift: Negative shift count!Fail to convert to JsonString\\fadd, length is nullCasting Infinite or NaN value to integer., but the start is , [Error]: Unexpected character: 'Fail to convert to JsonNullFail to parseJsonStringFail to convert to JsonObjectIllegal step SrcStart is greater than or equal to the size of this array\\rThe result would be less than UInt32.Min.The size of Array is the value of the step should not be zero.\0AThe size of ArrayList is sub, start: and the end is Copy length out of boundsThe index \\ntrueThe result would be less than UInt8.Min.invalid size of ArrayList: falseThe result would be greater than UInt8.Max.mulThe result would be greater than Int64.Max.The result would be greater than UInt32.Max.When step is '.this data is not DataModelSeqin Char(num), num is not a valid Unicode scalar value!The result would be less than Int64.Min. of JsonArray does not exist.the value of the step should be '1'Fail to convert to JsonIntindex: \\b, size: invalid capacity of ArrayList: The result would be greater than UIntNative.Max.[]invalid size of HashMap: Value does not exist!\0AUnmatched DataModel type!, step should be 1\\tRange size:Fail to convert to JsonBool, start is " }
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" = internal global %KlassInfo.0 { i32 36, i32 72, %BitMap* inttoptr (i64 -9223372036854775710 to %BitMap*), i8* bitcast (%KlassInfo.1* @"_ZN11std$FS$core9ExceptionE.objKlass" to i8*), i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.vtable", i32 0, i32 0), i64* bitcast ({ [23 x i8*], i32* }* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.itable" to i64*), i64* null, i8* bitcast (%"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.reflectType"* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.reflect" to i8*), i64* bitcast ([46 x i8]* @"C_ZN11std$FS$core25IndexOutOfBoundsExceptionE.typeName" to i64*), i32 0, [0 x i8*] zeroinitializer }
@"_ZN11std$FS$core9ExceptionE.objKlass" = internal global %KlassInfo.1 { i32 36, i32 72, %BitMap* inttoptr (i64 -9223372036854775710 to %BitMap*), i8* bitcast (%KlassInfo.1* @"_ZN11std$FS$core6ObjectE.objKlass" to i8*), i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @"_ZN11std$FS$core9ExceptionE.vtable", i32 0, i32 0), i64* bitcast ({ [23 x i8*], i32* }* @"_ZN11std$FS$core9ExceptionE.itable" to i64*), i64* null, i8* bitcast (%"_ZN11std$FS$core9ExceptionE.objKlass.reflectType"* @"_ZN11std$FS$core9ExceptionE.objKlass.reflect" to i8*), i64* bitcast ([29 x i8]* @"C_ZN11std$FS$core9ExceptionE.typeName" to i64*), i32 1, [1 x i8*] [i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core8ToStringE.objKlass" to i8*)] }
@"_ZN11std$FS$core6ObjectE.objKlass" = internal global %KlassInfo.1 { i32 4, i32 8, %BitMap* inttoptr (i64 -9223372036854775808 to %BitMap*), i8* bitcast (%KlassInfo.0* @Object.objKlass to i8*), i8** getelementptr inbounds ([1 x i8*], [1 x i8*]* @"_ZN11std$FS$core6ObjectE.vtable", i32 0, i32 0), i64* bitcast (i64** @"_ZN11std$FS$core6ObjectE.itable" to i64*), i64* null, i8* bitcast (%"_ZN11std$FS$core6ObjectE.objKlass.reflectType"* @"_ZN11std$FS$core6ObjectE.objKlass.reflect" to i8*), i64* bitcast ([26 x i8]* @"C_ZN11std$FS$core6ObjectE.typeName" to i64*), i32 1, [1 x i8*] [i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core3AnyE.objKlass" to i8*)] }
@Object.objKlass = internal global %KlassInfo.0 { i32 4, i32 8, %BitMap* inttoptr (i64 -9223372036854775808 to %BitMap*), i8* null, i8** null, i64* null, i64* null, i8* null, i64* null, i32 0, [0 x i8*] zeroinitializer }
@"_ZN11std$FS$core6ObjectE.vtable" = internal global [1 x i8*] zeroinitializer
@"_ZN11std$FS$core6ObjectE.itable" = internal global i64* null
@"_ZN11std$FS$core6ObjectE.objKlass.reflect" = internal global %"_ZN11std$FS$core6ObjectE.objKlass.reflectType" { i32 72, i32 0, i32 0, i32 1, i32 0, i8* null, i32 8, i32 1, void (i8 addrspace(1)*)* @"_ZN11std$FS$core6Object6<init>Ev", [5 x i8]* @init.ReflectStr.396, [2 x i8]* @u.ReflectStr.397, %"_ZN11std$FS$core6ObjectE.objKlass.0.init.ParamInfoType"* @"_ZN11std$FS$core6ObjectE.objKlass.0.init.ParamInfo", %KlassInfo.1* @"_ZN11std$FS$core6ObjectE.objKlass", i8* null }
@"C_ZN11std$FS$core25IndexOutOfBoundsExceptionE.typeName" = internal global [46 x i8] c"C_ZN11std$FS$core25IndexOutOfBoundsExceptionE\00", align 1
@"C_ZN11std$FS$core6ObjectE.typeName" = internal global [26 x i8] c"C_ZN11std$FS$core6ObjectE\00", align 1
@"C_ZN11std$FS$core9ExceptionE.typeName" = internal global [29 x i8] c"C_ZN11std$FS$core9ExceptionE\00", align 1
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.itable" = internal global { [23 x i8*], i32* } { [23 x i8*] [i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception8toStringEv" to i8*), i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null], i32* null }
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.reflect" = internal global %"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.reflectType" { i32 8, i32 0, i32 0, i32 2, i32 0, i8* null, i32 8, i32 1, void (i8 addrspace(1)*)* @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>Ev", [5 x i8]* @init.ReflectStr.396, [2 x i8]* @u.ReflectStr.397, %"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.0.init.ParamInfoType"* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.0.init.ParamInfo", %KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass", i8* null, i32 8, i32 2, void (i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)* @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>ER_ZN11std$FS$core6StringE", [5 x i8]* @init.ReflectStr.396, [2 x i8]* @u.ReflectStr.397, %"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.1.init.ParamInfoType"* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.1.init.ParamInfo", %KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass", i8* null }
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.0.init.ParamInfo" = internal global %"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.0.init.ParamInfoType" { i32 0, [46 x i8]* @"C_ZN11std$FS$core25IndexOutOfBoundsExceptionE.ReflectStr", [26 x i8]* @IndexOutOfBoundsException.ReflectStr, i8* null }
@"C_ZN11std$FS$core25IndexOutOfBoundsExceptionE.ReflectStr" = internal global [46 x i8] c"C_ZN11std$FS$core25IndexOutOfBoundsExceptionE\00", align 1
@IndexOutOfBoundsException.ReflectStr = internal global [26 x i8] c"IndexOutOfBoundsException\00", align 1
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.1.init.ParamInfo" = internal global %"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass.1.init.ParamInfoType" { i32 0, [46 x i8]* @"C_ZN11std$FS$core25IndexOutOfBoundsExceptionE.ReflectStr", [26 x i8]* @IndexOutOfBoundsException.ReflectStr, i8* null, i32 1, [26 x i8]* @"R_ZN11std$FS$core6StringE.ReflectStr.398", [8 x i8]* @message.ReflectStr.399, i8* null }
@"R_ZN11std$FS$core6StringE.ReflectStr.398" = internal global [26 x i8] c"R_ZN11std$FS$core6StringE\00", align 1
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.vtable" = internal global [4 x i8*] [i8* null, i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core25IndexOutOfBoundsException12getClassNameEv" to i8*), i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception11$messagegetEv" to i8*), i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception8toStringEv" to i8*)]
@"_ZN11std$FS$core3AnyE.objKlass" = internal global %KlassInfo.0 { i32 16, i32 8, %BitMap* inttoptr (i64 -9223372036854775808 to %BitMap*), i8* null, i8** null, i64* null, i64* null, i8* bitcast (%"_ZN11std$FS$core3AnyE.objKlass.reflectType"* @"_ZN11std$FS$core3AnyE.objKlass.reflect" to i8*), i64* bitcast ([23 x i8]* @"C_ZN11std$FS$core3AnyE.typeName" to i64*), i32 0, [0 x i8*] zeroinitializer }
@"C_ZN11std$FS$core3AnyE.typeName" = internal global [23 x i8] c"C_ZN11std$FS$core3AnyE\00", align 1
@"_ZN11std$FS$core3AnyE.objKlass.reflect" = internal global %"_ZN11std$FS$core3AnyE.objKlass.reflectType" { i32 72, i32 0, i32 0, i32 0, i32 0, i8* null }
@"_ZN11std$FS$core6ObjectE.objKlass.0.init.ParamInfo" = internal global %"_ZN11std$FS$core6ObjectE.objKlass.0.init.ParamInfoType" { i32 0, [26 x i8]* @"C_ZN11std$FS$core6ObjectE.ReflectStr.413", [7 x i8]* @Object.ReflectStr, i8* null }
@"C_ZN11std$FS$core6ObjectE.ReflectStr.413" = internal global [26 x i8] c"C_ZN11std$FS$core6ObjectE\00", align 1
@Object.ReflectStr = internal global [7 x i8] c"Object\00", align 1
@"_ZN11std$FS$core8ToStringE.objKlass" = internal global %KlassInfo.0 { i32 16, i32 8, %BitMap* inttoptr (i64 -9223372036854775808 to %BitMap*), i8* null, i8** null, i64* null, i64* null, i8* bitcast (%"_ZN11std$FS$core8ToStringE.objKlass.reflectType"* @"_ZN11std$FS$core8ToStringE.objKlass.reflect" to i8*), i64* bitcast ([28 x i8]* @"C_ZN11std$FS$core8ToStringE.typeName" to i64*), i32 0, [0 x i8*] zeroinitializer }
@"C_ZN11std$FS$core8ToStringE.typeName" = internal global [28 x i8] c"C_ZN11std$FS$core8ToStringE\00", align 1
@"_ZN11std$FS$core8ToStringE.objKlass.reflect" = internal global %"_ZN11std$FS$core8ToStringE.objKlass.reflectType" { i32 72, i32 0, i32 0, i32 1, i32 0, i8* null, i32 584, i32 1, i8* null, [9 x i8]* @toString.ReflectStr.408, [26 x i8]* @"R_ZN11std$FS$core6StringE.ReflectStr.398", %"_ZN11std$FS$core8ToStringE.objKlass.0.toString.ParamInfoType"* @"_ZN11std$FS$core8ToStringE.objKlass.0.toString.ParamInfo", %KlassInfo.0* @"_ZN11std$FS$core8ToStringE.objKlass", i8* null }
@"_ZN11std$FS$core8ToStringE.objKlass.0.toString.ParamInfo" = internal global %"_ZN11std$FS$core8ToStringE.objKlass.0.toString.ParamInfoType" { i32 0, [28 x i8]* @"C_ZN11std$FS$core8ToStringE.ReflectStr", [9 x i8]* @ToString.ReflectStr, i8* null }
@"C_ZN11std$FS$core8ToStringE.ReflectStr" = internal global [28 x i8] c"C_ZN11std$FS$core8ToStringE\00", align 1
@ToString.ReflectStr = internal global [9 x i8] c"ToString\00", align 1
@"_ZN11std$FS$core9ExceptionE.itable" = internal global { [23 x i8*], i32* } { [23 x i8*] [i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception8toStringEv" to i8*), i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null], i32* null }
@"_ZN11std$FS$core9ExceptionE.objKlass.reflect" = internal global %"_ZN11std$FS$core9ExceptionE.objKlass.reflectType" { i32 72, i32 0, i32 0, i32 6, i32 0, i8* null, i32 8, i32 1, void (i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception6<init>Ev", [5 x i8]* @init.ReflectStr.396, [2 x i8]* @u.ReflectStr.397, %"_ZN11std$FS$core9ExceptionE.objKlass.0.init.ParamInfoType"* @"_ZN11std$FS$core9ExceptionE.objKlass.0.init.ParamInfo", %KlassInfo.1* @"_ZN11std$FS$core9ExceptionE.objKlass", i8* null, i32 8, i32 2, void (i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)* @"_ZN11std$FS$core9Exception6<init>ER_ZN11std$FS$core6StringE", [5 x i8]* @init.ReflectStr.396, [2 x i8]* @u.ReflectStr.397, %"_ZN11std$FS$core9ExceptionE.objKlass.1.init.ParamInfoType"* @"_ZN11std$FS$core9ExceptionE.objKlass.1.init.ParamInfo", %KlassInfo.1* @"_ZN11std$FS$core9ExceptionE.objKlass", i8* null, i32 72, i32 1, void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception11$messagegetEv", [12 x i8]* @"$messageget.ReflectStr", [26 x i8]* @"R_ZN11std$FS$core6StringE.ReflectStr.398", %"_ZN11std$FS$core9ExceptionE.objKlass.2.$messageget.ParamInfoType"* @"_ZN11std$FS$core9ExceptionE.objKlass.2.$messageget.ParamInfo", %KlassInfo.1* @"_ZN11std$FS$core9ExceptionE.objKlass", i8* null, i32 72, i32 1, void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception8toStringEv", [9 x i8]* @toString.ReflectStr.408, [26 x i8]* @"R_ZN11std$FS$core6StringE.ReflectStr.398", %"_ZN11std$FS$core9ExceptionE.objKlass.3.toString.ParamInfoType"* @"_ZN11std$FS$core9ExceptionE.objKlass.3.toString.ParamInfo", %KlassInfo.1* @"_ZN11std$FS$core9ExceptionE.objKlass", i8* null, i32 8, i32 1, void (%Unit.Type*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception15printStackTraceEv", [16 x i8]* @printStackTrace.ReflectStr, [2 x i8]* @u.ReflectStr.397, %"_ZN11std$FS$core9ExceptionE.objKlass.4.printStackTrace.ParamInfoType"* @"_ZN11std$FS$core9ExceptionE.objKlass.4.printStackTrace.ParamInfo", %KlassInfo.1* @"_ZN11std$FS$core9ExceptionE.objKlass", i8* null, i32 8, i32 1, void (%"record._ZN11std$FS$core5ArrayIC_ZN11std$FS$core17StackTraceElementEE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception13getStackTraceEv", [14 x i8]* @getStackTrace.ReflectStr, [63 x i8]* @"R_ZN11std$FS$core5ArrayIC_ZN11std$FS$core17StackTraceElementEE.ReflectStr", %"_ZN11std$FS$core9ExceptionE.objKlass.5.getStackTrace.ParamInfoType"* @"_ZN11std$FS$core9ExceptionE.objKlass.5.getStackTrace.ParamInfo", %KlassInfo.1* @"_ZN11std$FS$core9ExceptionE.objKlass", i8* null }
@"$messageget.ReflectStr" = internal global [12 x i8] c"$messageget\00", align 1 #3
@"_ZN11std$FS$core9ExceptionE.objKlass.2.$messageget.ParamInfo" = internal global %"_ZN11std$FS$core9ExceptionE.objKlass.2.$messageget.ParamInfoType" { i32 0, [29 x i8]* @"C_ZN11std$FS$core9ExceptionE.ReflectStr", [10 x i8]* @Exception.ReflectStr, i8* null } #3
@"_ZN11std$FS$core9ExceptionE.objKlass.3.toString.ParamInfo" = internal global %"_ZN11std$FS$core9ExceptionE.objKlass.3.toString.ParamInfoType" { i32 0, [29 x i8]* @"C_ZN11std$FS$core9ExceptionE.ReflectStr", [10 x i8]* @Exception.ReflectStr, i8* null } #3
@printStackTrace.ReflectStr = internal global [16 x i8] c"printStackTrace\00", align 1 #3
@"_ZN11std$FS$core9ExceptionE.objKlass.4.printStackTrace.ParamInfo" = internal global %"_ZN11std$FS$core9ExceptionE.objKlass.4.printStackTrace.ParamInfoType" { i32 0, [29 x i8]* @"C_ZN11std$FS$core9ExceptionE.ReflectStr", [10 x i8]* @Exception.ReflectStr, i8* null } #3
@getStackTrace.ReflectStr = internal global [14 x i8] c"getStackTrace\00", align 1 #3
@"_ZN11std$FS$core9ExceptionE.objKlass.5.getStackTrace.ParamInfo" = internal global %"_ZN11std$FS$core9ExceptionE.objKlass.5.getStackTrace.ParamInfoType" { i32 0, [29 x i8]* @"C_ZN11std$FS$core9ExceptionE.ReflectStr", [10 x i8]* @Exception.ReflectStr, i8* null } #3
@"C_ZN11std$FS$core9ExceptionE.ReflectStr" = internal global [29 x i8] c"C_ZN11std$FS$core9ExceptionE\00", align 1
@Exception.ReflectStr = internal global [10 x i8] c"Exception\00", align 1
@"R_ZN11std$FS$core5ArrayIC_ZN11std$FS$core17StackTraceElementEE.ReflectStr" = internal global [63 x i8] c"R_ZN11std$FS$core5ArrayIC_ZN11std$FS$core17StackTraceElementEE\00", align 1
@"_ZN11std$FS$core9ExceptionE.objKlass.0.init.ParamInfo" = internal global %"_ZN11std$FS$core9ExceptionE.objKlass.0.init.ParamInfoType" { i32 0, [29 x i8]* @"C_ZN11std$FS$core9ExceptionE.ReflectStr", [10 x i8]* @Exception.ReflectStr, i8* null }
@"_ZN11std$FS$core9ExceptionE.objKlass.1.init.ParamInfo" = internal global %"_ZN11std$FS$core9ExceptionE.objKlass.1.init.ParamInfoType" { i32 0, [29 x i8]* @"C_ZN11std$FS$core9ExceptionE.ReflectStr", [10 x i8]* @Exception.ReflectStr, i8* null, i32 1, [26 x i8]* @"R_ZN11std$FS$core6StringE.ReflectStr.398", [8 x i8]* @message.ReflectStr.399, i8* null }
@"_ZN11std$FS$core9ExceptionE.vtable" = internal global [4 x i8*] [i8* null, i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception12getClassNameEv" to i8*), i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception11$messagegetEv" to i8*), i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception8toStringEv" to i8*)]
@"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass" = internal global %KlassInfo.0 { i32 36, i32 72, %BitMap* inttoptr (i64 -9223372036854775710 to %BitMap*), i8* bitcast (%KlassInfo.1* @"_ZN11std$FS$core9ExceptionE.objKlass" to i8*), i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @"_ZN17std$FS$collection31ConcurrentModificationExceptionE.vtable", i32 0, i32 0), i64* bitcast ({ [23 x i8*], i32* }* @"_ZN17std$FS$collection31ConcurrentModificationExceptionE.itable" to i64*), i64* null, i8* bitcast (%"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.reflectType"* @"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.reflect" to i8*), i64* bitcast ([58 x i8]* @"C_ZN17std$FS$collection31ConcurrentModificationExceptionE.typeName" to i64*), i32 0, [0 x i8*] zeroinitializer }
@"C_ZN17std$FS$collection31ConcurrentModificationExceptionE.typeName" = internal global [58 x i8] c"C_ZN17std$FS$collection31ConcurrentModificationExceptionE\00", align 1
@"_ZN17std$FS$collection31ConcurrentModificationExceptionE.itable" = internal global { [23 x i8*], i32* } { [23 x i8*] [i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception8toStringEv" to i8*), i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null, i8* null], i32* null }
@"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.reflect" = internal global %"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.reflectType" { i32 8, i32 0, i32 0, i32 2, i32 0, i8* null, i32 8, i32 1, void (i8 addrspace(1)*)* @"_ZN17std$FS$collection31ConcurrentModificationException6<init>Ev", [5 x i8]* @init.ReflectStr.320, [2 x i8]* @u.ReflectStr.321, %"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.0.init.ParamInfoType"* @"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.0.init.ParamInfo", %KlassInfo.0* @"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass", i8* null, i32 8, i32 2, void (i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)* @"_ZN17std$FS$collection31ConcurrentModificationException6<init>ER_ZN11std$FS$core6StringE", [5 x i8]* @init.ReflectStr.320, [2 x i8]* @u.ReflectStr.321, %"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.1.init.ParamInfoType"* @"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.1.init.ParamInfo", %KlassInfo.0* @"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass", i8* null }
@"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.0.init.ParamInfo" = internal global %"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.0.init.ParamInfoType" { i32 0, [58 x i8]* @"C_ZN17std$FS$collection31ConcurrentModificationExceptionE.ReflectStr", [32 x i8]* @ConcurrentModificationException.ReflectStr, i8* null }
@"C_ZN17std$FS$collection31ConcurrentModificationExceptionE.ReflectStr" = internal global [58 x i8] c"C_ZN17std$FS$collection31ConcurrentModificationExceptionE\00", align 1
@ConcurrentModificationException.ReflectStr = internal global [32 x i8] c"ConcurrentModificationException\00", align 1
@"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.1.init.ParamInfo" = internal global %"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass.1.init.ParamInfoType" { i32 0, [58 x i8]* @"C_ZN17std$FS$collection31ConcurrentModificationExceptionE.ReflectStr", [32 x i8]* @ConcurrentModificationException.ReflectStr, i8* null, i32 1, [26 x i8]* @"R_ZN11std$FS$core6StringE.ReflectStr.322", [8 x i8]* @message.ReflectStr.323, i8* null }
@"R_ZN11std$FS$core6StringE.ReflectStr.322" = internal global [26 x i8] c"R_ZN11std$FS$core6StringE\00", align 1
@"_ZN17std$FS$collection31ConcurrentModificationExceptionE.vtable" = internal global [4 x i8*] [i8* null, i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN17std$FS$collection31ConcurrentModificationException12getClassNameEv" to i8*), i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception11$messagegetEv" to i8*), i8* bitcast (void (%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)* @"_ZN11std$FS$core9Exception8toStringEv" to i8*)]
@init.ReflectStr.320 = internal global [5 x i8] c"init\00", align 1
@init.ReflectStr.396 = internal global [5 x i8] c"init\00", align 1
@message.ReflectStr.323 = internal global [8 x i8] c"message\00", align 1
@message.ReflectStr.399 = internal global [8 x i8] c"message\00", align 1
@toString.ReflectStr.408 = internal global [9 x i8] c"toString\00", align 1
@u.ReflectStr.321 = internal global [2 x i8] c"u\00", align 1
@u.ReflectStr.397 = internal global [2 x i8] c"u\00", align 1

declare i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8*, i32)
declare void @CJ_MCC_StackCheck()
declare void @CJ_MCC_ThrowException(i8 addrspace(1)*)
declare void @MCC_SafepointStub()
declare void @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>Ev"(i8 addrspace(1)*)
declare void @"_ZN11std$FS$core9Exception8toStringEv"(%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)
declare void @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>ER_ZN11std$FS$core6StringE"(i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)
declare void @"_ZN11std$FS$core25IndexOutOfBoundsException12getClassNameEv"(%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)
declare void @"_ZN11std$FS$core6Object6<init>Ev"(i8 addrspace(1)*)
declare void @"_ZN11std$FS$core9Exception11$messagegetEv"(%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)
declare void @"_ZN11std$FS$core9Exception13getStackTraceEv"(%"record._ZN11std$FS$core5ArrayIC_ZN11std$FS$core17StackTraceElementEE"*, i8 addrspace(1)*)
declare void @"_ZN11std$FS$core9Exception15printStackTraceEv"(%Unit.Type*, i8 addrspace(1)*)
declare void @"_ZN11std$FS$core9Exception6<init>ER_ZN11std$FS$core6StringE"(i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)
declare void @"_ZN11std$FS$core9Exception6<init>Ev"(i8 addrspace(1)*)
declare void @"_ZN11std$FS$core9Exception12getClassNameEv"(%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)
declare void @"_ZN17std$FS$collection31ConcurrentModificationException6<init>Ev"(i8 addrspace(1)*)
declare void @"_ZN17std$FS$collection31ConcurrentModificationException6<init>ER_ZN11std$FS$core6StringE"(i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)
declare void @"_ZN17std$FS$collection31ConcurrentModificationException12getClassNameEv"(%"record._ZN11std$FS$core6StringE"*, i8 addrspace(1)*)
declare i1 @"_ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueE6resizeEl"(i8 addrspace(1)*, i64)
declare void @"_ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueE9entryViewER_ZN11std$FS$core6StringE"(%"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"*, i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)
declare void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)*, i8 addrspace(1)*, i8*, i64)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1)
declare void @llvm.memcpy.p0i8.p1i8.i64(i8*, i8 addrspace(1)*, i64, i1)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64)
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64)
declare i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)

; CHECK: store i64 %20, i64 addrspace(1)* %21
; CHECK: store i64 %56, i64 addrspace(1)* %57
; CHECK: store i64 %105, i64 addrspace(1)* %0
; CHECK: store i1 false, i1 addrspace(1)* %8

define internal i8 addrspace(1)* @foo1(i8 addrspace(1)* nocapture %"__auto_v_1954$BP", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* nocapture %this, i8 addrspace(1)* %v) gc "cangjie" {
entry:
  call void @CJ_MCC_StackCheck()
  %value108 = alloca %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", align 8
  %.sroa.444 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %temp.sroa.4 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %arr.get102.sroa.4 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %value = alloca %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", align 8
  %.sroa.4 = alloca %"record._ZN11std$FS$core6StringE", align 8
  %0 = getelementptr inbounds %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this, i64 0, i32 5
  %1 = load i64, i64 addrspace(1)* %0, align 8
  %2 = getelementptr inbounds %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this, i64 0, i32 0
  %3 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %2, align 8
  %4 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 32
  %5 = bitcast i8 addrspace(1)* %4 to i64 addrspace(1)*
  %6 = load i64, i64 addrspace(1)* %5, align 8
  %icmpne.not = icmp eq i64 %1, %6
  call cangjiegccc void @MCC_SafepointStub()
  br i1 %icmpne.not, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %7 = tail call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN17std$FS$collection31ConcurrentModificationExceptionE.objKlass" to i8*), i32 72)
  tail call void @"_ZN17std$FS$collection31ConcurrentModificationException6<init>Ev"(i8 addrspace(1)* %7)
  tail call void @CJ_MCC_ThrowException(i8 addrspace(1)* %7)
  unreachable

if.else:                                          ; preds = %entry
  %8 = getelementptr inbounds %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this, i64 0, i32 4
  %9 = load i1, i1 addrspace(1)* %8, align 1
  br i1 %9, label %if.then5, label %if.else4

if.then5:                                         ; preds = %if.else
  %10 = getelementptr inbounds %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this, i64 0, i32 2
  %11 = load i64, i64 addrspace(1)* %10, align 8
  %12 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 56
  %13 = bitcast i8 addrspace(1)* %12 to i64 addrspace(1)*
  %14 = load i64, i64 addrspace(1)* %13, align 8
  %sub = add i64 %14, -1
  %and = and i64 %sub, %11
  %15 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 24
  %16 = bitcast i8 addrspace(1)* %15 to i64 addrspace(1)*
  %17 = load i64, i64 addrspace(1)* %16, align 8
  %icmpsgt = icmp sgt i64 %17, 0
  br i1 %icmpsgt, label %if.then13, label %if.else12

if.then13:                                        ; preds = %if.then5
  %18 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 16
  %19 = bitcast i8 addrspace(1)* %18 to i64 addrspace(1)*
  %20 = load i64, i64 addrspace(1)* %19, align 8
  %21 = getelementptr inbounds %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this, i64 0, i32 3
  store i64 %20, i64 addrspace(1)* %21, align 8
  %22 = bitcast %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this to %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)*
  %23 = load %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*, %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)* %22, align 8
  %24 = load i64, i64 addrspace(1)* %21, align 8
  %25 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %23, i64 0, i32 6, i32 2
  %26 = load i64, i64 addrspace(1)* %25, align 8
  %icmpuge.not = icmp ult i64 %24, %26
  br i1 %icmpuge.not, label %if.else18, label %if.then19

if.then19:                                        ; preds = %if.then13
  %27 = tail call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 72)
  tail call void @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>Ev"(i8 addrspace(1)* %27)
  tail call void @CJ_MCC_ThrowException(i8 addrspace(1)* %27)
  unreachable

if.else18:                                        ; preds = %if.then13
  %28 = bitcast %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %23 to i8 addrspace(1)*
  %29 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %23, i64 0, i32 6
  %30 = bitcast %"record._ZN11std$FS$core5ArrayIT4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEEE" addrspace(1)* %29 to %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)*
  %31 = load %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*, %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)* %30, align 8
  %32 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %23, i64 0, i32 6, i32 1
  %33 = load i64, i64 addrspace(1)* %32, align 8
  %add = add i64 %33, %24
  %arr.get.sroa.2.0..sroa_idx5 = getelementptr inbounds %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %31, i64 0, i32 1, i64 %add, i32 1
  %arr.get.sroa.2.0.copyload = load i64, i64 addrspace(1)* %arr.get.sroa.2.0..sroa_idx5, align 8
  %34 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %23, i64 0, i32 2
  store i64 %arr.get.sroa.2.0.copyload, i64 addrspace(1)* %34, align 8
  %35 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %2, align 8
  %36 = getelementptr inbounds i8, i8 addrspace(1)* %35, i64 24
  %37 = bitcast i8 addrspace(1)* %36 to i64 addrspace(1)*
  %38 = load i64, i64 addrspace(1)* %37, align 8
  %39 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %38, i64 -1)
  %.fca.1.extract = extractvalue { i64, i1 } %39, 1
  br i1 %.fca.1.extract, label %overflow, label %normal

normal:                                           ; preds = %if.else18
  %.fca.0.extract = extractvalue { i64, i1 } %39, 0
  store i64 %.fca.0.extract, i64 addrspace(1)* %37, align 8
  br label %if.end11

overflow:                                         ; preds = %if.else18
  %40 = tail call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* addrspacecast (%"record._ZN11std$FS$core6StringE"* bitcast ({ { i8 addrspace(1)*, i64, i64 }, i64 }* @"$const_cjstring.8" to %"record._ZN11std$FS$core6StringE"*) to %"record._ZN11std$FS$core6StringE" addrspace(1)*))
  tail call void @CJ_MCC_ThrowException(i8 addrspace(1)* %40)
  unreachable

if.else12:                                        ; preds = %if.then5
  %41 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 8
  %42 = bitcast i8 addrspace(1)* %41 to i64 addrspace(1)*
  %43 = load i64, i64 addrspace(1)* %42, align 8
  %44 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %43, i64 %17)
  %.fca.1.extract9 = extractvalue { i64, i1 } %44, 1
  br i1 %.fca.1.extract9, label %overflow26, label %normal27

normal27:                                         ; preds = %if.else12
  %.fca.0.extract8 = extractvalue { i64, i1 } %44, 0
  %45 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %.fca.0.extract8, i64 1)
  %.fca.1.extract12 = extractvalue { i64, i1 } %45, 1
  br i1 %.fca.1.extract12, label %overflow31, label %normal32

overflow26:                                       ; preds = %if.else12
  %46 = tail call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* addrspacecast (%"record._ZN11std$FS$core6StringE"* bitcast ({ { i8 addrspace(1)*, i64, i64 }, i64 }* @"$const_cjstring.8" to %"record._ZN11std$FS$core6StringE"*) to %"record._ZN11std$FS$core6StringE" addrspace(1)*))
  tail call void @CJ_MCC_ThrowException(i8 addrspace(1)* %46)
  unreachable

normal32:                                         ; preds = %normal27
  %.fca.0.extract11 = extractvalue { i64, i1 } %45, 0
  %47 = tail call fastcc i1 @"_ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueE6resizeEl"(i8 addrspace(1)* %3, i64 %.fca.0.extract11)
  br i1 %47, label %if.then36, label %normal32.if.end34_crit_edge

normal32.if.end34_crit_edge:                      ; preds = %normal32
  %.phi.trans.insert = bitcast %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this to %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)*
  %.pre = load %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*, %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)* %.phi.trans.insert, align 8
  br label %if.end34

overflow31:                                       ; preds = %normal27
  %48 = tail call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* addrspacecast (%"record._ZN11std$FS$core6StringE"* bitcast ({ { i8 addrspace(1)*, i64, i64 }, i64 }* @"$const_cjstring.7.2" to %"record._ZN11std$FS$core6StringE"*) to %"record._ZN11std$FS$core6StringE" addrspace(1)*))
  tail call void @CJ_MCC_ThrowException(i8 addrspace(1)* %48)
  unreachable

if.then36:                                        ; preds = %normal32
  %49 = load i64, i64 addrspace(1)* %10, align 8
  %50 = bitcast %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this to %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)*
  %51 = load %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*, %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)* %50, align 8
  %52 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %51, i64 0, i32 5, i32 2
  %53 = load i64, i64 addrspace(1)* %52, align 8
  %sub42 = add i64 %53, -1
  %and43 = and i64 %sub42, %49
  br label %if.end34

if.end34:                                         ; preds = %if.then36, %normal32.if.end34_crit_edge
  %54 = phi %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* [ %51, %if.then36 ], [ %.pre, %normal32.if.end34_crit_edge ]
  %bucketIndex.0 = phi i64 [ %and43, %if.then36 ], [ %and, %normal32.if.end34_crit_edge ]
  %55 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %54, i64 0, i32 1
  %56 = load i64, i64 addrspace(1)* %55, align 8
  %57 = getelementptr inbounds %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this, i64 0, i32 3
  store i64 %56, i64 addrspace(1)* %57, align 8
  %58 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %2, align 8
  %59 = getelementptr inbounds i8, i8 addrspace(1)* %58, i64 8
  %60 = bitcast i8 addrspace(1)* %59 to i64 addrspace(1)*
  %61 = load i64, i64 addrspace(1)* %60, align 8
  %62 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %61, i64 1)
  %.fca.1.extract15 = extractvalue { i64, i1 } %62, 1
  br i1 %.fca.1.extract15, label %overflow47, label %normal48

normal48:                                         ; preds = %if.end34
  %.fca.0.extract14 = extractvalue { i64, i1 } %62, 0
  store i64 %.fca.0.extract14, i64 addrspace(1)* %60, align 8
  br label %if.end11

overflow47:                                       ; preds = %if.end34
  %63 = tail call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* addrspacecast (%"record._ZN11std$FS$core6StringE"* bitcast ({ { i8 addrspace(1)*, i64, i64 }, i64 }* @"$const_cjstring.7.2" to %"record._ZN11std$FS$core6StringE"*) to %"record._ZN11std$FS$core6StringE" addrspace(1)*))
  tail call void @CJ_MCC_ThrowException(i8 addrspace(1)* %63)
  unreachable

if.end11:                                         ; preds = %normal48, %normal
  %bucketIndex.1 = phi i64 [ %and, %normal ], [ %bucketIndex.0, %normal48 ]
  %.pre-phi.pre-phi = bitcast %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this to %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)*
  %64 = load %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*, %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)* %.pre-phi.pre-phi, align 8
  %65 = getelementptr inbounds %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this, i64 0, i32 3
  %66 = load i64, i64 addrspace(1)* %65, align 8
  %67 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %64, i64 0, i32 5, i32 2
  %68 = load i64, i64 addrspace(1)* %67, align 8
  %icmpuge57.not = icmp ult i64 %bucketIndex.1, %68
  br i1 %icmpuge57.not, label %if.else59, label %if.then60

if.then60:                                        ; preds = %if.end11
  %69 = tail call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 72)
  tail call void @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>Ev"(i8 addrspace(1)* %69)
  tail call void @CJ_MCC_ThrowException(i8 addrspace(1)* %69)
  unreachable

if.else59:                                        ; preds = %if.end11
  %70 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %64, i64 0, i32 5
  %71 = load i64, i64 addrspace(1)* %10, align 8
  %72 = bitcast %"record._ZN11std$FS$core5ArrayIlE" addrspace(1)* %70 to %ArrayLayout.Int64 addrspace(1)* addrspace(1)*
  %73 = load %ArrayLayout.Int64 addrspace(1)*, %ArrayLayout.Int64 addrspace(1)* addrspace(1)* %72, align 8
  %74 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %64, i64 0, i32 5, i32 1
  %75 = load i64, i64 addrspace(1)* %74, align 8
  %add62 = add i64 %75, %bucketIndex.1
  %arr.idx.get.gep63 = getelementptr inbounds %ArrayLayout.Int64, %ArrayLayout.Int64 addrspace(1)* %73, i64 0, i32 1, i64 %add62
  %76 = load i64, i64 addrspace(1)* %arr.idx.get.gep63, align 8
  %.sroa.4.0.sroa_cast23 = bitcast %"record._ZN11std$FS$core6StringE"* %.sroa.4 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %.sroa.4.0.sroa_cast23, i8 0, i64 32, i1 false)
  %.sroa.4.16..sroa_idx = getelementptr inbounds %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this, i64 0, i32 1
  %.sroa.4.16..sroa_cast = bitcast %"record._ZN11std$FS$core6StringE" addrspace(1)* %.sroa.4.16..sroa_idx to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %.sroa.4.0.sroa_cast23, i8 addrspace(1)* noundef align 8 dereferenceable(32) %.sroa.4.16..sroa_cast, i64 32, i1 false)
  %77 = bitcast %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %value to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %77, i8 0, i64 56, i1 false)
  %.sroa.0.0..sroa_idx = getelementptr inbounds %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %value, i64 0, i32 0
  store i64 %71, i64* %.sroa.0.0..sroa_idx, align 8
  %.sroa.3.0..sroa_idx20 = getelementptr inbounds %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %value, i64 0, i32 1
  store i64 %76, i64* %.sroa.3.0..sroa_idx20, align 8
  %.sroa.4.0..sroa_idx = getelementptr inbounds %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %value, i64 0, i32 2
  %.sroa.4.0..sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %.sroa.4.0..sroa_idx to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %.sroa.4.0..sroa_cast, i8* noundef nonnull align 8 dereferenceable(32) %.sroa.4.0.sroa_cast23, i64 32, i1 false)
  %.sroa.5.0..sroa_idx22 = getelementptr inbounds %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %value, i64 0, i32 3
  store i8 addrspace(1)* %v, i8 addrspace(1)** %.sroa.5.0..sroa_idx22, align 8
  %78 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %64, i64 0, i32 6, i32 2
  %79 = load i64, i64 addrspace(1)* %78, align 8
  %icmpuge66.not = icmp ult i64 %66, %79
  br i1 %icmpuge66.not, label %if.else68, label %if.then69

if.then69:                                        ; preds = %if.else59
  %80 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 72)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>Ev"(i8 addrspace(1)* %80)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %80)
  unreachable

if.else68:                                        ; preds = %if.else59
  %81 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %64, i64 0, i32 6, i32 0
  %82 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %81, align 8
  %83 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %64, i64 0, i32 6, i32 1
  %84 = load i64, i64 addrspace(1)* %83, align 8
  %add71 = add i64 %84, %66
  %85 = bitcast i8 addrspace(1)* %82 to %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*
  %arr.idx.set.gep = getelementptr inbounds %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %85, i64 0, i32 1, i64 %add71
  %86 = bitcast %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %arr.idx.set.gep to i8 addrspace(1)*
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %82, i8 addrspace(1)* %86, i8* nonnull %77, i64 56)
  %87 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %2, align 8
  %88 = getelementptr inbounds i8, i8 addrspace(1)* %87, i64 32
  %89 = bitcast i8 addrspace(1)* %88 to i64 addrspace(1)*
  %90 = load i64, i64 addrspace(1)* %89, align 8
  %91 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %90, i64 1)
  %.fca.1.extract26 = extractvalue { i64, i1 } %91, 1
  br i1 %.fca.1.extract26, label %overflow75, label %normal76

normal76:                                         ; preds = %if.else68
  %.fca.0.extract25 = extractvalue { i64, i1 } %91, 0
  store i64 %.fca.0.extract25, i64 addrspace(1)* %89, align 8
  %92 = load %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*, %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)* %.pre-phi.pre-phi, align 8
  %93 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %92, i64 0, i32 5, i32 2
  %94 = load i64, i64 addrspace(1)* %93, align 8
  %icmpuge84.not = icmp ult i64 %bucketIndex.1, %94
  br i1 %icmpuge84.not, label %if.else86, label %if.then87

overflow75:                                       ; preds = %if.else68
  %95 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* addrspacecast (%"record._ZN11std$FS$core6StringE"* bitcast ({ { i8 addrspace(1)*, i64, i64 }, i64 }* @"$const_cjstring.7.2" to %"record._ZN11std$FS$core6StringE"*) to %"record._ZN11std$FS$core6StringE" addrspace(1)*))
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %95)
  unreachable

if.then87:                                        ; preds = %normal76
  %96 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 72)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>Ev"(i8 addrspace(1)* %96)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %96)
  unreachable

if.else86:                                        ; preds = %normal76
  %97 = load i64, i64 addrspace(1)* %65, align 8
  %98 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %92, i64 0, i32 5, i32 0
  %99 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %98, align 8
  %100 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %92, i64 0, i32 5, i32 1
  %101 = load i64, i64 addrspace(1)* %100, align 8
  %add89 = add i64 %101, %bucketIndex.1
  %102 = bitcast i8 addrspace(1)* %99 to %ArrayLayout.Int64 addrspace(1)*
  %arr.idx.set.gep90 = getelementptr inbounds %ArrayLayout.Int64, %ArrayLayout.Int64 addrspace(1)* %102, i64 0, i32 1, i64 %add89
  store i64 %97, i64 addrspace(1)* %arr.idx.set.gep90, align 8
  %103 = load %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*, %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)* %.pre-phi.pre-phi, align 8
  %104 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %103, i64 0, i32 4
  %105 = load i64, i64 addrspace(1)* %104, align 8
  store i64 %105, i64 addrspace(1)* %0, align 8
  store i1 false, i1 addrspace(1)* %8, align 1
  br label %if.end3

if.else4:                                         ; preds = %if.else
  %106 = getelementptr inbounds %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this, i64 0, i32 3
  %107 = load i64, i64 addrspace(1)* %106, align 8
  %108 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 80
  %109 = bitcast i8 addrspace(1)* %108 to i64 addrspace(1)*
  %110 = load i64, i64 addrspace(1)* %109, align 8
  %icmpuge95.not = icmp ult i64 %107, %110
  br i1 %icmpuge95.not, label %if.else97, label %if.then98

if.then98:                                        ; preds = %if.else4
  %111 = tail call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 72)
  tail call void @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>Ev"(i8 addrspace(1)* %111)
  tail call void @CJ_MCC_ThrowException(i8 addrspace(1)* %111)
  unreachable

if.else97:                                        ; preds = %if.else4
  %112 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 64
  %113 = bitcast i8 addrspace(1)* %112 to %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)*
  %114 = load %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*, %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)* %113, align 8
  %115 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 72
  %116 = bitcast i8 addrspace(1)* %115 to i64 addrspace(1)*
  %117 = load i64, i64 addrspace(1)* %116, align 8
  %add100 = add i64 %117, %107
  %arr.get102.sroa.4.0.sroa_cast39 = bitcast %"record._ZN11std$FS$core6StringE"* %arr.get102.sroa.4 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %arr.get102.sroa.4.0.sroa_cast39, i8 0, i64 32, i1 false)
  %arr.get102.sroa.0.0..sroa_idx = getelementptr inbounds %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %114, i64 0, i32 1, i64 %add100, i32 0
  %arr.get102.sroa.0.0.copyload = load i64, i64 addrspace(1)* %arr.get102.sroa.0.0..sroa_idx, align 8
  %arr.get102.sroa.3.0..sroa_idx36 = getelementptr inbounds %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %114, i64 0, i32 1, i64 %add100, i32 1
  %arr.get102.sroa.3.0.copyload = load i64, i64 addrspace(1)* %arr.get102.sroa.3.0..sroa_idx36, align 8
  %arr.get102.sroa.4.0..sroa_idx = getelementptr inbounds %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %114, i64 0, i32 1, i64 %add100, i32 2
  %arr.get102.sroa.4.0..sroa_cast = bitcast %"record._ZN11std$FS$core6StringE" addrspace(1)* %arr.get102.sroa.4.0..sroa_idx to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %arr.get102.sroa.4.0.sroa_cast39, i8 addrspace(1)* noundef align 8 dereferenceable(32) %arr.get102.sroa.4.0..sroa_cast, i64 32, i1 false)
  %arr.get102.sroa.5.0..sroa_idx38 = getelementptr inbounds %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %114, i64 0, i32 1, i64 %add100, i32 3
  %arr.get102.sroa.5.0.copyload = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arr.get102.sroa.5.0..sroa_idx38, align 8
  %temp.sroa.4.0.sroa_cast49 = bitcast %"record._ZN11std$FS$core6StringE"* %temp.sroa.4 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %temp.sroa.4.0.sroa_cast49, i8 0, i64 32, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %temp.sroa.4.0.sroa_cast49, i8* noundef nonnull align 8 dereferenceable(32) %arr.get102.sroa.4.0.sroa_cast39, i64 32, i1 false)
  %118 = bitcast %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %this to %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)*
  %119 = load %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*, %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* addrspace(1)* %118, align 8
  %120 = load i64, i64 addrspace(1)* %106, align 8
  %.sroa.444.0.sroa_cast48 = bitcast %"record._ZN11std$FS$core6StringE"* %.sroa.444 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %.sroa.444.0.sroa_cast48, i8 0, i64 32, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %.sroa.444.0.sroa_cast48, i8* noundef nonnull align 8 dereferenceable(32) %temp.sroa.4.0.sroa_cast49, i64 32, i1 false)
  %121 = bitcast %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %value108 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %121, i8 0, i64 56, i1 false)
  %.sroa.041.0..sroa_idx = getelementptr inbounds %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %value108, i64 0, i32 0
  store i64 %arr.get102.sroa.0.0.copyload, i64* %.sroa.041.0..sroa_idx, align 8
  %.sroa.342.0..sroa_idx43 = getelementptr inbounds %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %value108, i64 0, i32 1
  store i64 %arr.get102.sroa.3.0.copyload, i64* %.sroa.342.0..sroa_idx43, align 8
  %.sroa.444.0..sroa_idx = getelementptr inbounds %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %value108, i64 0, i32 2
  %.sroa.444.0..sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %.sroa.444.0..sroa_idx to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %.sroa.444.0..sroa_cast, i8* noundef nonnull align 8 dereferenceable(32) %.sroa.444.0.sroa_cast48, i64 32, i1 false)
  %.sroa.546.0..sroa_idx47 = getelementptr inbounds %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %value108, i64 0, i32 3
  store i8 addrspace(1)* %v, i8 addrspace(1)** %.sroa.546.0..sroa_idx47, align 8
  %122 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %119, i64 0, i32 6, i32 2
  %123 = load i64, i64 addrspace(1)* %122, align 8
  %icmpuge111.not = icmp ult i64 %120, %123
  br i1 %icmpuge111.not, label %if.else113, label %if.then114

if.then114:                                       ; preds = %if.else97
  %124 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 72)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>Ev"(i8 addrspace(1)* %124)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %124)
  unreachable

if.else113:                                       ; preds = %if.else97
  %125 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %119, i64 0, i32 6, i32 0
  %126 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %125, align 8
  %127 = getelementptr inbounds %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ObjLayout._ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %119, i64 0, i32 6, i32 1
  %128 = load i64, i64 addrspace(1)* %127, align 8
  %add116 = add i64 %128, %120
  %129 = bitcast i8 addrspace(1)* %126 to %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*
  %arr.idx.set.gep117 = getelementptr inbounds %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"ArrayLayout.T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %129, i64 0, i32 1, i64 %add116
  %130 = bitcast %"T4_llR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %arr.idx.set.gep117 to i8 addrspace(1)*
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %126, i8 addrspace(1)* %130, i8* nonnull %121, i64 56)
  br label %if.end3

if.end3:                                          ; preds = %if.else113, %if.else86
  %ifvalue2.0 = phi i8 addrspace(1)* [ %v, %if.else86 ], [ %arr.get102.sroa.5.0.copyload, %if.else113 ]
  ret i8 addrspace(1)* %ifvalue2.0
}

define internal i1 @foo2(i8 addrspace(1)* %this, i8 addrspace(1)* %"key$BP", %"record._ZN11std$FS$core6StringE" addrspace(1)* %key, i8 addrspace(1)* %value) gc "cangjie" {
entry:
  call void @CJ_MCC_StackCheck()
  %view = alloca %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", align 8
  %callRet = alloca %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", align 8
  %0 = bitcast %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %callRet to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %0, i8 0, i64 72, i1 false)
  call cangjiegccc void @MCC_SafepointStub()
  call void @"_ZN17std$FS$collection7HashMapIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueE9entryViewER_ZN11std$FS$core6StringE"(%"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* noalias nonnull sret(%"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE") %callRet, i8 addrspace(1)* %this, i8 addrspace(1)* %"key$BP", %"record._ZN11std$FS$core6StringE" addrspace(1)* %key)
  %1 = bitcast %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %view to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %1, i8 0, i64 72, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(72) %1, i8* noundef nonnull align 8 dereferenceable(72) %0, i64 72, i1 false)
  %2 = getelementptr inbounds %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE", %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %view, i64 0, i32 4
  %3 = load i1, i1* %2, align 8
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %4 = addrspacecast %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE"* %view to %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)*
  %5 = call i8 addrspace(1)* @foo1(i8 addrspace(1)* null, %"record._ZN17std$FS$collection9EntryViewIR_ZN11std$FS$core6StringEC_ZN16encoding$FS$json9JsonValueEE" addrspace(1)* %4, i8 addrspace(1)* %value)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret i1 %3
}

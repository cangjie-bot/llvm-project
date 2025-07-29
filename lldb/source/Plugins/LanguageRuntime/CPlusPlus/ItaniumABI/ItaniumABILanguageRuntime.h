//===-- ItaniumABILanguageRuntime.h -----------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_SOURCE_PLUGINS_LANGUAGERUNTIME_CPLUSPLUS_ITANIUMABI_ITANIUMABILANGUAGERUNTIME_H
#define LLDB_SOURCE_PLUGINS_LANGUAGERUNTIME_CPLUSPLUS_ITANIUMABI_ITANIUMABILANGUAGERUNTIME_H

#include "lldb/Target/LanguageRuntime.h"
#include "Plugins/LanguageRuntime/CPlusPlus/CPPLanguageRuntime.h"
#include "Plugins/TypeSystem/Clang/TypeSystemClang.h"
#include "clang/Sema/Sema.h"

namespace lldb_private {
// The following TypeInfo structure is the same as that in cangjie/libs/std/core/native/typetemplate.c
typedef void* (*FnPtrType)(int32_t, void**);

#pragma pack(push, 8)
typedef struct TypeTemplate {
  const char* name;
  int8_t typeKind;
  uint8_t flag;
  uint16_t fieldsNum;   // Number of member variables
  uint16_t typeArgsNum; // Number of generic parameters
  FnPtrType* fieldsFns; // member variables
  FnPtrType superFn;
  void* finalizer;
  void* reflection; // Reflection Metadata Information
  void** extensionDefPtr;
  uint16_t inheritedClassNum;
} TypeTemplate;
#pragma pack(pop)

#pragma pack(push, 8)
typedef struct TypeInfo {
private:
  const char* name;

public:
  int8_t type;
  uint8_t flag;
  uint16_t fieldsNum; // Number of member variables
  uint32_t size;      // Memory Size in Bytes
  const void* gcTib;
  uint32_t uuid;
  uint8_t align;
  uint8_t typeArgNum; // Number of generic parameters
  uint16_t inheritedClassNum;
  uint32_t* offsets;
  union {
    // If `typeArgNum` is greater than 0, it indicates `sourceGeneric`. Otherwise, it indicates `finalizer`.
    const TypeTemplate* sourceGeneric; // Raw Generic Template
    void* finalizer;
  };
  const struct TypeInfo** typeArgs; // Generic parameters list
  const struct TypeInfo** fields; // Member variable list
  const struct TypeInfo* super;
  void** extensionDefPtr;
  void* mtable;
  void* reflection; // Reflection Metadata Information

  bool IsFunc() const;
  bool IsCFunc() const;
  bool IsVArray() const;
  std::string GetName(Process& process) const;
} TypeInfo;
#pragma pack(pop)

enum ReflectModifyType : uint32_t {
  RMT_DEFAULT = (uint32_t)0x1 << 0,
  RMT_PRIVATE = (uint32_t)0x1 << 1,
  RMT_PROTECTED = (uint32_t)0x1 << 2,
  RMT_PUBLIC = (uint32_t)0x1 << 3,
  RMT_IMMUTABLE = (uint32_t)0x1 << 4,
  RMT_BOXCLASS = (uint32_t)0x1 << 5,
  RMT_OPEN = (uint32_t)0x1 << 6,
  RMT_OVERRIDE = (uint32_t)0x1 << 7,
  RMT_REDEF = (uint32_t)0x1 << 8,
  RMT_ABSTRACT = (uint32_t)0x1 << 9,
  RMT_SEALED = (uint32_t)0x1 << 10,
  RMT_MUT = (uint32_t)0x1 << 11,
  RMT_STATIC = (uint32_t)0x1 << 12,
  RMT_ENUM_KIND0 = (uint32_t)0x1 << 13,
  RMT_ENUM_KIND1 = (uint32_t)0x1 << 14,
  RMT_ENUM_KIND2 = (uint32_t)0x1 << 15,
  RMT_ENUM_KIND3 = (uint32_t)0x1 << 16,
  RMT_HAS_SRET0 = (uint32_t)0x1 << 17, // Has sret but it is'not generic
  RMT_HAS_SRET1 = (uint32_t)0x1 << 18, // Has sret and it is 'T'
  RMT_HAS_SRET2 = (uint32_t)0x1 << 19, // Has sret and it is 'known struct T'
  RMT_HAS_SRET3 = (uint32_t)0x1 << 20, // Has sret and it is 'unknow struct T'
  RMT_MAX = (uint32_t)0x1 << 21,
};

const int32_t BitsPerByte = 8;
const int32_t BitsPerWidth = 16;
class ItaniumABILanguageRuntime : public lldb_private::CPPLanguageRuntime {
public:
  ~ItaniumABILanguageRuntime() override = default;

  // Static Functions
  static void Initialize();

  static void Terminate();

  static lldb_private::LanguageRuntime *
  CreateInstance(Process *process, lldb::LanguageType language);

  static llvm::StringRef GetPluginNameStatic() { return "itanium"; }

  static char ID;

  bool isA(const void *ClassID) const override {
    return ClassID == &ID || CPPLanguageRuntime::isA(ClassID);
  }

  static bool classof(const LanguageRuntime *runtime) {
    return runtime->isA(&ID);
  }
  std::string GetReflectionFieldName(int16_t id, TypeInfo& typeInfo);
  void AddFieldToRecordType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            CompilerType& dynamic_type,
                            bool is_class_member = false);
  CompilerType GetDynamicClassType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name);
  CompilerType GetDynamicRawArrayType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name);
  CompilerType GetDynamicFuncType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name);
  CompilerType GetDynamicCStringType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name);
  CompilerType GetDynamicCPointerType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name);
  CompilerType GetDynamicCFuncType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name);
  CompilerType GetDynamicVArrayType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name);
  CompilerType GetDynamicTupleType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name);
  CompilerType GetDynamicStructType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name);
  void CreateAndAddInheritTypeToRecordType(CompilerType& enum_type,
                            CompilerType& dynamic_type,
                            TypeSystemClang& ast,
                            uint64_t ctor_num,
                            uint64_t ctors_addr);
  CompilerType CreateEnum2Type(TypeSystemClang& ast, CompilerType& enum_type,
                               ConstString type_name,
                               uint64_t ctor_num, uint64_t ctors_addr);
  void CreateAndAddInheritTypeToEnum3Type(CompilerType& enum_type,
                            CompilerType& dynamic_type,
                            TypeSystemClang& ast,
                            uint64_t ctor_num,
                            uint64_t ctors_addr);
  CompilerType GetDynamicOptionType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name,
                            CompilerType& enum_type);
  CompilerType GetDynamicEnumType(TypeSystemClang& ast,
                            TypeInfo& typeInfo,
                            ConstString& type_name);
  CompilerType GetDynamicTypeFromPrimitiveType(TypeSystemClang& ast,
                                                TypeInfo& typeInfo);
  CompilerType GetDynamicTypeFromGenericTypeInfo(TypeSystemClang& ast,
                                                TypeInfo& typeInfo);
  bool GetGenericDynamicType(ValueObject &in_value,
                            TypeAndOrName &class_type_or_name,
                            Address &dynamic_address,
                            Value::ValueType &value_type);

  bool GetDynamicTypeAndAddress(ValueObject &in_value,
                                lldb::DynamicValueType use_dynamic,
                                TypeAndOrName &class_type_or_name,
                                Address &address,
                                Value::ValueType &value_type) override;

  TypeAndOrName FixUpDynamicType(const TypeAndOrName &type_and_or_name,
                                 ValueObject &static_value) override;

  bool CouldHaveDynamicValue(ValueObject &in_value) override;

  void SetExceptionBreakpoints() override;

  void ClearExceptionBreakpoints() override;

  bool ExceptionBreakpointsAreSet() override;

  bool ExceptionBreakpointsExplainStop(lldb::StopInfoSP stop_reason) override;

  ReflectModifyType GetEnumKind(TypeInfo& typeInfo);
  lldb::BreakpointResolverSP
  CreateExceptionResolver(const lldb::BreakpointSP &bkpt,
                          bool catch_bp, bool throw_bp) override;

  lldb::SearchFilterSP CreateExceptionSearchFilter() override;
  
  lldb::ValueObjectSP GetExceptionObjectForThread(
      lldb::ThreadSP thread_sp) override;

  // PluginInterface protocol
  llvm::StringRef GetPluginName() override { return GetPluginNameStatic(); }

protected:
  lldb::BreakpointResolverSP
  CreateExceptionResolver(const lldb::BreakpointSP &bkpt,
                          bool catch_bp, bool throw_bp, bool for_expressions);

  lldb::BreakpointSP CreateExceptionBreakpoint(bool catch_bp, bool throw_bp,
                                               bool for_expressions,
                                               bool is_internal);

private:
  typedef std::map<lldb_private::Address, TypeAndOrName> DynamicTypeCache;

  ItaniumABILanguageRuntime(Process *process)
      : // Call CreateInstance instead.
        lldb_private::CPPLanguageRuntime(process), m_cxx_exception_bp_sp(),
        m_dynamic_type_map(), m_dynamic_type_map_mutex() {}

  lldb::BreakpointSP m_cxx_exception_bp_sp;
  DynamicTypeCache m_dynamic_type_map;
  std::mutex m_dynamic_type_map_mutex;

  TypeAndOrName GetTypeInfoFromVTableAddress(ValueObject &in_value,
                                             lldb::addr_t original_ptr,
                                             lldb::addr_t vtable_addr);

  TypeAndOrName GetDynamicTypeInfo(const lldb_private::Address &vtable_addr);

  void SetDynamicTypeInfo(const lldb_private::Address &vtable_addr,
                          const TypeAndOrName &type_info);
};

} // namespace lldb_private

#endif // LLDB_SOURCE_PLUGINS_LANGUAGERUNTIME_CPLUSPLUS_ITANIUMABI_ITANIUMABILANGUAGERUNTIME_H

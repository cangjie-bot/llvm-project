//===-- CjTypes.cpp ---------------------------------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#include "CjTypes.h"
#include "lldb/DataFormatters/StringPrinter.h"
#include "lldb/DataFormatters/FormattersHelpers.h"
#include "lldb/Target/Process.h"
#include "lldb/DataFormatters/DumpValueObjectOptions.h"
#include "lldb/DataFormatters/ValueObjectPrinter.h"
#include "lldb/Core/ValueObject.h"

using namespace lldb;
using namespace lldb_private;

bool lldb_private::formatters::BasicSummaryProvider(ValueObject &valobj, Stream &stream, const TypeSummaryOptions &) {
  ConstString type = valobj.GetTypeName();
  if (type == "Rune") {
    DataExtractor data;
    Status error;
    valobj.GetData(data, error);

    if (error.Fail()) {
      return false;
    }

    StringPrinter::ReadBufferAndDumpToStreamOptions options(valobj);
    options.SetData(std::move(data));
    options.SetStream(&stream);
    options.SetQuote('\'');
    options.SetSourceSize(1);
    options.SetBinaryZeroIsTerminator(false);

    return StringPrinter::ReadBufferAndDumpToStream<StringPrinter::StringElementType::UTF32>(options);
  }

  std::string value;
  if (type == "Int8") {
    valobj.GetValueAsCString(lldb::eFormatDecimal, value);
  } else if (type == "UInt8") {
    valobj.GetValueAsCString(lldb::eFormatUnsigned, value);
  }

  if (!value.empty()) {
    stream.Printf("%s", value.c_str());
  }

  return true;
}

bool lldb_private::formatters::StringSummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &) {
  lldb::ValueObjectSP raw = valobj.GetNonSyntheticValue();
  if (!raw) {
    return false;
  }

  lldb::ValueObjectSP data = raw->GetChildMemberWithName(ConstString("myData"), true);
  if (!data) {
    return false;
  }

  Status error;
  if (data->IsPointerType()) {
    data = data->Dereference(error);
    if (error.Fail()) {
      return false;
    }
  }

  lldb::ValueObjectSP start = raw->GetChildMemberWithName(ConstString("start"), true);
  lldb::ValueObjectSP len = raw->GetChildMemberWithName(ConstString("length"), true);
  lldb::ValueObjectSP elements = data->GetChildMemberWithName(ConstString("elements"), true);
  if (!start || !len || !elements) {
    return false;
  }

  StringPrinter::ReadStringAndDumpToStreamOptions options(*elements);
  uint64_t startValue = start->GetValueAsUnsigned(UINT64_MAX);
  if (startValue == UINT64_MAX) {
    return false;
  }
  options.SetLocation(elements->GetAddressOf() + startValue);
  options.SetTargetSP(valobj.GetTargetSP());
  options.SetStream(&stream);
  uint64_t lenValue = len->GetValueAsUnsigned(UINT64_MAX);
  if (lenValue == UINT64_MAX) {
    return false;
  }
  if (lenValue == 0) {
    stream.Printf("\"\"");
    return true;
  }
  options.SetSourceSize(lenValue);
  options.SetHasSourceSize(true);
  options.SetNeedsZeroTermination(false);
  options.SetIgnoreMaxLength(false);
  options.SetEscapeNonPrintables(true);
  options.SetBinaryZeroIsTerminator(false);

  return StringPrinter::ReadStringAndDumpToStream<StringPrinter::StringElementType::UTF8>(options);
}

bool lldb_private::formatters::UnitSummaryProvider(
    ValueObject &, Stream &stream, const TypeSummaryOptions &) {
  stream.Printf("()");
  return true;
}

bool lldb_private::formatters::CStringSummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &) {
  lldb::ValueObjectSP raw = valobj.GetNonSyntheticValue();
  if (!raw) {
    return false;
  }

  lldb::ValueObjectSP chars = raw->GetChildMemberWithName(ConstString("chars"), true);
  if (!chars) {
    return false;
  }

  lldb::ValueObjectSP cpoint = chars->GetChildMemberWithName(ConstString("ptr"), true);
  if (!cpoint) {
    // For llvmgc backend. If CString in Jet, char * is CString.chars.ptr.
    // Need delete cpoint after CString refactor to built-in on Jet backend.
    cpoint = chars;
  }

  stream.Printf("%s", cpoint->GetSummaryAsCString());

  return true;
}

bool lldb_private::formatters::CPointerSummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &) {
  lldb::ValueObjectSP raw = valobj.GetNonSyntheticValue();
  if (!raw) {
    return false;
  }

  lldb::ValueObjectSP ptr = raw->GetChildMemberWithName(ConstString("ptr"), true);
  if (!ptr) {
    return false;
  }

  stream.Printf("%s", ptr->GetValueAsCString());

  return true;
}

static void DumpWithoutPrefix(lldb::ValueObjectSP valueSP, Stream &stream)
{
  if (valueSP == nullptr) {
    return;
  }
  auto target = valueSP->GetTargetSP();
  if (target == nullptr) {
    return;
  }

  StreamString result;
  DumpValueObjectOptions options;
  auto max_depth = target->GetMaximumDepthOfChildrenToDisplay();
  options.SetMaximumPointerDepth({DumpValueObjectOptions::PointerDepth::Mode::Always, max_depth.first});
  options.SetMaximumDepth(max_depth.first, max_depth.second);
  options.SetHideRootType(true);
  options.SetVariableFormatDisplayLanguage(valueSP->GetPreferredDisplayLanguage());
  valueSP->Dump(result, options);
  std::string value = result.GetString().data();
  std::string prefix = " = ";
  size_t start = value.find_first_of(prefix);
  size_t end = value.find_last_of("\n");
  if (start != std::string::npos && end != std::string::npos) {
    stream.Printf("%s", value.substr(start + prefix.size(), end - start - prefix.size()).c_str());
  }
  return;
}

bool lldb_private::formatters::RangeSummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &) {
  lldb::ValueObjectSP raw = valobj.GetNonSyntheticValue();

  lldb::ValueObjectSP startSP = raw->GetChildMemberWithName(ConstString("start"), true);
  lldb::ValueObjectSP endSP = raw->GetChildMemberWithName(ConstString("end"), true);
  lldb::ValueObjectSP stepSP = raw->GetChildMemberWithName(ConstString("step"), true);
  lldb::ValueObjectSP closedSP = raw->GetChildMemberWithName(ConstString("isClosed"), true);
  lldb::ValueObjectSP hasStartSP = raw->GetChildMemberWithName(ConstString("hasStart"), true);
  lldb::ValueObjectSP hasEndSP = raw->GetChildMemberWithName(ConstString("hasEnd"), true);
  if (!startSP || !endSP || !stepSP || !closedSP || !hasStartSP || !hasEndSP) {
    return false;
  }

  std::string hasStart = hasStartSP->GetValueAsCString();
  std::string hasEnd = hasEndSP->GetValueAsCString();
  std::string closed = closedSP->GetValueAsCString();
  if (hasStart == "true") {
    DumpWithoutPrefix(startSP, stream);
  }
  stream.Printf("..");
  if (closed == "true") {
    stream.Printf("=");
  }
  if (hasEnd == "true") {
    DumpWithoutPrefix(endSP, stream);
  }
  stream.Printf(" : ");
  DumpWithoutPrefix(stepSP, stream);
  return true;
}

bool lldb_private::formatters::OptionSummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options) {
  Status error;
  lldb::ValueObjectSP raw = valobj.GetNonSyntheticValue();
  lldb::ValueObjectSP constructorSP = raw->GetChildMemberWithName(ConstString("constructor"), true);
  if (constructorSP) {
    std::string constructor = constructorSP->GetValueAsCString();
    if (constructor == "None") {
      stream.Printf("None");
      return true;
    }
  }

  lldb::ValueObjectSP valueSP = raw->GetChildMemberWithName(ConstString("val"), true);
  if (valueSP == nullptr) {
    valueSP = raw->GetChildMemberWithName(ConstString("Recursive-val"), true);
    if (valueSP) {
      if (valueSP->IsPointerType()) {
        stream.Printf("%s", valueSP->GetValueAsCString());
      } else {
        stream.Printf("0x%" PRIx64, valueSP->GetAddressOf());
      }
      return true;
    }
    return false;
  }

  if (valueSP->IsPointerType()) {
    valueSP = valueSP->Dereference(error);
    if (error.Fail()) {
      return false;
    }
    auto addr = valueSP->GetAddressOf();
    if (addr == LLDB_INVALID_ADDRESS || addr == 0) {
      stream.Printf("None");
      return true;
    }
  }

  TypeSummaryImpl *entry = valueSP->GetSummaryFormat().get();
  if (entry) {
    std::string summary;
    valueSP->GetSummaryAsCString(entry, summary, lldb::LanguageType::eLanguageTypeC_plus_plus_14);
    if (!summary.empty()) {
      stream.Printf("%s", summary.c_str());
      return true;
    }
  }

  const char *value_cstr = valueSP->GetValueAsCString();
  if (value_cstr) {
    stream.Printf("%s", value_cstr);
    return true;
  }

  return true;
}

bool lldb_private::formatters::OptionPtrSummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options) {
  if (valobj.IsPointerType()) {
    Status error;
    lldb::ValueObjectSP valueSP = valobj.Dereference(error);
    if (error.Fail()) {
      stream.Printf("None");
      return true;
    }

    auto addr = valueSP->GetAddressOf();
    if (addr == LLDB_INVALID_ADDRESS || addr == 0) {
      stream.Printf("None");
      return true;
    }

    DumpWithoutPrefix(valueSP, stream);
    return true;
  }

  return false;
}

bool lldb_private::formatters::EnumOptionSummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options) {
  lldb::ValueObjectSP valueSP;
  if (valobj.IsPointerType()) {
    Status error;
    valueSP = valobj.Dereference(error);
    if (error.Fail()) {
      return false;
    }
    valueSP = valueSP->GetNonSyntheticValue();
  } else {
    valueSP = valobj.GetNonSyntheticValue();
  }

  for (size_t i = 0; i < valueSP->GetCompilerType().GetNumDirectBaseClasses(); i++) {
    ValueObjectSP ctor = valueSP->GetChildAtIndex(i, true);
    if (!ctor) {
      continue;
    }
    auto enum_class = ctor->GetChildMemberWithName(ConstString("EnumClass$"), true);
    if (!enum_class) {
      continue;
    }

    auto type = enum_class->GetChildMemberWithName(ConstString("constructor"), true);
    if (!type) {
      continue;
    }

    auto id = type->GetValueAsUnsigned(0);
    auto real_ctor = valueSP->GetChildAtIndex(id, true);
    if (!real_ctor) {
      continue;
    }
    auto real_enumclass = real_ctor->GetChildMemberWithName(ConstString("EnumClass$"), true);
    if (!real_enumclass) {
      continue;
    }
    DataExtractor data;
    Status err;
    enum_class->GetData(data, err);
    valueSP = lldb_private::ValueObject::CreateValueObjectFromData("EnumClass", data,
        real_enumclass->GetExecutionContextRef(), real_enumclass->GetCompilerType());
    valueSP = valueSP->GetChildMemberWithName(ConstString("constructor"), true);
    break;
  }

  TypeSummaryImpl *entry = valueSP->GetSummaryFormat().get();
  if (entry) {
    std::string summary;
    valueSP->GetSummaryAsCString(entry, summary, lldb::LanguageType::eLanguageTypeC_plus_plus_14);
    if (!summary.empty()) {
      stream.Printf("%s", summary.c_str());
      return true;
    }
  }

  std::string value_cstr(valueSP->GetValueAsCString());
  if (!value_cstr.empty() && value_cstr != std::string("Some")) {
    stream.Printf("%s", value_cstr.c_str());
    return true;
  }
  return true;
}

bool lldb_private::formatters::EnumOptionPtrSummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &options) {
  auto valueSP = valobj.GetNonSyntheticValue();
  if (valueSP->IsPointerType()) {
    Status error;
    valueSP = valueSP->Dereference(error);
    if (error.Fail()) {
      stream.Printf("None");
      return true;
    }

    auto addr = valueSP->GetAddressOf();
    if (addr == LLDB_INVALID_ADDRESS || addr == 0) {
      stream.Printf("None");
      return true;
    }

    DumpWithoutPrefix(valueSP, stream);
    return true;
  }

  return false;
}

bool lldb_private::formatters::FunctionSummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &) {
  lldb::ValueObjectSP raw = valobj.GetNonSyntheticValue();
  if (!raw) {
    return false;
  }

  lldb::ValueObjectSP ptr = raw->GetChildMemberWithName(ConstString("ptr"), true);
  if (!ptr) {
    return false;
  }
  if (ptr->GetSummaryAsCString() == nullptr) {
    stream.Printf("%s", ptr->GetValueAsCString());
  } else {
    stream.Printf("%s %s", ptr->GetValueAsCString(), ptr->GetSummaryAsCString());
  }
  return true;
}

bool lldb_private::formatters::EnumSummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &) {
  lldb::ValueObjectSP raw = valobj.GetNonSyntheticValue();
  if (!raw) {
    return false;
  }

  lldb::ValueObjectSP ptr = raw->GetChildMemberWithName(ConstString("constructor"), true);
  if (ptr == nullptr) {
    return false;
  }

  std::vector<ConstString> enumerators;
  auto type = ptr->GetCompilerType();
  type.ForEachEnumerator(
    [&enumerators](const CompilerType &integer_type, ConstString name, const llvm::APSInt &value) -> bool {
      enumerators.push_back(name);
      return true;
    }
  );

  if (enumerators.size() == 1) {
    stream.Printf("%s", enumerators[0].AsCString());
  } else {
    stream.Printf("%s", ptr->GetValueAsCString());
  }

  return true;
}

bool lldb_private::formatters::Enum2SummaryProvider(
    ValueObject &valobj, Stream &stream, const TypeSummaryOptions &) {
  if (valobj.IsPointerType()) {
    auto ptr = valobj.GetValueAsUnsigned(UINT64_MAX);
    if (ptr == 0) {
      std::string field_name;
      auto enum_type = valobj.GetCompilerType().GetPointeeType();
      auto constructor = enum_type.GetFieldAtIndex(0, field_name, nullptr, nullptr, nullptr);
      ConstString none;
      constructor.ForEachEnumerator(
        [&none](const CompilerType &integer_type, ConstString name, const llvm::APSInt &value) -> bool {
          if (name.GetStringRef().contains("N$_")) {
            none = name;
          }
          return true;
        }
      );
      stream.Printf("%s", none.GetStringRef().ltrim("N$_").data());
      return true;
    } else {
      Status err;
      auto val = valobj.Dereference(err);
      if (!err.Fail()) {
        val->SetIsOptionlikeReference(true);
        DumpWithoutPrefix(val, stream);
        return true;
      }
    }
  }

  lldb::ValueObjectSP raw = valobj.GetNonSyntheticValue();
  if (!raw) {
    return false;
  }
  if (raw->IsOptionlikeReference()) {
    return false;
  }
  auto constructor = raw->GetChildMemberWithName(ConstString("constructor"), true);
  if (constructor == nullptr) {
    return false;
  }

  auto value = constructor->GetValueAsCString();
  if (value != nullptr) {
    if (std::string(value).find("N$_") == 0) {
      stream.Printf("%s", std::string(value).substr(std::string("N$_").size()).c_str());
      return true;
    }
  }

  return false;
}

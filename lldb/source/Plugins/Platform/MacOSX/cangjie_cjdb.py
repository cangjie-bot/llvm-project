# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.
#

import lldb
import re
import inspect
import struct
import datetime
import functools
from enum import Enum
from typing import Callable, Union, List, Tuple, Pattern, Any

UINT64_MAX = 0xFFFFFFFFFFFFFFFF

def WhenException(action: str = "returnDefaultValue", defaultRetValue = "<error: uninitialized or bad data>"):
    valid_modes = {
        "returnDefaultValue",
        "returnNone",
        "returnExceptionName",
        "raiseAgain"
    }
    if action not in valid_modes:
        action = "returnNone"

    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            try:
                return func(*args, **kwargs)
            except Exception as e:
                if action == "returnDefaultValue":
                    return defaultRetValue
                elif action == "returnNone":
                    return None
                elif action == "returnExceptionName":
                    return type(e).__name__
                elif action == "raiseAgain":
                    raise
                else:
                    return None
        return wrapper
    return decorator

class SimpleNamespace:
    def __init__(self, **kwargs):
        self.kwargs = kwargs
    def __getattr__(self, key):
        return self.kwargs.get(key, None)
    def __repr__(self):
        return self.kwargs.__str__()

def get_func_addr(name):
    target = lldb.debugger.GetSelectedTarget()

    for mod in target.module_iter():
        syms = mod.FindSymbols(name, lldb.eSymbolTypeCode)
        for i in range(syms.GetSize()):
            sym = syms.GetContextAtIndex(i).GetSymbol()
            if sym and sym.GetName() == name and sym.GetType() == lldb.eSymbolTypeCode:
                return sym.GetStartAddress().GetLoadAddress(target)

    return None

def get_symbol_load_address(symbol_name):
    target = lldb.debugger.GetSelectedTarget()
    if not target:
        print("Error: No target selected.")
        return None

    # Ensure a process is running and not exited
    process = target.GetProcess()
    if not process or process.GetState() == lldb.eStateInvalid or \
       process.GetState() == lldb.eStateExited or process.GetState() == lldb.eStateDetached:
        print("Error: No live process to get load address. Please run or attach to your target.")
        return None

    symbol_context_list = target.FindSymbols(symbol_name)
    if symbol_context_list.GetSize() > 0:
        first_symbol_context = symbol_context_list.GetContextAtIndex(0)
        first_symbol = first_symbol_context.GetSymbol()

        if first_symbol and first_symbol.IsValid():
            start_address = first_symbol.GetStartAddress()
            if start_address.IsValid():
                # Attempt to get the load address
                load_address_value = start_address.GetLoadAddress(target) # Pass 'target' explicitly
                return load_address_value
    return None

def get_evaluated_value(expression: str):
    """
    Evaluates an expression in the current frame's context and returns the SBValue object.
    Returns None if the evaluation fails or preconditions are not met.

    Args:
        expression: The string expression to evaluate.

    Returns:
        An lldb.SBValue object if successful, otherwise None.
    """
    debugger = lldb.debugger
    target = debugger.GetSelectedTarget()
    if not target:
        print("Error: No target selected.") # Removed for simplification, you might add logging
        return None

    process = target.GetProcess()
    if not process or process.GetState() != lldb.eStateStopped:
        print("Error: Process is not stopped. EvaluateExpression requires a stopped process.")
        return None

    thread = process.GetSelectedThread()
    if not thread:
        print("Error: No thread selected.")
        return None

    frame = thread.GetSelectedFrame()
    if not frame:
        print("Error: No frame selected.")
        return None

    # Evaluate the expression
    # lldb.eDynamicCanRunTarget is generally a good default for most cases.
    expression_value = frame.EvaluateExpression(expression, lldb.eDynamicCanRunTarget)

    if expression_value.IsValid() and not expression_value.GetError().Fail():
        return expression_value
    else:
        print(f"Error evaluating expression '{expression}': {expression_value.GetError().GetCString()}")
        return None

def OutStringSummary(valobj, _):
    data = valobj.GetChildMemberWithName("data")
    start = valobj.GetChildMemberWithName("start")
    length = valobj.GetChildMemberWithName("length")

    error = lldb.SBError()
    offsetOfStringContent = 16 # cangjie stores the result string in data[16+start: 16+start+length]
    addr = data.Dereference().GetLoadAddress() + start.GetValueAsUnsigned(0) + offsetOfStringContent
    size = length.GetValueAsUnsigned(0)
    resStr = valobj.GetProcess().ReadCStringFromMemory(addr, size + 1, error)
    return resStr

def infer_is_class_type(sbtype):
    num_fields = sbtype.GetNumberOfFields()
    offsets = []
    for i in range(num_fields):
        member = sbtype.GetFieldAtIndex(i)  # SBTypeMember
        name = member.GetName()
        offset = member.GetOffsetInBytes()
        offsets.append(offset)
    # for class type, the first 8 bytes are typeinfo pointer
    if len(offsets) > 0:
        return min(offsets) > 0
    else:
        # basic value type, eg. Int/UInt
        return False

def ExtractLastPart(path: str) -> str:
    path = path.rstrip("/")
    if "/" not in path:
        return path
    return path.rsplit("/", 1)[-1]

def RemoveOuterQuotes(s: str) -> str:
    if len(s) < 2 or s[0] != '"' or s[-1] != '"':
        return s
    start, end = 0, len(s)
    while start < end and s[start] == '"':
        start += 1
    while end > start and s[end - 1] == '"':
        end -= 1
    return s[start:end]

def EscapeExpressionString(s):
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')

def FunctionSummaryProvider(valobj, _):
    raw = valobj.GetNonSyntheticValue()
    ptr = raw.GetChildMemberWithName("ptr")
    addr = ptr.GetValueAsUnsigned()
    target = valobj.GetTarget()
    sb_address = target.ResolveLoadAddress(addr)
    sb_context = target.ResolveSymbolContextForAddress(sb_address, lldb.eSymbolContextEverything)
    mangle_name = ""
    if (sb_context.GetFunction().IsValid()):
       mangle_name = sb_context.GetFunction().GetName()
    if (sb_context.GetSymbol().IsValid()):
       mangle_name = sb_context.GetSymbol().GetName()
    mangle_name = EscapeExpressionString(mangle_name)
    if mangle_name.startswith("_"):
        expr = f'(char *)CJ_MRT_DemangleHandle("{"_" + mangle_name}")'
    else:
        expr = f'(char *)CJ_MRT_DemangleHandle("{mangle_name}")'
    frame = valobj.thread.GetFrameAtIndex(0)
    func = frame.EvaluateExpression(expr)
    sbs_stream_le = lldb.SBStream()
    sbs_stream_m = lldb.SBStream()
    sb_context.GetLineEntry().GetDescription(sbs_stream_le)
    sb_context.GetModule().GetDescription(sbs_stream_m)
    line_entry = ExtractLastPart(sbs_stream_le.GetData())
    module_path = ExtractLastPart(sbs_stream_m.GetData())
    result = func.GetValue() + " (" + module_path + "`" + RemoveOuterQuotes(func.GetSummary()) + " at " + line_entry + ")"
    return result

def StringSummaryProvider(valobj, _):
    raw = valobj.GetNonSyntheticValue()
    data = raw.GetChildMemberWithName("myData")
    start = raw.GetChildMemberWithName("start")
    length = raw.GetChildMemberWithName("length")
    elements = data.GetChildMemberWithName("elements")
    addr =  elements.GetLoadAddress() + start.GetValueAsUnsigned(0)
    maxlen = length.GetValueAsUnsigned(0)
    if not addr or not maxlen:
        return ""
    error = lldb.SBError()
    str = valobj.GetProcess().ReadCStringFromMemory(addr, maxlen + 1, error)
    return "\"" + str + "\""

def RuneSummaryProvider(valobj, _):
    error = lldb.SBError()
    data_bytes = valobj.GetProcess().ReadMemory(valobj.GetLoadAddress(), 4, error)
    if not error.Success():
        return f"<Error: {error.GetCString()}>"
    rune_value = int.from_bytes(data_bytes, byteorder='little')
    control_chars = {
        0: '\\0',
        7: '\\a',
        8: '\\b',
        9: '\\t',
        10: '\\n',
        11: '\\v',
        12: '\\f',
        13: '\\r',
        27: '\\e',
        34: '\\"',
        ord('\\'): '\\\\',
        ord('\''): '\\\'',
    }
    if rune_value in control_chars:
        return f"'{control_chars[rune_value]}'"
    else:
        try:
            summary = data_bytes.decode('utf-32-le')
        except UnicodeDecodeError:
            return ""
        return "\'" + summary + "\'"


def Int8SummaryProvider(valobj,_):
    if valobj.GetTypeName() == "Int8":
        return valobj.GetValueAsSigned()
    return valobj.GetValueAsUnsigned()

def format_hex(hex_str):
    clean_hex = hex_str.lower().replace("0x", "")
    try:
        num = int(clean_hex, 16)
    except ValueError:
        raise ValueError("bad hex input")
    num_64bit = num & 0xFFFFFFFFFFFFFFFF
    return f"0x{num_64bit:016x}"

def CPointerSummaryProvider(valobj, _):
    obj = valobj.GetNonSyntheticValue()
    ptr = obj.GetChildMemberWithName("ptr")
    addr = ptr.GetValueAsUnsigned()
    return format_hex(hex(addr))

def CStringSummaryProvider(valobj, _):
    obj = valobj.GetNonSyntheticValue()
    chars = obj.GetChildMemberWithName("chars")
    cstr = chars.GetSummary()
    return cstr

def UnitSummaryProvider(valobj, _):
    return "()"

def RangeSummaryProvider(valobj, _):
  raw = valobj.GetNonSyntheticValue()
  start = raw.GetChildMemberWithName("start")
  end = raw.GetChildMemberWithName("end")
  step = raw.GetChildMemberWithName("step")
  closed = raw.GetChildMemberWithName("isClosed")
  hasStart = raw.GetChildMemberWithName("hasStart")
  hasEnd = raw.GetChildMemberWithName("hasEnd")
  result = ""
  if hasStart.IsValid() and hasStart.GetValue() == "true":
    result += str(start).split('= ', 1)[1]
  result += ".."
  if closed.IsValid() and closed.GetValue() == "true":
    result += "="
  if hasEnd.IsValid() and hasEnd.GetValue() == "true":
    result += str(end).split('= ', 1)[1]
  result += " : "
  if step.IsValid():
    result += str(step).split('= ', 1)[1]
  return result


def OptionSummaryProveder(valobj, _):
    raw = valobj.GetNonSyntheticValue()
    constructor = raw.GetChildMemberWithName("constructor")
    if not constructor.IsValid():
        return ""
    if constructor.GetValue() == "None":
        return "nullptr"
    val = raw.GetChildMemberWithName("val")
    if val.IsValid():
        if val.GetType().IsPointerType():
            val = val.Dereference()
            if not val.IsValid():
                return "nullptr"
            addr = val.GetLoadAddress()
            if addr == 0 or addr == UINT64_MAX:
                return "nullptr"
        if val.GetSummary():
            return val.GetSummary()
        if val.GetValue():
            return val.GetValue()

    recursive = raw.GetChildMemberWithName("Recursive-val")
    if recursive.IsValid():
        if recursive.GetType().IsPointerType():
            return recursive.GetValue()
        return hex(recursive.GetLoadAddress())
    return ""

def OptionPtrSummaryProveder(valobj, _):
    raw = valobj.GetNonSyntheticValue()
    if (raw.GetType().IsPointerType()):
        val = raw.Dereference()
        if not val.IsValid():
            return "nullptr"
        addr = val.GetLoadAddress()
        if addr == 0 or addr == UINT64_MAX:
            return "nullptr"
        return str(val).split('= ', 1)[1]
    return ""

def IsValobjDynamicType(valobj):
    valtype = valobj.GetType()
    if valtype.IsTypedefType():
        valtype = valtype.GetTypedefedType()
    if valtype.GetTypeClass() != lldb.eTypeClassClass:
        return False
    if valtype.GetDisplayTypeName().find("Interface$") != -1:
        return True
    type_name = GetTypeNameFromMemory(valobj)
    if type_name == "":
        return False
    if type_name != valobj.GetTypeName():
        return True
    return False

def SilentDelete(debugger, result):
    temp_result = lldb.SBCommandReturnObject()
    interpreter = debugger.GetCommandInterpreter()

    cmd1 = 'type summary delete --category cplusplus "char32_t ?\[[0-9]+\]"'
    interpreter.HandleCommand(cmd1, temp_result)
    error_output = temp_result.GetError()

    cmd2 = 'type summary delete --category system "^((un)?signed )?char ?\[[0-9]+\]$"'
    interpreter.HandleCommand(cmd2, temp_result)
    error_output += temp_result.GetError()

    patterns = [
        r"error: no custom formatter for char32_t ?\[[0-9]+\]\.?\n",
        r"error: no custom formatter for ((un)?signed )?char ?\[[0-9]+\]\.?\n"
    ]
    if all(re.search(p, error_output) for p in patterns):
        result.SetError("")
    else:
        result.SetError(error_output)

class CangjieVArraySyntheticProvider:
    def __init__(self, valobj, _):
        target = valobj.GetTarget()
        debugger = target.GetDebugger()
        SilentDelete(debugger, lldb.SBCommandReturnObject())
        self.valobj = valobj

    def num_children(self):
        return self.valobj.GetNumChildren()

    def get_child_at_index(self, index):
        return self.valobj.GetChildAtIndex(index)

    def get_child_index(self, name):
        pass

    def has_children(self):
        return True

class CangjieArraySyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        self.update()

    def update(self):
        self.rawptr = self.valobj.GetChildMemberWithName("rawptr")
        if (self.rawptr.IsValid()):
            self.elements = self.rawptr.GetChildMemberWithName("elements")
        self.start = self.valobj.GetChildMemberWithName("start")
        self.len = self.valobj.GetChildMemberWithName("len")

    def num_children(self):
        if (self.len.IsValid()):
            return self.len.GetValueAsUnsigned()
        return 0

    def get_child_at_index(self, index):
        if (self.elements.IsValid() and self.start.IsValid()):
            element_size = self.elements.GetType().GetByteSize()
            if not self.elements.GetAddress().IsValid():
                return None
            start_address = self.elements.GetLoadAddress()
            addr = start_address + (self.start.GetValueAsUnsigned(0) + index) * element_size
            value = self.valobj.CreateValueFromAddress(f"[{index}]", addr, self.elements.GetType())
            if value.GetType().IsPointerType():
                if value.GetValueAsUnsigned() == 0:
                    value = value.CreateValueFromAddress(f"[{index}]", addr, value.GetType().GetPointeeType())
                    value.SetSyntheticChildrenGenerated(True)
                else:
                    value = value.Dereference()
                    if value and value.IsValid() and value.GetName().startswith("*"):
                        name = value.GetName()[1:]
                        value = self.valobj.CreateValueFromAddress(name, value.GetLoadAddress(), value.GetType())
        if (value.IsValid()):
            if IsValobjDynamicType(value):
                anytype = self.valobj.GetTarget().FindFirstType("Interface$Any")
                value = self.valobj.CreateValueFromAddress(value.GetName(), value.GetLoadAddress(), anytype)
            return value
        return None

    def get_child_index(self, name):
        pass

    def has_children(self):
        return True

    def get_type_name(self):
        displayname = DeletePrefixOfTypename(self.valobj.GetDisplayTypeName(), "const ")
        return displayname.replace("::", ".")

class CangjieArrayListSyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        self.update()

    def update(self):
        self.data = CangjieArraySyntheticProvider(self.valobj.GetChildMemberWithName("myData"), None)
        self.size = self.valobj.GetChildMemberWithName("mySize").GetValueAsUnsigned(0)

    def get_child_at_index(self, index):
        value = self.data.get_child_at_index(index)
        return value

    def num_children(self):
        return 0 if self.size > 0xFFFFFFFF else self.size

    def get_child_index(self, name):
        pass

    def has_children(self):
        return True

    def get_type_name(self):
        displayname = DeletePrefixOfTypename(self.valobj.GetDisplayTypeName(), "const ")
        return displayname.replace("::", ".")

class CangjieTupleSyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        self.update()

    def update(self):
        self.size = self.valobj.GetNumChildren()

    def get_child_at_index(self, index):
        value = self.valobj.GetChildAtIndex(index)
        addr = value.GetLoadAddress()
        value = self.valobj.CreateValueFromAddress(f"[{index}]", addr, value.GetType())
        if value.GetType().IsPointerType():
            if value.GetValueAsUnsigned() == 0:
                value = value.CreateValueFromAddress(f"[{index}]", addr, value.GetType().GetPointeeType())
                value.SetSyntheticChildrenGenerated(True)
            else:
                value = value.Dereference()
                if hasattr(value, 'IsValid') and value.IsValid() and value.GetName().startswith("*"):
                    name = value.GetName()[1:]
                    return self.valobj.CreateValueFromAddress(name, value.GetLoadAddress(), value.GetType())
        return value

    def num_children(self):
        return self.size

    def get_child_index(self, name):
        pass

    def has_children(self):
        return True

    def get_type_name(self):
        return None

class CangjieSummaryDisplayTypeSyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        pass

    def update(self):
        pass

    def get_child_at_index(self, index):
        pass

    def num_children(self):
        return 0

    def get_child_index(self, name):
        pass

    def has_children(self):
        return True

    def get_type_name(self):
        return self.valobj.GetTypeName().replace("const ", "").replace("::", ".")

class CanjieHashMapEntrySyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj

    @WhenException()
    def get_child_at_index(self, index):
        value = self.valobj.GetChildAtIndex(index + 2)
        if value.IsValid() and value.GetType().IsPointerType():
            value = value.Dereference()
        return value

    @WhenException()
    def num_children(self):
        return 2

    def get_child_index(self, name):
        pass

    @WhenException()
    def has_children(self):
        return True

class CangjieHashMapSyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        self.IsHashSet = False
        self.numEntries = 0
        self.entryIndexes = []
        self.update()

    @WhenException()
    def update(self):
        appendIndex = self.valobj.GetChildMemberWithName("appendIndex")
        freeSize = self.valobj.GetChildMemberWithName("freeSize")
        self.numEntries = appendIndex.GetValueAsSigned() - freeSize.GetValueAsSigned()
        if self.numEntries < 0: self.numEntries = 0

        entries = self.valobj.GetChildMemberWithName("entries")
        if entries.IsValid():
            self.data = CangjieArraySyntheticProvider(entries, None)
        else:
            self.data = None

    @WhenException()
    def get_child_at_index(self, index):
        if not self.data:
            return None

        if index >= self.numEntries:
            return None

        startIndex = 0 if len(self.entryIndexes) == 0 else self.entryIndexes[-1] + 1
        entriesCapacity = self.data.num_children()
        while startIndex <= entriesCapacity:
            siEntry = self.data.get_child_at_index(startIndex)
            siEntry = siEntry.GetNonSyntheticValue()
            hashCode = siEntry.GetChildMemberWithName("hash").GetValueAsSigned()
            if not (hashCode < 0):
                self.entryIndexes.append(startIndex)
                if len(self.entryIndexes) > index: break
            startIndex += 1

        if index >= len(self.entryIndexes):
            return None

        entryIndex = self.entryIndexes[index]
        value = self.data.get_child_at_index(entryIndex)
        if not value.IsValid():
            return None
        if self.IsHashSet:
            value = value.GetChildAtIndex(0)
            return value.CreateValueFromAddress(f"[{index}]", value.GetLoadAddress(), value.GetType())
        key = value.GetNonSyntheticValue().GetChildMemberWithName("key")
        val = value.GetNonSyntheticValue().GetChildMemberWithName("value")
        if val.GetType().IsPointerType(): val = val.Dereference()

        keysummary = self.get_oneword_summary(key)
        valsummary = self.get_oneword_summary(val)
        if not keysummary:
            name = f"[{index}]"
        elif not valsummary:
            name = f"[{keysummary}]"
        else:
            name = f"[{keysummary} -> {valsummary}]"
        value = value.CreateValueFromAddress(name, value.GetLoadAddress(), value.GetType())
        return value

    @WhenException()
    def num_children(self):
        return self.numEntries

    @WhenException()
    def get_child_index(self, name):
        pass

    def has_children(self):
        return True

    def get_oneword_summary(self, obj):
        if obj.TypeIsPointerType():
            obj = obj.Dereference()
        if obj_summary := obj.GetSummary():
            return obj_summary
        if obj_value := obj.GetValue():
            return obj_value
        return None

    def SetIsHashSet(self, IsHashSet = True):
        self.IsHashSet = IsHashSet

    def IsHashSet(self):
        return self.IsHashSet

class CangjieHashSetSyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        self.update()

    @WhenException()
    def update(self):
        map = self.valobj.GetChildMemberWithName("map")
        self.data = CangjieHashMapSyntheticProvider(map, None)
        self.data.SetIsHashSet(True)

    @WhenException()
    def get_child_at_index(self, index):
        return self.data.get_child_at_index(index)

    @WhenException()
    def num_children(self):
        return self.data.num_children()

    def get_child_index(self, name):
        pass

    def has_children(self):
        return True

    def get_type_name(self):
        return None

def DeletePrefixOfTypename(type_name, prefix):
    if type_name is None:
        return ""
    while type_name.find(prefix) != -1:
        index = type_name.find(prefix)
        type_name = type_name[:index] + type_name[index + len(prefix):]
    return type_name

class CangjieSyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        self.update()

    def update(self):
        valobj = self.valobj
        if not valobj.IsValid() or not IsValobjDynamicType(valobj):
            return
        # the valobj is dynamic type
        typename = GetTypeNameFromMemory(valobj)
        dynamictype = valobj.GetTarget().FindFirstType(typename)
        if not dynamictype.IsValid():
            return
        # the dynamic type is not class
        if dynamictype.GetTypeClass() != lldb.eTypeClassClass:
            self.valobj = valobj.CreateValueFromAddress(
                valobj.GetName(), valobj.GetLoadAddress() + 8, dynamictype)
            return

        valtype = valobj.GetType()
        if valtype.IsTypedefType():
            valtype = valtype.GetTypedefedType()
        valTypeName = valtype.GetDisplayTypeName().replace("::", ".")

        # If the name of valobj is typename, then the valobj is an inherited class, no need to use dynamictype.
        if valobj.GetName() != valTypeName:
            self.valobj = valobj.CreateValueFromAddress(
                valobj.GetName(), valobj.GetLoadAddress(), dynamictype)

    def num_children(self):
        return self.valobj.GetNumChildren()

    def get_child_index(self, name):
        pass

    def get_child_at_index(self, index):
        value = self.valobj.GetChildAtIndex(index)
        if value.GetType().IsPointerType() and value.GetValueAsUnsigned() != 0:
            value = value.Dereference()
            if hasattr(value, 'IsValid') and value.IsValid():
                if value.GetName().startswith("*"):
                    name = value.GetName()[1:]
                    return self.valobj.CreateValueFromAddress(name, value.GetLoadAddress(), value.GetType())
                else:
                    return value
        name = value.GetName()
        if name and name.find("::") != -1:
            name = name.replace("::", ".")
            value = self.valobj.CreateValueFromAddress(name, value.GetLoadAddress(), value.GetType())
        return value

    def has_children(self):
        return True

    def get_type_name(self):
        # change typename from "default::E0$E0" to "default.E0"
        displayname = DeletePrefixOfTypename(self.valobj.GetDisplayTypeName(), "E0$")
        displayname = DeletePrefixOfTypename(displayname, "const ")
        return displayname.replace("::", ".")

# enum E0 {
#     A | B | C
# }
def CangjieEnum0SummaryProvider(valobj, _):
    if valobj.GetType().IsPointerType():
        return ""
    raw = valobj.GetNonSyntheticValue()
    ctor = raw.GetChildMemberWithName("constructor")
    enum_members = ctor.GetType().GetEnumMembers()
    enum_size = enum_members.GetSize()
    if enum_size == 0:
        return None
    ctor_id = ctor.GetValueAsUnsigned()
    if ctor_id >= enum_size:
        ctor_id = 0
    val = enum_members[ctor_id]
    return val.GetName()

# enum E1 {
#     A(Int64) | B(Int64, Class) | C
# }
class CangjieEnum1SyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        self.update()

    def update(self):
        for i in range(self.valobj.GetNumChildren()):
            ctor = self.valobj.GetChildAtIndex(i)
            if (ctor.IsValid()):
                ctor_type = ctor.GetChildMemberWithName("constructor")
                ctor_id = ctor_type.GetValueAsUnsigned()
                self.data = self.valobj.GetChildAtIndex(ctor_id)
                break
        if hasattr(self, 'data') and self.data.IsValid():
            ctor = self.data.GetChildMemberWithName("constructor")
            if ctor != None:
                value = ctor.GetValue()
                if hasattr(value, 'IsValid') and value.IsValid():
                    self.data = self.valobj.CreateValueFromAddress("arg_1", value.GetLoadAddress(), value.GetType())

    def num_children(self):
        if hasattr(self, 'data') and self.data.IsValid():
            return self.data.GetNumChildren()
        else:
            return 0

    def get_child_at_index(self, index):
        if hasattr(self, 'data') and self.data.IsValid():
            value = self.data.GetChildAtIndex(index)
            if value.GetType().IsPointerType() and value.GetValueAsUnsigned() != 0:
                value = value.Dereference()
            if hasattr(value, 'IsValid') and value.IsValid():
                if value.GetName().startswith("*"):
                    name = value.GetName()[1:]
                    return self.valobj.CreateValueFromAddress(name, value.GetLoadAddress(), value.GetType())
                else:
                    return value
        return None

    def get_child_index(self, name):
        pass

    def has_children(self):
        return True

    def get_type_name(self):
        type_name = self.valobj.GetTypeName()
        displayname = DeletePrefixOfTypename(type_name, "E1$")
        displayname = displayname.replace("::", ".")
        return displayname

# enum E2<T> {
#     A | B(T)
# }
# var a = E2<Int64>.A
def CangjieEnum2SummaryProvider(valobj, _):
    if valobj.GetType().IsPointerType():
        deref_val_type = valobj.GetType().GetPointeeType()
        if deref_val_type.IsPointerType():
            return ""
        raw = valobj.GetNonSyntheticValue()
        if not raw.GetFrame().FindVariable(raw.GetName()):
            return ""
        # Non-reference type enum
        enum_ctor = raw.GetChildMemberWithName("constructor")
        if enum_ctor.IsValid():
            return ""
        # Reference type enum
        enum_ctor = raw.GetChildMemberWithName("constructor_R")
        enum_ctor_type = enum_ctor.GetType()
        enum_members = enum_ctor_type.GetEnumMembers()
        if enum_members.GetSize() != 2:
            return ""
        ptr = raw.GetValueAsUnsigned()
        if ptr == 0 or ptr == 1:
            for member in enum_members:
                enum_name = member.GetName()
                if hasattr(enum_name, 'startswith') and enum_name.startswith("N$_"):
                    enum_name = enum_name[3:]
                    return enum_name
        else:
            deref = raw.Dereference()
            return str(deref).split('= ', 1)[1]

    raw = valobj.GetNonSyntheticValue()
    ctor = raw.GetChildMemberWithName("constructor")
    if not ctor.IsValid():
        if raw.IsSyntheticChildrenGenerated():
            enum_ctor = valobj.GetType().GetFieldAtIndex(0)
            enum_ctor_type = enum_ctor.GetType()
            enum_members = enum_ctor_type.GetEnumMembers()
            for member in enum_members:
                enum_name = member.GetName()
                if hasattr(enum_name, 'startswith') and enum_name.startswith("N$_"):
                    enum_name = enum_name[3:]
                    return enum_name
        return ""
    value = ctor.GetValue()
    if hasattr(value, 'startswith') and value.startswith("N$_"):
        value = value[3:]
        return value
    else:
        return ""

# case1:
# enum E2<T> {
#     B(T) | A
# }
# var a = E2<Int64>.B(5)
# case2:
# class A {}
# enum E2<T> {
#     B | C(T)
# }
# var b = E2<A>.C(A())
class CangjieEnum2SyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        self.update()

    def update(self):
        if self.valobj.GetType().IsPointerType():
            deref_val_type = self.valobj.GetType().GetPointeeType()
            if deref_val_type.IsPointerType():
                return
            for i in range(deref_val_type.GetNumberOfFields()):
                field = deref_val_type.GetFieldAtIndex(i)
                field_name = field.GetName()
                if field_name and "constructor" in field_name:
                    self.ctor_type = field.GetType()

            if not (hasattr(self, 'ctor_type') and self.ctor_type.IsValid()):
                return
            # top-level object and nullptr
            obj = self.valobj.GetFrame().FindVariable(self.valobj.GetName())
            if obj and self.valobj.GetValueAsUnsigned() == 0:
                ret = self.valobj.SetValueFromCString("1")
            return

        # Non-reference type: "constructor", Reference type: "constructor_R".
        enum_type = self.valobj.GetType()
        enum_ctor = enum_type.GetFieldAtIndex(0)
        if not enum_ctor.IsValid():
            return
        enum_ctor_type = enum_ctor.GetType()
        enum_id = 0
        for member in enum_ctor_type.GetEnumMembers():
            enum_name = member.GetName()
            if hasattr(enum_name, 'startswith') and not enum_name.startswith("N$_"):
                break
            enum_id = enum_id + 1

        enum_data = lldb.SBData()
        err = lldb.SBError()
        target = self.valobj.GetTarget()
        # Use `struct.pack` to pack integer values into a byte stream, '<I' represents a little-endian uint32.
        raw_data = struct.pack('<I', enum_id)
        enum_data.SetData(err, raw_data, target.GetByteOrder(), target.GetAddressByteSize())
        self.ctor = self.valobj.CreateValueFromData("constructor", enum_data, enum_ctor_type)

        self.ctor_type = self.ctor.GetType()
        data = self.valobj.GetChildMemberWithName("val")
        if data.IsValid():
            self.data = self.valobj.CreateValueFromAddress("arg_1", data.GetLoadAddress(), data.GetType())

    def num_children(self):
        if hasattr(self, 'data') and self.data.IsValid():
            return 2
        else:
            return 0

    def get_child_at_index(self, index):
        if index == 0:
            if hasattr(self, 'ctor'):
                return self.ctor
        else:
            if self.data.GetType().IsPointerType():
                if self.data.GetValueAsUnsigned() == 0:
                    enum_type = self.data.GetType().GetPointeeType()
                    value = self.data.CreateValueFromAddress("arg_1", self.data.GetLoadAddress(), enum_type)
                    value.SetSyntheticChildrenGenerated(True)
                    return value
                else:
                    value = self.data.Dereference()
                    if hasattr(value, 'IsValid') and value.IsValid():
                        if value.GetName().startswith("*"):
                            name = value.GetName()[1:]
                            return self.valobj.CreateValueFromAddress(name, value.GetLoadAddress(), value.GetType())
                        else:
                            return value

            return self.data

    def get_child_index(self, name):
        pass

    def has_children(self):
        if hasattr(self, 'data') and self.data.IsValid():
            return True
        else:
            return False

    def get_type_name(self):
        if hasattr(self, 'ctor_type') and self.ctor_type.IsValid():
            type_name = self.ctor_type.GetDisplayTypeName()
        else:
            type_name = self.valobj.GetTypeName()
        displayname = DeletePrefixOfTypename(type_name, "E2$")
        displayname = displayname.replace("::", ".")
        return displayname

# enum E3 {
#     A(Int64) | B(Int64, Int32) | C
# }
class CangjieEnum3SyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        self.update()

    def update(self):
        ctor = self.valobj.GetChildAtIndex(0)
        if (ctor.IsValid()):
            ctor_type = ctor.GetChildMemberWithName("constructor")
            ctor_id = ctor_type.GetValueAsUnsigned()
            self.data = self.valobj.GetChildAtIndex(ctor_id)

    def num_children(self):
        if hasattr(self, 'data') and self.data.IsValid():
            return self.data.GetNumChildren()
        else:
            return 0

    def get_child_at_index(self, index):
        if hasattr(self, 'data') and self.data.IsValid():
            value = self.data.GetChildAtIndex(index)
            if value.GetType().IsPointerType():
                value = value.Dereference()
            if value.IsValid():
                return value
        return None

    def get_child_index(self, name):
        pass

    def has_children(self):
        return True

    def get_type_name(self):
        type_name = self.valobj.GetTypeName()
        displayname = DeletePrefixOfTypename(type_name, "E3$")
        displayname = displayname.replace("::", ".")
        return displayname

@WhenException()
def GetTypeNameFromMemory(valobj):
    addr = valobj.GetLoadAddress()
    error = lldb.SBError()
    typeinfo_addr = valobj.GetProcess().ReadPointerFromMemory(addr, error)
    typeinfo_addr = typeinfo_addr & 0x0000_FFFF_FFFF_FFFF # GC runtime uses high 16 bits as state word
    if error.Fail():
        return ""
    name_addr = valobj.GetProcess().ReadPointerFromMemory(typeinfo_addr, error)
    if error.Fail():
        return ""
    type_name = valobj.GetProcess().ReadCStringFromMemory(name_addr, 50, error)
    if error.Fail():
        return ""
    type_name = type_name.replace(":", "::")
    return type_name

def GetVaildEnumType(valobj, type_name):
    names = type_name.split("::", 1)
    if len(names) != 2:
        return None
    enumtype_name = names[0] + "::E0$" + names[1]
    enumtype = valobj.GetTarget().FindFirstType(enumtype_name)
    if not enumtype.IsValid():
        enumtype_name = names[0] + "::E1$" + names[1]
        enumtype = valobj.GetTarget().FindFirstType(enumtype_name)
        if not enumtype.IsValid():
            enumtype_name = names[0] + "::E2$" + names[1]
            enumtype = valobj.GetTarget().FindFirstType(enumtype_name)
            if not enumtype.IsValid():
                enumtype_name = names[0] + "::E3$" + names[1]
                enumtype = valobj.GetTarget().FindFirstType(enumtype_name)
            else:
                enumtype = enumtype.GetPointerType()
    return enumtype

class CangjieGTSyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj
        self.update()

    @WhenException()
    def update(self):
        addr = self.valobj.GetLoadAddress()
        rawTypeName = self.valobj.GetType().GetName()
        type_name = GetTypeNameFromMemory(self.valobj)
        if type_name == "":
            return False

        isEnum = False
        if re.match("(.+)?E0\\$(.+)", rawTypeName) or \
                re.match("(.+)?E1\\$(.+)", rawTypeName) or \
                re.match("(.+)?E2\\$(.+)", rawTypeName) or \
                re.match("(.+)?E3\\$(.+)", rawTypeName):
            isEnum = True
            prefix = "E0$"
            if 'E1' in rawTypeName: prefix = "E1$"
            elif 'E2' in rawTypeName: prefix = "E2$"
            elif 'E3' in rawTypeName: prefix = "E3$"
            self.type_name = prefix + type_name.split("::")[1]
        else:
            self.type_name = type_name
        sbtype = self.valobj.GetTarget().FindFirstType(self.type_name)
        if sbtype.IsScopedEnumerationType():
            enumtype = GetVaildEnumType(self.valobj, self.type_name)
            if enumtype.IsValid():
                sbtype = enumtype
                isEnum = True
        if sbtype.IsValid():
            name = self.valobj.GetName()
            if not isEnum and infer_is_class_type(sbtype):
                self.data = self.valobj.CreateValueFromAddress(name, addr, sbtype)
            else:
                self.data = self.valobj.CreateValueFromAddress(name, addr + 8, sbtype)
            if isEnum and sbtype.IsPointerType():
                if self.data.GetValueAsUnsigned() == 0 or self.data.GetValueAsUnsigned() == 1:
                    self.data = self.valobj.CreateValueFromAddress(name, addr + 8, sbtype.GetPointeeType())
                    self.data.SetSyntheticChildrenGenerated(True)
                else:
                    value = self.data.Dereference()
                    self.data = value
            return True
        else:
            return False

    @WhenException()
    def get_child_at_index(self, index):
        data = getattr(self, 'data', None)
        if data and data.IsValid():
            return data.GetChildAtIndex(index)
        return None

    @WhenException()
    def num_children(self):
        data = getattr(self, 'data', None)
        if data and data.IsValid():
            return data.GetNumChildren()
        return 0

    def get_child_index(self, name):
        pass

    def has_children(self):
        data = getattr(self, 'data', None)
        if data and data.IsValid():
            return True
        return False

    def get_type_name(self):
        return self.type_name

    def to_string(self):
        if not self.data.IsValid():
            return ""
        if self.data.GetSummary():
            return self.data.GetSummary()
        if self.data.GetValue():
            return self.data.GetValue()
        return ""

@WhenException()
def CangjieGTSummaryProvider(valobj, _):
    return CangjieGTSyntheticProvider(valobj, None).to_string()

@WhenException()
def toStringSummaryProvider(valobj, idict):
    valobjType = valobj.GetType()
    typeName = valobjType.GetName()

    toStringSymbolName = typeName + "::toString()" # demangled name
    typeInfoName = typeName.replace("::", ":") + ".ti"
    for i in range(valobjType.GetNumberOfMemberFunctions()):
        func = valobjType.GetMemberFunctionAtIndex(i)
        if func.GetName() == "toString":
            toStringSymbolName = func.GetMangledName()

    valueAddress = valobj.GetLoadAddress()
    toStringAddr = get_func_addr(toStringSymbolName)
    if toStringAddr is None:
        return f"<error: cannot find address of target object's toString `{toStringSymbolName}`>"

    typeInfoAddr = get_symbol_load_address(typeInfoName)
    if typeInfoAddr is None:
        return f"<error: cannot find address of target object's type info `{typeInfoName}`>"

    invokeToString = f"""
struct string_t {{ char *data; int start, length; }} result = {{ 0 }};
((void (*)(void *, void *, void *))0x{toStringAddr:x})(
&result,
(void *)0x{valueAddress:x},
(void *)0x{typeInfoAddr:x});
result
""".replace('\n', ' ').strip()
    outValue = get_evaluated_value(invokeToString)
    if not outValue or not outValue.IsValid():
        return None
    return OutStringSummary(outValue, idict)

@WhenException()
def TimeZoneSummaryProvider(valobj, internal_dict):
    localTimesObj = valobj.GetChildMemberWithName("localTimes")
    if not localTimesObj.IsValid():
        return None

    zoneIdObj = valobj.GetChildMemberWithName("zoneId")
    if not zoneIdObj.IsValid():
        return None
    zoneId = StringSummaryProvider(zoneIdObj, internal_dict)

    return f"TimeZone({zoneId})"

@WhenException()
class CangjieDateTimeFormatter:
    class Month(Enum):
        January = 1
        February = 2
        March = 3
        April = 4
        May = 5
        June = 6
        July = 7
        August = 8
        September = 9
        October = 10
        November = 11
        December = 12

        @classmethod
        def of(cls, idx: int):
            return cls(idx)

    def __init__(self, epoch, offset, nanosecs = 0):
        self.epoch = epoch
        self.offset = offset
        self.nanosecs = nanosecs

    START_AD_YEAR = 1
    MIN_YEAR = -999999999
    MAX_YEAR = 999999999
    SECS_PER_DAY = 86400
    DAYS_PER_400YEARS = 146097
    DAYS_PER_100YEARS = 36524
    DAYS_PER_4YEARS = 1461
    DAYS_OF_NORMAL_YEAR = 365
    SECS_PER_HOUR = 3600
    SECS_PER_MINUTE = 60
    DAYS_OF_MAX_TO_AD1 = (MAX_YEAR - 1) * 365 + (MAX_YEAR - 1) // 4 - (MAX_YEAR - 1) // 100 + (MAX_YEAR - 1) // 400 + 365
    DAYS_OF_MIN_TO_AD1 = -(DAYS_OF_MAX_TO_AD1 + 366)
    SECS_OF_MIN_TO_AD1 = DAYS_OF_MIN_TO_AD1 * SECS_PER_DAY
    DAYS_BEFORE = [
        0,        # January
        31,       # February
        31 + 28,  # March
        31 + 28 + 31,
        31 + 28 + 31 + 30,
        31 + 28 + 31 + 30 + 31,
        31 + 28 + 31 + 30 + 31 + 30,
        31 + 28 + 31 + 30 + 31 + 30 + 31,
        31 + 28 + 31 + 30 + 31 + 30 + 31 + 31,
        31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30,
        31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31,
        31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30,
        365
    ]

    @property
    def year(self) -> int:
        return self.getYearAndSecond()[0]

    @property
    def month(self):
        return self.getMonthAndDay()[0]

    @property
    def dayOfMonth(self) -> int:
        return self.getMonthAndDay()[1]

    @property
    def hour(self) -> int:
        second = self.getYearAndSecond()[1]
        return (second % self.SECS_PER_DAY) // self.SECS_PER_HOUR

    @property
    def minute(self) -> int:
        second = self.getYearAndSecond()[1]
        return (second % self.SECS_PER_HOUR) // self.SECS_PER_MINUTE

    @property
    def second(self) -> int:
        second = self.getYearAndSecond()[1]
        return second % self.SECS_PER_MINUTE

    @property
    def nanosecond(self) -> int:
        return self.nanosecs

    def getMonthAndDay(self) -> Tuple[Month, int]:
        year_after, second_after = self.getYearAndSecond()
        return self.getDate(year_after, second_after)

    def getDate(self, year: int, sec: int) -> Tuple[Month, int]:
        days = sec // self.SECS_PER_DAY
        if self.isLeapYear(year):
            if days == self.DAYS_BEFORE[2]:
                return (Month.February, 29)
            if days > self.DAYS_BEFORE[2]:
                days -= 1

        idx = 0
        day = 0
        while idx < len(self.DAYS_BEFORE):
            if days == self.DAYS_BEFORE[idx]:
                idx += 1
                day = 1
                break

            if days < self.DAYS_BEFORE[idx]:
                day = days - self.DAYS_BEFORE[idx-1] + 1
                break

            idx += 1

        month = CangjieDateTimeFormatter.Month.of(idx)
        return (month, day)

    def isLeapYear(self, year: int) -> bool:
        return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)

    def getYearAndSecond(self):
        offset = self.getOffset()
        year, sec = self.toYearAndSecond(self.epoch + offset)
        return (year, int(sec))

    def toYearAndSecond(self, sec) -> Tuple[int, int]:
        year = self.START_AD_YEAR
        seconds = sec

        if seconds < 0:
            seconds -= self.SECS_OF_MIN_TO_AD1
            year = self.MIN_YEAR

        days = seconds // self.SECS_PER_DAY
        rest_sec = seconds % self.SECS_PER_DAY

        times = days // self.DAYS_PER_400YEARS
        year += 400 * times
        days %= self.DAYS_PER_400YEARS

        times = days // self.DAYS_PER_100YEARS
        times -= times >> 2
        year += 100 * times
        days -= self.DAYS_PER_100YEARS * times

        times = days // self.DAYS_PER_4YEARS
        year += 4 * times
        days %= self.DAYS_PER_4YEARS

        times = days // self.DAYS_OF_NORMAL_YEAR
        times -= times >> 2
        year += times
        days -= self.DAYS_OF_NORMAL_YEAR * times

        sec_in_year = rest_sec + days * self.SECS_PER_DAY
        return (year, sec_in_year)

    def getOffset(self):
        return self.offset

    def addZeroPrefix(self, value: int, length: int):
        sign = '-' if value < 0 else ''
        num_str = str(abs(value))
        num_str = num_str.rjust(length, '0')
        return sign + num_str

    def toString(self):
        res = self.addZeroPrefix(self.year, 4)
        res += '-'
        res += self.addZeroPrefix(self.month.value, 2)
        res += '-'
        res += self.addZeroPrefix(self.dayOfMonth, 2)
        res += 'T'
        res += self.addZeroPrefix(self.hour, 2)
        res += ':'
        res += self.addZeroPrefix(self.minute, 2)
        res += ':'
        res += self.addZeroPrefix(self.second, 2)
        if (self.nanosecond != 0):
            nano = self.nanosecond
            times = 0
            while nano % 10 == 0:
                times += 1
                nano //= 10
            res += '.'
            res += self.addZeroPrefix(nano, 9 - times)
        res += self.toOffsetString(4)
        return res

    def toOffsetString(self, length):
        offset = self.getOffset()
        if offset < 0:
            sign = "-"
            off = -offset
        else:
            sign = "+"
            off = offset

        hour = off // 3600
        minute = (off % 3600) // 60
        second = off % 60

        if length > 3 and offset == 0:
            return "Z"
        elif (length == 3) or (length > 3 and second != 0):
            return f"{sign}{hour:02d}:{minute:02d}:{second:02d}"
        elif (length == 2) or (length > 3):
            return f"{sign}{hour:02d}:{minute:02d}"
        else:
            return f"{sign}{hour:02d}"

@WhenException()
def DateTimeSummaryProvider(valobj, internal_dict):
    # Refer the cangjie's library implementation and RFC8536
    # Retrieved layout of std.time.DateTime from lldb
    # (std.time::DateTime) a = {
    #   # from cangjie's source code:
    #   #   The d records the duration since A.D.1.
    #   d = (sec = 63422352000, ns = 0)
    #   tz = 0x00007fffd75b9fb8
    # }
    #
    # (std.time::TimeZone) b = {
    #    # note, due to the unknown python version, zoneId cannot be
    #    # utilized below python3.8 as zoneinfo is not included in the std libs
    #    zoneId = ""        # a Cangjie String object, eg "UTC"
    #    localTimes = Array # transition offset
    #    transTimes = Array # transition time
    # }
    dObj = valobj.GetNonSyntheticValue().GetChildMemberWithName("d")
    if not dObj.IsValid():
        return None

    secObj = dObj.GetChildMemberWithName("sec")
    if not secObj.IsValid():
        return None

    nsecObj = dObj.GetChildMemberWithName("ns")
    if not nsecObj.IsValid():
        return None
    nanosecs = nsecObj.GetValueAsUnsigned()

    tzObj = valobj.GetNonSyntheticValue().GetChildMemberWithName("tz")
    if not tzObj.IsValid():
        ad1Epoch = secObj.GetValueAsUnsigned()
        ad1Date = datetime.datetime(1, 1, 1) + datetime.timedelta(seconds = ad1Epoch)
        return ad1Date.strftime("%Y-%m-%dT%H:%M:%SZ")

    zoneIdObj = tzObj.GetChildMemberWithName("zoneId")
    if not zoneIdObj.IsValid():
        return None
    zoneId = StringSummaryProvider(zoneIdObj, internal_dict)

    localTimesObj = tzObj.GetChildMemberWithName("localTimes")

    localTimesSynthetic = CangjieArraySyntheticProvider(localTimesObj, internal_dict)
    localTimes = []
    for i in range(localTimesSynthetic.num_children()):
        ithObj = localTimesSynthetic.get_child_at_index(i)
        ithObj = ithObj.GetNonSyntheticValue()
        localTimes.append(SimpleNamespace(
            des = StringSummaryProvider(ithObj.GetChildMemberWithName("des"), internal_dict),
            offset = ithObj.GetChildMemberWithName("offset").GetValueAsSigned(),
            isDST = bool(ithObj.GetChildMemberWithName("isDST").GetValueAsUnsigned()),
            ))

    transTimes_obj = tzObj.GetChildMemberWithName("transTimes")
    transTimes_synthetic = CangjieArraySyntheticProvider(transTimes_obj, internal_dict)
    transTimes = []
    for i in range(transTimes_synthetic.num_children()):
        ithObj = transTimes_synthetic.get_child_at_index(i)
        ithObj = ithObj.GetNonSyntheticValue()
        transTimes.append(SimpleNamespace(
            trans = ithObj.GetChildMemberWithName("trans").GetValueAsSigned(),
            index = ithObj.GetChildMemberWithName("index").GetValueAsUnsigned(),
            ))

    ad1Epoch = secObj.GetValueAsSigned()
    utcEpoch = ad1Epoch - (datetime.datetime(1970, 1, 1) - datetime.datetime(1, 1, 1)).total_seconds()

    # no transition in the history or the epoch is early than the first transition
    if len(transTimes) == 0 or utcEpoch < transTimes[0].trans:
        # needs to infer, rules from the cj's library

        def InferRuleEarlierThanFirstTransition():
            # rule 1, if 0-th localtime is unused, it's the rule used for stage earlier than first transition
            unused = not any([t.index == 0 for t in transTimes])
            if unused:
                return 0

            # rule 2,
            #
            # Absent the above, if there are transition times and the first transition is to a daylight time,
            # find the standard type less than and closest to the zone of the first transition.
            if len(transTimes) > 0 and localTimes[transTimes[0].index].isDST:
                index = transTimes[0].index - 1
                for zoneIndex in range(index, -1, -1):
                    if not localTimes[zoneIndex].isDST:
                        return zoneIndex

            # If no result yet, find the first standard type.
            for zoneIndex in range(0, localTimes.size):
                if not localTimes[zoneIndex].isDST:
                    return zoneIndex

            return 0

        if len(localTimes) > 0:
            ruleIndex = InferRuleEarlierThanFirstTransition()
            zoneOffset = localTimes[ruleIndex].offset
        else:
            zoneOffset = 0
    else:
        # binary search in the transTimes, find first stage later than utcEpoch
        low = 0
        high = len(transTimes)
        while (high - low > 1):
            mid = int((low + high) / 2)
            curTime = transTimes[mid].trans
            if (utcEpoch < curTime):
                high = mid
            else:
                low = mid
        ruleIndex = transTimes[low].index
        zoneOffset = localTimes[ruleIndex].offset

    # note: datetime does not support datetime > 99999,
    #       we have to manually convert here
    return CangjieDateTimeFormatter(ad1Epoch, zoneOffset, nanosecs).toString()

class CangjieOptionSyntheticProvider:
    def __init__(self, valobj, _):
        self.valobj = valobj.GetNonSyntheticValue()
        self.hasvalue = False
        self.children = False
        self.some: lldb.SBValue = None
        self.update()

    def update(self):
        if self.valobj.GetType().IsPointerType():
            self.valobj = self.valobj.Dereference().GetNonSyntheticValue()
        value  = self.valobj.GetChildMemberWithName("val")
        if not value.IsValid():
            value  = self.valobj.GetChildMemberWithName("Recursive-val")
        if not value.IsValid():
            return False
        value.SetPreferSyntheticValue(True)
        self.some = value
        self.hasvalue = True
        self.children = self.some.GetNumChildren() > 0

    def get_child_at_index(self, index):
        return self.some.GetChildAtIndex(index)

    def num_children(self):
        if self.some.IsValid() and self.some.GetError().Success():
            return self.some.GetNumChildren()
        return 0

    def get_child_index(self, name):
        pass

    def has_children(self):
        if self.children == False or self.some == None or self.hasvalue == False:
            return False
        return True

    def get_type_name(self):
        if self.valobj.IsValid():
            return self.valobj.GetTypeName().rstrip(" *")
        return ""

class CommandSet:
    def __init__(self, debugger, unused):
        self.dbg = debugger

    def __call__(self, debugger, command, exe_ctx, result):
        cmd = command.strip()
        if '=' not in cmd:
            result.SetError("Invalid command options. Use 'help set' to view the command format.")
            return
        parts = cmd.split('=', 1)
        if len(parts) != 2:
            result.SetError("Invalid command options. Use 'help set' to view the command format.")
            return
        expr = parts[0].strip()
        new_value = parts[1].strip()
        if not expr or not new_value:
            result.SetError("Invalid command. Variable name and value cannot be empty")
            return
        target = debugger.GetSelectedTarget()
        process = target.GetProcess()
        thread = process.GetSelectedThread()
        frame = thread.GetSelectedFrame()
        parts = re.sub(r'\[(\d+)\]', r'.\1', expr)
        variables = parts.split('.')
        root = variables[0]
        members = variables[1:]
        var = frame.FindVariable(root)
        if not var.IsValid():
            var = target.FindFirstGlobalVariable(root)
        if not var.IsValid():
            result.SetError(f"Invalid command. Can not find variable '{root}'")
            return
        for member in members:
            if member.isdigit():
                index = int(member)
                var = var.GetChildAtIndex(index, 0, True)
            else:
                var = var.GetNonSyntheticValue()
                var = var.GetChildMemberWithName(member)
            if not var.IsValid():
                result.SetError(f"Invalid command. Can not find member '{member}'")
                return
        error = lldb.SBError()
        var.SetValueFromCString(new_value, error)
        if error.Fail():
            result.SetError(error.GetCString())
            return
        result.AppendMessage(f"{expr} = {new_value}")
        return

    def get_short_help(self):
        return "Modify the value of a variable of a basic data type.\n" \
               "The command format is 'set variable = new_value'\n"

class CommandCJBackTrace :
    def __init__(self, debugger, unused):
        self.dbg = debugger

    def __call__(self, debugger, command, exe_ctx, result):
        try:
            frame_limit = int(command.strip()) if command.strip() else None
        except ValueError:
            result.SetError("Invalid command options.")
            return

        target = debugger.GetSelectedTarget()
        process = target.GetProcess()
        if not process or not process.IsValid():
            result.SetError("Command requires a current process.")
            return
        thread = process.GetSelectedThread()
        result.AppendMessage(
            f'* thread #{thread.GetThreadID()}, name = {thread.GetName()}, '
            f'stop reason = {thread.GetStopDescription(100)}')
        if frame_limit == None:
            frame_limit = thread.GetNumFrames()
        status = ""
        str = lldb.SBStream()
        for num in range(0, frame_limit):
            frame = thread.GetFrameAtIndex(num)
            if num == thread.GetSelectedFrame().GetFrameID():
                status += "  * "
            else :
                status += "    "
            str.Clear()
            frame.GetDescription(str)
            mangled = frame.GetFunctionName().split("(", 1)[0]
            mangled = EscapeExpressionString(mangled)
            if mangled.startswith("_"):
                expr = f'(char *)CJ_MRT_DemangleHandle("{"_" + mangled}")'
            else:
                expr = f'(char *)CJ_MRT_DemangleHandle("{mangled}")'
            value = thread.GetFrameAtIndex(0).EvaluateExpression(expr)
            if not value.GetSummary():
                status += str.GetData()
                continue
            demangled = value.GetSummary().strip("\"").split("(", 1)[0]
            des = str.GetData().replace(mangled, demangled)
            status += des
        result.AppendMessage(status)
        return

    def get_short_help(self):
        return "Show the current thread's call stack.  Any numeric argument displays at most\n" \
               "that many frames. Display all frames by default.\n" \
               "bt [<digit> | all]"

class CommandCJThreadBackTrace:
    def __init__(self, debugger, unused):
        pass

    def __call__(self, debugger, command, exe_ctx, result):
        frame = exe_ctx.frame
        process = exe_ctx.process
        if not frame.IsValid():
            result.SetError("Command requires a current frame.")
            return
        options = lldb.SBExpressionOptions()
        options.SetSuppressPersistentResult(False)
        options.SetIgnoreBreakpoints(True)
        count = "unsigned long long cjdb_cjthread_count = (unsigned long long)CJ_MRT_GetCJThreadNumberUnsafe();cjdb_cjthread_count"
        result_obj = frame.EvaluateExpression(count, options)
        cjthread_count = result_obj.GetValueAsSigned() - 1
        # Due to the expression limitation, the stack of up to 100 Cangjie threads can be displayed.
        if cjthread_count > 100 :
            cjthread_count = 100
        info = f'char* cjdb_expr_buf = (char *)malloc({cjthread_count * 2048});\
            int a=(int)CJ_MRT_GetAllCJThreadStackTrace(cjdb_expr_buf,{cjthread_count});(char *)cjdb_expr_buf'
        buf = frame.EvaluateExpression(info, options)
        error = lldb.SBError()
        for i in range(cjthread_count):
            cjthreads = process.ReadCStringFromMemory(buf.GetValueAsUnsigned() + i *2048, 2048, error).split("\n")
            for cjthread in cjthreads:
                result.PutCString(cjthread)
        frame.EvaluateExpression("free(cjdb_expr_buf)", options)
        return

    def get_short_help(self):
        return "Show the all cangjie thread's call stack. excluding those in the running state. \n"

class CangjieStdLib:
    def __init__(self, target:lldb.SBTarget, extra_args, _):
        pass
    def handle_stop(self, exe_ctx, stream)-> bool:
        thread = exe_ctx.thread
        frame = exe_ctx.frame
        function_name = frame.GetFunctionName()
        if not function_name:
            return True
        if re.match("^_CN[a-c][a-z]", function_name):
            plan = thread.StepOut()
            exe_ctx.thread.StepUsingScriptedThreadPlan('{}.{}'.format(__name__, plan), False)
            return True
        return True

def __lldb_init_module(debugger, internal_dict):
    debugger.HandleCommand(f'command script add -c {__name__}.CommandSet set')

    debugger.HandleCommand(f'command alias locals frame variable')
    debugger.HandleCommand(f'command alias globals target variable')
    debugger.HandleCommand('command unalias bt')
    debugger.HandleCommand(f'command script add -c {__name__}.CommandCJBackTrace  bt')
    debugger.HandleCommand('target stop-hook add -P {}.{}'.format(__name__, "CangjieStdLib"))
    debugger.HandleCommand(f'command script add -c {__name__}.CommandCJThreadBackTrace cjthread')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieSyntheticProvider \
                           -x "^.+$" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieSummaryDisplayTypeSyntheticProvider \
                           -x "^(const )?(std[.](core|time)::(String|Range|DateTime))|(CString|CPointer<.+>)$"\
                           --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieVArraySyntheticProvider \
                           -x "^(const )?VArray<.+>$" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieArrayListSyntheticProvider \
                           -x "^(const )?std[.]collection::ArrayList<.+>$" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieArraySyntheticProvider \
                           -x "^(const )?std[.]core::Array<.+>$" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieTupleSyntheticProvider \
                           -x "^(const )?Tuple<.+>$" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieOptionSyntheticProvider \
                           -x "^(const )?std[.]core::Option<.+>( \\*)?$" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CanjieHashMapEntrySyntheticProvider \
                           -x "^std[.]collection::HashMapEntry<.+>$" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieHashMapSyntheticProvider \
                           -x "^(const )?std[.]collection::HashMap<.+>$" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieHashSetSyntheticProvider \
                           -x "^(const )?std[.]collection::HashSet<.+>$" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieGTSyntheticProvider \
                           -x "(const )?(\$G_[A-Z]+|Any$)" --category CustomView')
    debugger.HandleCommand(f'type summary add -F {__name__}.CangjieGTSummaryProvider \
                           -x "(const )?(\$G_[A-Z]+|Any$)" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.UnitSummaryProvider \
                           -x "^(const )?Unit$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.RangeSummaryProvider \
                           -x "^(const )?std[.]core::Range<.+>$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.FunctionSummaryProvider \
                           -x "^(const )?(.+::|^)\\(.*\\)( ?)->.+$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.StringSummaryProvider \
                           -x "^(const )?std[.]core::String$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.RuneSummaryProvider  \
                           -x "^(const )?Rune$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.Int8SummaryProvider \
                           -x "^(const )?U?Int8$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.CPointerSummaryProvider \
                           -x "^(const )?CPointer<.+>$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.CStringSummaryProvider \
                           -x "^(const )?CString$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.OptionSummaryProveder \
                           -x "^(const )?std[.]core::Option<.+>$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.OptionPtrSummaryProveder \
                           -x "^(const )?std[.]core::Option<.+> \\*$" --category CustomView -v')
    # use toStringProvider
    debugger.HandleCommand(f'type summary add -F {__name__}.TimeZoneSummaryProvider \
                       -x  "^(const )?std[.]time::TimeZone$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.DateTimeSummaryProvider \
                       -x "^(const )?std[.]time::DateTime$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.CangjieEnum0SummaryProvider \
                           -x "^(.+)?E0\\$(.+)$" --category CustomView -v')
    debugger.HandleCommand(f'type summary add -F {__name__}.CangjieEnum2SummaryProvider \
                           -x "(.+)?E2\\$(.+)" --category CustomView -v')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieEnum1SyntheticProvider \
                           -x "(.+)?E1\\$(.+)" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieEnum2SyntheticProvider \
                           -x "(.+)?E2\\$(.+)" --category CustomView')
    debugger.HandleCommand(f'type synthetic add -l {__name__}.CangjieEnum3SyntheticProvider \
                           -x "(.+)?E3\\$(.+)" --category CustomView')
    debugger.HandleCommand('type category enable CustomView')
    debugger.HandleCommand('env cjProcessorNum=1')
    debugger.HandleCommand("settings set target.max-children-depth 5")
    debugger.HandleCommand("settings set target.max-children-count 100")
    debugger.HandleCommand('settings set target.process.thread.step-avoid-regexp ^_CN[a-c][a-z]')

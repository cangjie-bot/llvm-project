//===--------------------------- ObfConfig.cpp ----------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//
//
// The configuration pass for obfuscation.
//
//===----------------------------------------------------------------------===//

#include "CangjieDemangle.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/TypeFinder.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/PassRegistry.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/SHA1.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Analysis/ObfConfigAnalysis.h"
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>

using namespace llvm;

namespace {
const int OBF_LEN = 8;
} // end anonymous namespace

static cl::opt<std::string>
    ConfigFile("obf-config-file",
               cl::desc("Obfuscator configuration file path"), cl::NotHidden);

static cl::opt<int> ConfigSeed("obf-seed",
                               cl::desc("Obfuscator hash salt seed"),
                               cl::NotHidden);

namespace {
const int MAX_OBF_LEVEL = 9;
const int DEFAULT_OBF_LEVEL = 4;
} // end anonymous namespace

static cl::opt<unsigned int>
    ObfLevel("obf-level", cl::desc("the Level of obfuscation"), cl::NotHidden);

static unsigned int WildcardNoneType = 0;
static unsigned int WildcardMatchOneType = 1; // ?
static unsigned int WildcardMatchMultiSepType = 1 << 1; // *
static unsigned int WildcardMatchMultiType = 1 << 2; // **
static unsigned int WildcardMatchAnyParamType = 1 << 3; // ***
static unsigned int WildcardMatchMultiParamType = 1 << 4; // ...

static inline std::string WildcardMatchOne = "?";
static inline std::string WildcardMatchMultiNoSep = "*";
static inline std::string WildcardMatchMulti = "**";
static inline std::string WildcardMatchAnyParam = "***";
static inline std::string WildcardMatchMultiParam = "...";

unsigned int Matcher::getWildcardType(const std::string &Name, size_t &Index) {
  unsigned int Res = WildcardNoneType;
  size_t Pos = Index;
  if (Name[Index] == WildcardMatchOne[0]) {
    return WildcardMatchOneType;
  }
  if (Index + WildcardMatchMultiParam.size() < Name.size() &&
      Name.compare(Index, WildcardMatchMultiParam.size(), WildcardMatchMultiParam) == 0) {
    Index += (WildcardMatchMultiParam.size() - 1);
    return WildcardMatchMultiParamType;
  }
  while (Pos < Name.size() && Name[Pos] == WildcardMatchMultiNoSep[0]) {
    Pos++;
  }
  if (Pos - Index >= WildcardMatchMultiNoSep.size()) {
    Res = Res | WildcardMatchMultiSepType;
  }
  if (Pos - Index >= WildcardMatchMulti.size()) {
    Res = Res | WildcardMatchMultiType;
  }
  if (Pos - Index >= WildcardMatchAnyParam.size()) {
    Res = Res | WildcardMatchAnyParamType;
  }
  Index = (Pos != Index ? (Pos - 1) : Index);

  return Res;
}

unsigned int Matcher::getCJFieldWildcardType(const CJSymbol::CJField &Field, size_t &Index) {
  unsigned int Res = getWildcardType(Field.Name, Index);
  if ((Res & WildcardMatchMultiType) &&
     (Field.Name.size() != WildcardMatchMulti.size() || Field.HasParameter)) {
    Res = Res & (~WildcardMatchMultiType);
  } else if ((Res & WildcardMatchMultiType) && Field.Name.size() == WildcardMatchMulti.size()) {
    Res = Res & (~WildcardMatchMultiSepType);
  }
  return Res;
}

bool Matcher::isParamMatch(const CJSymbol::CJField &TSym, const CJSymbol::CJField &SSym, bool MatchGeneric) {
  size_t TIndex = 0;
  size_t SIndex = 0;
  auto Temp = TSym.Parameters;
  auto Sym = SSym.Parameters;
  size_t TEnd = Temp.size();
  size_t SEnd = Sym.size();
  size_t LastTIndex = std::string::npos;
  size_t LastSIndex = std::string::npos;
  if (TSym.HasParameter != SSym.HasParameter) {
    return false;
  }

  while (TIndex != TEnd || SIndex != SEnd) {
    if (TIndex != TEnd && SIndex != SEnd && !Temp[TIndex].isWildCardMatchMultiParam() &&
       (Temp[TIndex].isWildCardMatchAnyParam() || isSymbolMatch(Temp[TIndex], Sym[SIndex], MatchGeneric))) {
      TIndex++;
      SIndex++;
      continue;
    } else if (TIndex != TEnd && Temp[TIndex].isWildCardMatchMultiParam()) {
      while (TIndex < TEnd && Temp[TIndex].isWildCardMatchMultiParam()) {
        TIndex++;
      }
      if (TIndex == TEnd) {
        return true;
      }
      while (SIndex < SEnd &&
            !isSymbolMatch(Temp[TIndex], Sym[SIndex], MatchGeneric)) {
        SIndex++;
      }
      LastTIndex = TIndex - 1;
      LastSIndex = SIndex + 1;
      continue;
    }

    if (SIndex == SEnd || LastSIndex == std::string::npos) {
      return false;
    }

    TIndex = LastTIndex;
    SIndex = LastSIndex;
  }

  return true;
}

bool Matcher::isCJFieldsMatch(
    const std::vector<CJSymbol::CJField> &Temp, const std::vector<CJSymbol::CJField> &Sym, bool MatchGeneric) {
  size_t TIndex = 0;
  size_t SIndex = 0;
  size_t TOffset = 0;
  size_t SOffset = 0;
  std::vector<MultiMatchPos> MPVec;
  unsigned int WType = WildcardNoneType;
  bool lastParamMatch = true;

  while (TIndex != Temp.size() || SIndex != Sym.size()) {
    if (TIndex < Temp.size() && SIndex < Sym.size() &&
        TOffset < Temp[TIndex].Name.size() && SOffset < Sym[SIndex].Name.size()) {
      WType = getCJFieldWildcardType(Temp[TIndex], TOffset);
      // Check if char is same or recored wildcard
      if ((WType & WildcardMatchOneType) ||
          (WType == WildcardNoneType && Temp[TIndex].Name[TOffset] == Sym[SIndex].Name[SOffset])) {
        // Match 1 char
        TOffset++;
        SOffset++;
        continue;
      } else if ((WType & WildcardMatchMultiSepType) || (WType & WildcardMatchMultiType)) {
        // Record wildcard in `Temp`
        MultiMatchPos MPos = {TIndex, SIndex, TOffset, SOffset, WType};
        MPVec.push_back(MPos);
        if (WType & WildcardMatchMultiType) {
          TIndex++;
          TOffset = 0;
        } else {
          TOffset++;
        }
        if (TOffset != Temp[TIndex].Name.size()) {
          continue;
        }
      }
    }
    if (TIndex < Temp.size() && SIndex < Sym.size() &&
        TOffset == Temp[TIndex].Name.size() && SOffset == Sym[SIndex].Name.size()) {
      if (isParamMatch(Temp[TIndex], Sym[SIndex], MatchGeneric)) {
        TIndex++;
        SIndex++;
        TOffset = 0;
        SOffset = 0;
        lastParamMatch = true;
        continue;
      } else {
        lastParamMatch = false;
      }
    }
    // Not match, rollback
    if (MPVec.size() != 0) {
      // Rollback to the last USABLE wildcard
      while (MPVec.size() != 0 &&
             (((MPVec.back().WType & WildcardMatchMultiSepType) &&
             MPVec.back().LastSOffset == Sym[MPVec.back().LastSIndex].Name.size()) ||
             ((MPVec.back().WType & WildcardMatchMultiType) && MPVec.back().LastSIndex == Sym.size()))) {
        MPVec.pop_back();
      }
      if (MPVec.size() == 0) {
        return false;
      }
      if (MPVec.size() != 0 && (MPVec.back().WType & WildcardMatchMultiSepType)) {
        SIndex = MPVec.back().LastSIndex;
        SOffset = ++MPVec.back().LastSOffset;
        TIndex = MPVec.back().LastTIndex;
        TOffset = MPVec.back().LastTOffset + 1;
      } else if (MPVec.size() != 0 && (MPVec.back().WType & WildcardMatchMultiType)) {
        SIndex = ++MPVec.back().LastSIndex;
        SOffset = 0;
        TIndex = MPVec.back().LastTIndex + 1;
        TOffset = 0;
        lastParamMatch = true;
      }
    } else {
      return false;
    }

    if (SIndex == Sym.size()) {
      size_t Offset = 0;
      while (TIndex < Temp.size() &&
            (getCJFieldWildcardType(Temp[TIndex], Offset) & WildcardMatchMultiType)) {
        TIndex++;
        Offset = 0;
      }
    }
  }

  if (TIndex < Temp.size() && Temp[TIndex].Name.size() == TOffset) {
    TIndex++;
    TOffset = 0;
  }
  if (TIndex < Temp.size() || SIndex < Sym.size() || !lastParamMatch) {
    return false;
  }
  return true;
}

bool Matcher::isSymbolMatch(const CJSymbol &Temp, const CJSymbol &Sym, bool MatchGeneric) {
  if (Temp.SymbolType != Sym.SymbolType) {
    return false;
  }

  if (Temp.SymbolType == CJSymbol::CJSymbolType::TYPE && Temp.isWildCardMatchAnyParam()) {
    return true;
  }

  if (!isCJFieldsMatch(Temp.Fields, Sym.Fields, MatchGeneric)) {
    return false;
  }
  if (Temp.SymbolType == CJSymbol::CJSymbolType::CLOSURE &&
      !isSymbolMatch(*Temp.ReturnType.get(), *Sym.ReturnType.get(), MatchGeneric)) {
    return false;
  }

  return true;
}

bool Matcher::isObfFuncMatch(const std::string &Temp, const std::string &Sym) {
  size_t TEnd = Temp.size();
  size_t SEnd = Sym.size();
  size_t TIndex = 0;
  size_t SIndex = 0;
  size_t LastTIndex = std::string::npos;
  size_t LastSIndex = std::string::npos;
  unsigned int WType = WildcardNoneType;

  while (SIndex != SEnd || TIndex != TEnd) {
    WType = getWildcardType(Temp, TIndex);
    if (SIndex < SEnd && TIndex < TEnd && (WType == WildcardMatchOneType || Temp[TIndex] == Sym[SIndex])) {
      TIndex++;
      SIndex++;
      continue;
    } else if (TIndex < TEnd && (WType & WildcardMatchMultiSepType)) {
      while (TIndex + 1 < TEnd && SIndex < SEnd && Temp[TIndex + 1] != Sym[SIndex]) {
        SIndex++;
      }
      LastTIndex = TIndex;
      LastSIndex = SIndex + 1;
      TIndex++;
      continue;
    }
    if (SIndex == SEnd || LastTIndex == std::string::npos) {
      return false;
    }
    TIndex = LastTIndex;
    SIndex = LastSIndex;
  }

  return true;
}

bool CJSymbol::isWildCardMatchMultiParam(void) const {
  return SymbolType == CJSymbolType::TYPE && Fields.size() == 1 && Fields[0].Name == WildcardMatchMultiParam;
}

bool CJSymbol::isWildCardMatchAnyParam(void) const {
  return SymbolType == CJSymbolType::TYPE && Fields.size() == 1 && Fields[0].Name == WildcardMatchAnyParam;
}

bool CJSymbol::hasSeparators(const std::string &String) {
  return String.find(FieldSeparator, 0) != std::string::npos ||
      String.find(ParamSeparator, 0) != std::string::npos;
}

std::string CJSymbol::parseOperatorName(const std::string &String, size_t Start, size_t End) {
  for (auto OP : OperatorNames) {
    if (End - Start >= OP.size() && String.compare(Start, OP.size(), OP) == 0) {
      return OP;
    }
  }
  return "";
}

bool CJSymbol::parseField(const std::string &String, size_t Start, size_t End, CJField &Field) {
  int GenericNotClose = 0;
  int ParamNotClose = 0;
  size_t GenericStart = 0;
  size_t GenericEnd = std::string::npos;
  size_t ParamStart = String.find(ParamBrackets[0], Start);
  size_t FieldEnd = 0;

  // parse field name.
  auto OPName = parseOperatorName(String, Start, End);
  if (OPName.size() != 0) {
    FieldEnd = Start + OPName.size();
    Field.Name = OPName;
    ParamStart = FieldEnd;
  } else {
    GenericStart = String.find(GenericBrackets[0], Start);
    FieldEnd = std::min(std::min(GenericStart, ParamStart), End);
    Field.Name = String.substr(Start, FieldEnd - Start);
  }

  // parse field generic.
  for (size_t Index = FieldEnd; String[FieldEnd] == GenericBrackets[0] && Index < End; Index++) {
    if (isLeftGenericBracket(String, Index, FieldEnd, End, false)) {
      GenericNotClose++;
    } else if (isRightGenericBracket(String, Index, FieldEnd, End) && GenericNotClose > 0) {
      GenericNotClose--;
    }
    if (GenericNotClose == 0 && isRightGenericBracket(String, Index, FieldEnd, End)) {
      GenericEnd = Index;
      break;
    }
  }

  if (GenericNotClose != 0) {
    return false;
  }
  if (GenericEnd != std::string::npos) {
    Field.HasGeneric = true;
    if (!parseParams(String, FieldEnd + 1, GenericEnd, Field.GenericTypes)) {
      return false;
    }
    ParamStart = GenericEnd + 1;
  }

  // parse field params.
  for (size_t Index = ParamStart; Index < End; Index++) {
    if (isLeftParamBracket(String, Index, ParamStart, End)) {
      ParamNotClose++;
    } else if (isRightParamBracket(String, Index, ParamStart, End)) {
      ParamNotClose--;
    }
    if (ParamNotClose == 0 && Index != (End - 1)) {
      if (String.substr(Index, End - Index) == "[]") {
        break;
      }
      return false;
    }
  }
  if (ParamNotClose != 0) {
    return false;
  }
  if (isLeftParamBracket(String, ParamStart, Start, End) && isRightParamBracket(String, End - 1, Start, End)) {
    Field.HasParameter = true;
    if (!parseParams(String, ParamStart + 1, End - 1, Field.Parameters)) {
      return false;
    }
  }
  return true;
}

bool CJSymbol::parseFields(const std::string &String, size_t Start, size_t End) {
  bool Success = true;
  size_t Pos = 0;

  while (Start < End) {
    int GenericNotClose = 0;
    int ParamNotClose = 0;
    Pos = std::string::npos;
    for (size_t Index = Start; Index < End; Index++) {
      if (isLeftGenericBracket(String, Index, Start, End)) {
        GenericNotClose++;
      } else if (isRightGenericBracket(String, Index, Start, End) && GenericNotClose > 0) {
        GenericNotClose--;
      } else if (isLeftParamBracket(String, Index, Start, End)) {
        ParamNotClose++;
      } else if (isRightParamBracket(String, Index, Start, End) && ParamNotClose > 0) {
        ParamNotClose--;
      }
      if (GenericNotClose == 0 && ParamNotClose == 0 && String[Index] == FieldSeparator) {
        Pos = Index;
        break;
      }
    }
    // Only check param bracket because the field could be `<` or `>`.
    if (ParamNotClose != 0) {
      return false;
    }
    Pos = (Pos == std::string::npos ? End : Pos);
    CJField Field;
    Success = parseField(String, Start, Pos, Field);
    if (!Success || (Fields.size() != 0 && Field.Name.size() == 0)) {
      // Symbol might starts with '.', so the first field can be empty
      return false;
    }
    Fields.push_back(Field);
    Start = Pos + 1;
  }
  return String[End - 1] != FieldSeparator;
}

bool CJSymbol::parseSymbol(const std::string &String) {
  return parseFields(String, 0, String.size());
}

bool CJSymbol::parseClosure(const std::string &String) {
  int ParamNotClose = 0;
  size_t Start = 0;
  size_t Pos = 0;
  size_t ParamEnd = 0;
  size_t ReturnStart = 0;
  for (Pos = 0; Pos < String.size(); Pos++) {
    if (isLeftParamBracket(String, Pos, Start, String.size())) {
      ParamNotClose++;
    } else if (isRightParamBracket(String, Pos, Start, String.size())) {
      ParamNotClose--;
    }

    if (ParamNotClose == 0 && isReturnBracket(String, Pos, Start, String.size())) {
      ParamEnd = Pos - 1;
      ReturnStart = Pos + 1;
      break;
    }
  }
  if (ParamNotClose != 0 || ParamEnd == 0) {
    return false;
  }
  CJField Field;
  if (!parseParams(String, Start + 1, ParamEnd - 1, Field.Parameters)) {
    return false;
  }
  Fields.push_back(Field);
  std::string ClStr = String.substr(ReturnStart, String.size() - ReturnStart);
  ReturnType = std::make_shared<CJSymbol>(CJSymbol::get(ClStr, "", CJSymbolType::TYPE));
  return true;
}


CJSymbol CJSymbol::get(const std::string &Symbol, const std::string &Package, CJSymbol::CJSymbolType SymbolType) {
  CJSymbol CJS = CJSymbol();
  CJS.SymbolType = SymbolType;
  CJS.Package = Package;
  bool Success = false;
  std::string TrimSymbol = "";

  for (auto C : Symbol) {
    if (C == ' ' || C == '\n' || C == '\r') {
      continue;
    }
    TrimSymbol += C;
  }
  if (TrimSymbol.size() == 0) {
    Success = false;
    goto end;
  }
  while (true) {
    size_t Pos = TrimSymbol.find(IdentSeparator, 0);
    if (Pos == std::string::npos) {
      break;
    }
    TrimSymbol.replace(Pos, IdentSeparator.size(), std::string(1, FieldSeparator));
  }
  if (SymbolType == CJSymbol::CJSymbolType::TYPE &&
      (TrimSymbol == WildcardMatchMultiParam || TrimSymbol == WildcardMatchAnyParam)) {
    Success = true;
    CJField Field;
    Field.Name = TrimSymbol;
    CJS.Fields.push_back(Field);
    goto end;
  }

  if (TrimSymbol[0] == ParamBrackets[0]) {
    CJS.SymbolType = CLOSURE;
    Success = CJS.parseClosure(TrimSymbol);
  } else {
    Success = CJS.parseSymbol(TrimSymbol);
  }

end:
  if (!Success) {
    report_fatal_error("Invalid Symbol: " + StringRef(Symbol));
  }
  return CJS;
}

bool CJSymbol::parseParams(const std::string &String, size_t Start, size_t End, std::vector<CJSymbol> &Params) {
  while (Start < End) {
    int GenericNotClose = 0;
    int ParamNotClose = 0;
    size_t Pos = std::string::npos;
    for (size_t Index = Start; Index < End; Index++) {
      if (isLeftGenericBracket(String, Index, Start, End, false)) {
        GenericNotClose++;
      } else if (isRightGenericBracket(String, Index, Start, End) && GenericNotClose > 0) {
        GenericNotClose--;
      } else if (isLeftParamBracket(String, Index, Start, End)) {
        ParamNotClose++;
      } else if (isRightParamBracket(String, Index, Start, End) && ParamNotClose > 0) {
        ParamNotClose--;
      }
      if (GenericNotClose == 0 && ParamNotClose == 0 && String[Index] == ParamSeparator) {
        Pos = Index;
        break;
      }
    }
    if (GenericNotClose != 0 || ParamNotClose != 0) {
      return false;
    }
    Pos = (Pos == std::string::npos ? End : Pos);
    if (Pos == Start) {
      return false;
    }
    CJSymbol CJS = CJSymbol::get(String.substr(Start, Pos - Start), "", CJSymbolType::TYPE);
    Params.push_back(CJS);
    Start = Pos + 1;
  }
  return String[End - 1] != ParamSeparator;
}

CJSymbol::CJSymbol() {
}

CJSymbol::~CJSymbol() {
}

bool Rule::parseOwner(const std::string &Str) {
  Owner = Str;
  return true;
}

Rule::Rule(std::string Owner, CJSymbol CJSym) {
  if (!parseOwner(Owner)) {
    report_fatal_error("Invalid obfuscator in config file: " + StringRef(Owner));
  }

  Symbol = CJSym;
}

Rule Rule::get(const std::string &Line) {
  size_t Pos = Line.find(' ');
  if (Pos == std::string::npos) {
    report_fatal_error("Invalid rule in Obfuscator's config file: " + StringRef(Line));
  }

  CJSymbol CJSym = CJSymbol::get(Line.substr(Pos + 1, Line.size() - Pos - 1), "", CJSymbol::CJSymbolType::SYMBOL);
  Rule R = Rule(Line.substr(0, Pos), CJSym);
  R.RawRule = Line;
  return R;
}

Rule::~Rule() {}

bool Rule::isMatch(const CJSymbol &CJSym) {
  return Matcher::isSymbolMatch(Symbol, CJSym, false);
}

void ObfConfig::addRule(Rule &R) { RuleMap[R.Owner].push_back(R); }

ObfConfig::~ObfConfig() {
  RuleMap.clear();
}

void ObfConfig::loadConfig(const std::string &ConfigPath) {
  std::string Line;
  std::ifstream InputFile(ConfigPath);

  if (!InputFile.is_open()) {
    return;
  }

  while (getline(InputFile, Line)) {
    std::string NewLine = "";
    for (auto C : Line) {
      if (C == '#') {
        break;
      }
      NewLine += C;
    }
    if (NewLine.size() == 0) {
      continue;
    }

    Rule R = Rule::get(Line);
    addRule(R);
  }

  InputFile.close();
}

ObfConfig::ObfConfig() {
  if (ObfLevel > MAX_OBF_LEVEL)
    ObfLevel = MAX_OBF_LEVEL;
  else if (ObfLevel == 0)
    ObfLevel = DEFAULT_OBF_LEVEL;

  RandSeed = ConfigSeed;
  srand(RandSeed);
  this->loadConfig(ConfigFile);
}

unsigned int ObfConfig::getObfLevel() { return ObfLevel; }

unsigned int ObfConfig::getMaxObfLevel() { return MAX_OBF_LEVEL; }

bool ObfConfig::needObfuse(const std::string &N, const std::string &Owner) {
  if (!isValidMangleName(N)) {
    return true;
  }
  std::string DN = getDemangleName(N);
  std::string Pack = getPackageName(N);
  CJSymbol Target = CJSymbol::get(DN, Pack, CJSymbol::CJSymbolType::SYMBOL);
  for (auto &Iter : RuleMap) {
    if (!Matcher::isObfFuncMatch(Iter.first, Owner)) {
      continue;
    }
    for (auto Rule : Iter.second) {
      if (Rule.isMatch(Target)) {
        return false;
      }
    }
  }
  return true;
}

std::string ObfConfig::getPackageName(const std::string &MN) {
  auto D = Cangjie::Demangle(MN);
  return D.GetPkgName();
}

std::string ObfConfig::getDemangleName(const std::string &MN) {
  std::string Suffix = "";
  std::string RealScopeRes = std::string(1, CJSymbol::FieldSeparator);

  auto D = Cangjie::Demangle(MN);
  std::string FullName = D.GetFullName();

  auto DN = (D.GetPkgName() + (D.GetPkgName().empty() ? "" : RealScopeRes)) + FullName;

  return DN;
}

bool ObfConfig::isValidMangleName(const std::string &Name) {
  auto D = Cangjie::Demangle(Name);
  return D.IsValid();
}

std::string ObfConfig::hash(const StringRef &Input, bool ToAscii) {
  SHA1 Hasher;
  Hasher.update(Input);
  std::string Output;
  if (ToAscii)
    Output = toHex(Hasher.final());
  else
    Output = std::string((char *)Hasher.final().data());
  Output = Output.substr(0, OBF_LEN);
  return Output;
}

unsigned int ObfConfig::getRandNum() {
  unsigned int RD = rand();
  return RD;
}

AnalysisKey ObfConfigAnalysis::Key;

std::shared_ptr<ObfConfig> ObfConfigAnalysis::run(Module &M,
                                                  ModuleAnalysisManager &AM) {
  if (ObfConfigInstance == nullptr) {
    this->ObfConfigInstance = std::make_shared<ObfConfig>();
  }

  return this->ObfConfigInstance;
}

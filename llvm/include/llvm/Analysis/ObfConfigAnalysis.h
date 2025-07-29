//===------------------------- ObfConfigAnalysis.h ------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_OBFUSCATOR_CONFIGURATION_H
#define LLVM_TRANSFORMS_OBFUSCATOR_CONFIGURATION_H
#include "llvm/IR/GlobalVariable.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include <map>

namespace llvm {

class CJSymbol {
public:
  CJSymbol();
  ~CJSymbol();

  enum CJSymbolType {
    TYPE,
    SYMBOL,
    CLOSURE,
  };

  class CJField {
  public:
    std::string Name;
    bool HasGeneric = false;
    bool HasParameter = false;
    std::vector<CJSymbol> GenericTypes;
    std::vector<CJSymbol> Parameters;
  };
  CJSymbolType SymbolType;
  std::string Package;
  std::vector<CJField> Fields;
  std::shared_ptr<CJSymbol> ReturnType;

  static CJSymbol get(const std::string &Symbol, const std::string &Package, CJSymbolType SymbolType);
  void print(std::string Indent);
  bool isWildCardMatchMultiParam(void) const;
  bool isWildCardMatchAnyParam(void) const;
  static bool hasSeparators(const std::string &String);
  static const char FieldSeparator = '.';
  static const char ParamSeparator = ',';
  static const inline std::string ParamBrackets = "()";
  static const inline std::string IdentSeparator = "::";
  static const inline std::string GenericBrackets = "<>";
  static const inline std::vector<std::string> OperatorNames = {
      "<=",
      "<<",
      "<",
      ">=",
      ">>",
      ">",
      "()",
  };
private:
  bool parseField(const std::string &String, size_t Start, size_t End, CJField &Name);
  bool parseFields(const std::string &String, size_t Start, size_t End);
  bool parseParams(const std::string &String, size_t Start, size_t End, std::vector<CJSymbol> &Params);
  bool parseClosure(const std::string &String);
  bool parseSymbol(const std::string &String);
  std::string parseOperatorName(const std::string &String, size_t Start, size_t End);

  static bool isLeftParamBracket(const std::string &String, size_t Index, size_t Start, size_t End) {
    return Index >= Start && Index < End && String[Index] == ParamBrackets[0];
  };
  static bool isRightParamBracket(const std::string &String, size_t Index, size_t Start, size_t End) {
    return Index >= Start && Index < End && String[Index] == ParamBrackets[1];
  };
  static bool isLeftGenericBracket(const std::string &String, size_t Index,
                                    size_t Start, size_t End, bool CheckOperator = true) {
    static const std::vector<char> AvoidNextChars = {
        '<', // operator "<<"
        '=', // operator "<="
        '.', // operator "."
    };
    if (!(Index >= Start && Index < End && String[Index] == GenericBrackets[0])) {
      return false;
    }
    if (Index == (End - 1)) {
      return true;
    }
    if (CheckOperator && Index == Start && String[Index + 1] == '(') {
      // It is operator '<'
      return false;
    }
    return find(AvoidNextChars.begin(), AvoidNextChars.end(), String[Index + 1]) == AvoidNextChars.end();
  };
  static bool isRightGenericBracket(const std::string &String, size_t Index, size_t Start, size_t End) {
    return (Index >= Start && Index < End && String[Index] == GenericBrackets[1]) &&
           !isReturnBracket(String, Index, Start, End);
  };
  static bool isReturnBracket(const std::string &String, size_t Index, size_t Start, size_t End) {
    return Index > Start && Index < End && String[Index - 1] == '-' && String[Index] == GenericBrackets[1];
  }
};

class Rule {
public:
  std::string Owner;
  CJSymbol Symbol;
  Rule();
  ~Rule();
  static Rule get(const std::string &Line);
  Rule(std::string Owner, CJSymbol CJSym);

  std::string getAction();
  bool isMatch(const CJSymbol &CJSym);
  std::string RawRule;

private:
  bool parseOwner(const std::string &Str);
};

class ObfConfig {
public:
  ObfConfig();
  ~ObfConfig();
  void addRule(Rule &R);
  static std::string hash(const StringRef &Input, bool ToAscii);
  unsigned int getRandNum();
  static bool isValidMangleName(const std::string &Name);
  static std::string getDemangleName(const std::string &MN);
  static std::string getPackageName(const std::string &MN);
  bool needObfuse(const std::string &N, const std::string &Owner);
  unsigned int getObfLevel();
  unsigned int getMaxObfLevel();

private:
  std::map<std::string, std::vector<Rule>> RuleMap;
  void loadConfig(const std::string &ConfigPath);
  unsigned int RandSeed;
};

class Matcher {
public:
  static bool isSymbolMatch(const CJSymbol &Temp, const CJSymbol &Sym, bool MatchGeneric);
  static bool isObfFuncMatch(const std::string &Temp, const std::string &Sym);
private:
  struct MultiMatchPos {
    size_t LastTIndex;
    size_t LastSIndex;
    size_t LastTOffset;
    size_t LastSOffset;
    unsigned int WType;
  };
  static bool isParamMatch(const CJSymbol::CJField &TSym, const CJSymbol::CJField &SSym, bool MatchGeneric);
  static bool isCJFieldsMatch(
    const std::vector<CJSymbol::CJField> &Temp, const std::vector<CJSymbol::CJField> &Sym, bool MatchGeneric);
  static unsigned int getWildcardType(const std::string &Name, size_t &Index);
  static unsigned int getCJFieldWildcardType(const CJSymbol::CJField &Field, size_t &Index);
};

class ObfConfigAnalysis : public AnalysisInfoMixin<ObfConfigAnalysis> {
public:
  using Result = std::shared_ptr<ObfConfig>;
  ObfConfigAnalysis(){};
  ~ObfConfigAnalysis(){};

  std::shared_ptr<ObfConfig> run(Module &M, ModuleAnalysisManager &AM);

private:
  static AnalysisKey Key;
  friend AnalysisInfoMixin<ObfConfigAnalysis>;
  std::shared_ptr<ObfConfig> ObfConfigInstance;
};
} // namespace llvm

#endif // LLVM_TRANSFORMS_OBFUSCATOR_CONFIGURATION_H

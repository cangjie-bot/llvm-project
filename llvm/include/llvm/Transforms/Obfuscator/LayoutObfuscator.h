//===------------------------- LayoutObfuscator.h -------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef CANGJIE_LAYOUT_OBFUSCATOR_H
#define CANGJIE_LAYOUT_OBFUSCATOR_H

#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"
#include "llvm/Analysis/ObfConfigAnalysis.h"

namespace llvm {
struct SymbolMapInfo {
  std::string NewName;
  std::string OldName;
  std::string Path;
};

class SymbolMapping {
public:
  std::map<std::string, struct SymbolMapInfo> InputMapping; // Key is NewName
  std::map<std::string, struct SymbolMapInfo> OutputMapping; // Key is OldName
  std::map<std::string, std::string> UserMapping;
  SymbolMapping(){};
  void addToOutputMapping(const std::string &OldName, const std::string &NewName, const std::string &Path = "");
  bool isObfuscatedSymbol(const std::string &Name);
  std::string getMappedName(const std::string &Name);
  void saveOutputMappingFile(const std::string &FileName);
  void loadUserMappingFile(const std::string &FileName);
  void loadMappingFile(
    const std::string &FileName,
    const std::function<void(const std::string &, const std::string &, const std::string &)> &UpdateMapping,
    const bool CloseBracket);
  void loadMappingFiles(const std::string &FileNames);
};

class LayoutObfuscator : public PassInfoMixin<LayoutObfuscator> {
public:
  LayoutObfuscator() {}
  ~LayoutObfuscator();
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);

private:
  void doObfuscation(GlobalVariable &G);
  void doObfuscation(Function &F);
  bool isPublicGlobal(const GlobalVariable &G);
  bool isPublicFunction(const Function &F);
  bool isStdFunction(const Function &F);
  bool needObfuse(const Function &F);
  bool needObfuse(const GlobalVariable &G);
  void reorderFunctions(Module &M);
  void recordDebugInfo(const Module &M);
  void recordAllSymbols(const Module &M);
  void getCurrentPackage(const Module &M);
  std::string generateUniqueName(void);
  void obfuscateDebugInfo(Module &M);

  const static int LIST_LENGTH = 'z' - 'a' + 1;
  int IndexList[LIST_LENGTH];
  const static inline std::string OBF_DEBUG_DIR_NAME = "";
  const static inline std::string OBF_DEBUG_FILE_NAME = "SOURCE";
  const static inline std::vector<std::string> InternalSymbols = {
      "file_global_init",
      "package_global_init",
  };
  const static inline int OBF_DEBUG_LINE_NO = 0;

  std::set<std::string> AllSymbols;
  std::shared_ptr<ObfConfig> ObfConfig;
  SymbolMapping SymbolMap;
  std::string CurrentPackage;
};

} // namespace llvm

#endif

//===-- PlatformOHOS.h ----------------------------------------------------===//
//
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_SOURCE_PLUGINS_PLATFORM_OHOS_PLATFORMOHOS_H
#define LLDB_SOURCE_PLUGINS_PLATFORM_OHOS_PLATFORMOHOS_H

#include <memory>
#include <string>

#include "Plugins/Platform/Linux/PlatformLinux.h"

#include "HdcClient.h"

namespace lldb_private {
namespace platform_ohos {

class PlatformOHOS : public platform_linux::PlatformLinux {
public:
  explicit PlatformOHOS(bool is_host);

  ~PlatformOHOS() override;

  static void Initialize();

  static void Terminate();

  static lldb::PlatformSP CreateInstance(bool force, const ArchSpec *arch);

  static llvm::StringRef GetPluginNameStatic(bool is_host) {
    return is_host ? Platform::GetHostPlatformName() : "remote-ohos";
  }

  static const char *GetPluginDescriptionStatic(bool is_host);

  llvm::StringRef GetPluginName() override;

  Status ConnectRemote(Args &args) override;

  uint32_t GetSdkVersion();

  bool GetRemoteOSVersion() override;

  Status DisconnectRemote() override;

  uint32_t GetDefaultMemoryCacheLineSize() override;

  Status GetFile(const FileSpec &source, const FileSpec &destination) override;

  Status PutFile(const FileSpec &source, const FileSpec &destination,
                 uint32_t uid = UINT32_MAX, uint32_t gid = UINT32_MAX) override;

  MmapArgList GetMmapArgumentList(const ArchSpec &arch, lldb::addr_t addr,
                                  lldb::addr_t length, unsigned prot,
                                  unsigned flags, lldb::addr_t fd,
                                  lldb::addr_t offset) override;

protected:

  llvm::StringRef
  GetLibdlFunctionDeclarations(lldb_private::Process *process) override;

  const char *GetCacheHostname() override;

  Status DownloadModuleSlice(const FileSpec &src_file_spec,
                             const uint64_t src_offset, const uint64_t src_size,
                             const FileSpec &dst_file_spec) override;

  HdcClient CreateHdcClient();

private:
  std::string m_device_id;
  std::string m_connect_addr;
  uint32_t m_sdk_version;

  PlatformOHOS(const PlatformOHOS &other) = delete;
  PlatformOHOS& operator=(const PlatformOHOS &other) = delete;
};

} // namespace platform_ohos
} // namespace lldb_private

#endif // LLDB_SOURCE_PLUGINS_PLATFORM_OHOS_PLATFORMOHOS_H

# Introduction to cjdb

## Introduction

CJDB is a command-line debugging tool for Cangjie programming language developed based on `lldb`. The current `cjdb` tool is an adapted and evolved tool based on [llvm15.0.4](https://github.com/llvm/llvm-project/releases/tag/llvmorg-15.0.4). It provides debugging capabilities for Cangjie developers. For more information, please refer to the [Cangjie Debugger](https://cangjie-lang.cn/docs?url=%2F1.0.0%2Ftools%2Fsource_zh_cn%2Ftools%2Fcjdb_manual_cjnative.html).

This repository provides the source code of the cjdb debugger tool. The architecture is shown in the following diagram:

![Architecture Diagram](docs/CJDB_Architecture_Diagram.png)

## Directory Structure

```text
lldb/
├─bindings                      # 各种语言与LLDB交互的绑定代码
├─cmake                         # Cmake构建系统相关的配置文件
├─docs                          # 文档
├─examples                      # 示例代码
├─include                       # 公共头文件
├─packages                      # 打包脚本
├─resources                     # 运行所需各类资源文件
├─scripts                       # 辅助脚本
├─source                        # 核心源代码目录，Plugins包含cangjie扩展
├─test                          # 测试脚本及测试用例
├─third_party                   # 三方库
├─tools                         # 与LLDB集成的工具
├─unittests                     # 单元测试
└─utils                         # 通用工具类和辅助函数
```

## Constraints

Building the Cangjie compiler is supported on Ubuntu/MacOS (x86_64, aarch64) environments. For more details on environment and tool dependencies, please refer to the [Build Environment Guide](https://gitcode.com/Cangjie/cangjie_build).

## Building from Source

Download the source code:

```shell
$ git clone https://gitcode.com/Cangjie/cangjie-compiler.git -b release-cangjie-merged;
```

### Build Steps

```shell
$ cd cangjie-compiler
$ python3 build.py clean
$ python3 build.py build -t release --build-cjdb
$ python3 build.py install
```

1. The `clean` command clears temporary files in the workspace.
2. The `build` command starts compilation. The `-t` or `--build-type` option specifies the build type, which can be `release` or `debug`.
3. The `install` command installs the build artifacts to the `output` directory.

The `output` directory structure is as follows:

```text
./output
├── bin                     # Cangjie executable
├── envsetup.sh             # One-click environment variable setup script
├── include                 # Public header files for the frontend
├── lib                     # Libraries required by the Cangjie build, subfolders by target platform
├── modules                 # Reserved folder for Cangjie standard library cjo files, subfolders by target platform
├── runtime                 # Runtime libraries required by the Cangjie build
├── third_party             # Third-party binaries and libraries such as LLVM
└── tools                   # cangjie tools
│   ├── bin                 # contain CJDB executable
│   ├── config
│   └── lib
```

## Related Repositories

This repository contains the Cangjie compiler source code. The complete compiler ecosystem also includes:

- [Cangjie Tools](https://gitcode.com/Cangjie/cangjie-tools/tree/release-cangjie-merged): Tool suite for Cangjie, including code formatting, package management, and more.
- [Cangjie Language Developer Guide](https://gitcode.com/Cangjie/cangjie-docs/tree/release-cangjie-merged/docs/dev-guide): Usage guide for Cangjie language development.
- [Cangjie Standard Library](https://gitcode.com/Cangjie/cangjie-runtime/tree/release-cangjie-merged/runtime): Source code for the Cangjie standard library.
- [Cangjie Runtime](https://gitcode.com/Cangjie/cangjie-runtime/tree/release-cangjie-merged/std): Essential standard library code for the Cangjie language.

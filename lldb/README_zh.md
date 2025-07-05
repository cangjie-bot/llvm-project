# `cjdb` 工具介绍

CJDB 是一款基于 `lldb` 开发的仓颉程序命令行调试工具。当前 `cjdb` 工具是在[llvm15.0.4](https://github.com/llvm/llvm-project/releases/tag/llvmorg-15.0.4)基础上适配演进出来的工具。为仓颉开发者提供程序调试的能力。

## `cjdb` 工具获取

### 获取方式

通过 `Cangjie` 的 `SDK` 获取，获取路径：每日构建。

`cjdb` 工具在 `SDK` 中的路径：`cangjie\tools\bin` 。

### 使用举例

下面以 `Windows` 平台使用方式举例

  解压，直接在 `cjdb` 工具所在路径 `cangjie\tools\bin` 运行 `cjdb.exe` 即可。

## 工具编译

`cjdb` 工具构建需进入仓颉项目并执行如下命令：

```Bash
cd cangjie
ln -s ../../llvm-project ./third_party/llvm-project
ln -s ../../runtime ./third_party/runtime
./build.py clean
./build.py build --cjnative -t release --build-cjdb --compile-backend
./build.py install
```

### 获取更多帮助信息

执行如下命令:

```Bash
./build.py build --help
```

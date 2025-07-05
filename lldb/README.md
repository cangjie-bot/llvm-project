# Introduction to cjdb

CJDB is a command-line debugging tool for Cangjie programming language developed based on `lldb`. The current `cjdb` tool is an adapted and evolved tool based on [llvm15.0.4](https://github.com/llvm/llvm-project/releases/tag/llvmorg-15.0.4). It provides debugging capabilities for Cangjie developers.

## Obtaining `cjdb`

### Obtaining method

Obtain the Cangjie SDK from Daily Build.

`cjdb` is in the following path of the SDK: `cangjie\tools\bin`.

### Usage example

The following uses the Windows platform as an example:

  Decompress the SDK and run `cjdb.exe` in the `**\cangjie\tools\bin`.

## How to Build

Enter the cangjie project directory and then run the commands as following:：

```Bash
cd cangjie
ln -s ../../llvm-project ./third_party/llvm-project
ln -s ../../runtime ./third_party/runtime
./build.py clean
./build.py build --cjnative -t release --build-cjdb --compile-backend
./build.py install
```

### Get More Help Information

For more information, please take a look at the build.py or use `--help`:

```Bash
./build.py build --help
```

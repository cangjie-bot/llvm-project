include_directories(${CANGJIE_DEMANGLE_DIR})
add_llvm_component_library(LLVMCjcObf
  ControlFlowObfuscator.cpp
  DataObfuscator.cpp
  LayoutObfuscator.cpp

  ADDITIONAL_HEADER_DIRS
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms
  ${CANGJIE_DEMANGLE_DIR}

  DEPENDS
  intrinsics_gen

  LINK_COMPONENTS
  Core
  Support
  Analysis
  TransformUtils
  )

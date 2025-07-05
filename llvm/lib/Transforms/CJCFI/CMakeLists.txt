add_llvm_component_library(LLVMCJCFI
  PtrAuthBackwardCFI.cpp

  ADDITIONAL_HEADER_DIRS
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms

  DEPENDS
  intrinsics_gen

  LINK_COMPONENTS
  Core
  Support
  Analysis
  TransformUtils
  )

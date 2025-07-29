include_directories(${CANGJIE_DEMANGLE_DIR})
add_llvm_component_library(LLVMCore
  AbstractCallSite.cpp
  AsmWriter.cpp
  Assumptions.cpp
  Attributes.cpp
  AutoUpgrade.cpp
  BasicBlock.cpp
  BuiltinGCs.cpp
  CJIntrinsics.cpp
  Comdat.cpp
  ConstantFold.cpp
  ConstantRange.cpp
  Constants.cpp
  Core.cpp
  DIBuilder.cpp
  DataLayout.cpp
  DebugInfo.cpp
  DebugInfoMetadata.cpp
  DebugLoc.cpp
  DiagnosticHandler.cpp
  DiagnosticInfo.cpp
  DiagnosticPrinter.cpp
  Dominators.cpp
  FPEnv.cpp
  Function.cpp
  GCStrategy.cpp
  GVMaterializer.cpp
  Globals.cpp
  IRBuilder.cpp
  IRPrintingPasses.cpp
  SSAContext.cpp
  InlineAsm.cpp
  Instruction.cpp
  Instructions.cpp
  IntrinsicInst.cpp
  LLVMContext.cpp
  LLVMContextImpl.cpp
  LLVMRemarkStreamer.cpp
  LegacyPassManager.cpp
  MDBuilder.cpp
  Mangler.cpp
  Metadata.cpp
  Module.cpp
  ModuleSummaryIndex.cpp
  Operator.cpp
  OptBisect.cpp
  Pass.cpp
  PassInstrumentation.cpp
  PassManager.cpp
  PassRegistry.cpp
  PassTimingInfo.cpp
  PrintPasses.cpp
  SafepointIRVerifier.cpp
  ProfileSummary.cpp
  PseudoProbe.cpp
  ReplaceConstant.cpp
  Statepoint.cpp
  CJStructTypeGCInfo.cpp
  StructuralHash.cpp
  Type.cpp
  TypeFinder.cpp
  Use.cpp
  User.cpp
  Value.cpp
  ValueSymbolTable.cpp
  VectorBuilder.cpp
  Verifier.cpp

  ADDITIONAL_HEADER_DIRS
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/IR
  ${CANGJIE_DEMANGLE_DIR}

  LINK_LIBS
  ${LLVM_PTHREAD_LIB}

  DEPENDS
  intrinsics_gen

  LINK_COMPONENTS
  BinaryFormat
  Remarks
  Support
  )

if(BUILD_SHARED_LIBS)
  target_link_libraries(LLVMCore PRIVATE ${CANGJIE_DEMANGLE_DIR}/libcangjie-demangle.a)
else()
  target_link_libraries(LLVMCore PRIVATE -fstack-protector-all)
  if(WIN32)
    add_custom_command(TARGET LLVMCore
      POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}/tmp
      COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/tmp
      COMMAND ${CMAKE_COMMAND} -E copy ${CANGJIE_DEMANGLE_DIR}/libcangjie-demangle.a
                                       ${CMAKE_BINARY_DIR}/lib/
      COMMAND cd ${CMAKE_BINARY_DIR}/tmp
      COMMAND ${CMAKE_AR} x ${CMAKE_BINARY_DIR}/lib/libLLVMCore.a
      COMMAND ${CMAKE_AR} x ${CMAKE_BINARY_DIR}/lib/libcangjie-demangle.a
      COMMAND ${CMAKE_AR} cr ${CMAKE_BINARY_DIR}/lib/libLLVMCore.a ${CMAKE_BINARY_DIR}/tmp/*${CMAKE_CXX_OUTPUT_EXTENSION}
    )
  else()
    add_custom_command(TARGET LLVMCore
      POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}/tmp
      COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/tmp
      COMMAND ${CMAKE_COMMAND} -E copy ${CANGJIE_DEMANGLE_DIR}/libcangjie-demangle.a
                                       ${CMAKE_BINARY_DIR}/lib/
      COMMAND cd ${CMAKE_BINARY_DIR}/tmp && ${CMAKE_AR} x ${CMAKE_BINARY_DIR}/lib/libLLVMCore.a
      COMMAND cd ${CMAKE_BINARY_DIR}/tmp && ${CMAKE_AR} x ${CMAKE_BINARY_DIR}/lib/libcangjie-demangle.a
      COMMAND cd ${CMAKE_BINARY_DIR}/tmp && ${CMAKE_AR} cr ${CMAKE_BINARY_DIR}/lib/libLLVMCore.a *.o
    )
  endif()
endif()

if(NOT DEFINED CANGJIE_ROOT)
  set(CANGJIE_ROOT ${CMAKE_SOURCE_DIR}/../../cangjie)
endif()
include_directories(${CANGJIE_ROOT}/include)

add_lldb_library(lldbPluginCXXItaniumABI PLUGIN
  ItaniumABILanguageRuntime.cpp

  LINK_LIBS
    lldbBreakpoint
    lldbCore
    lldbInterpreter
    lldbSymbol
    lldbTarget
    lldbPluginCPPRuntime
    lldbPluginTypeSystemClang
  )

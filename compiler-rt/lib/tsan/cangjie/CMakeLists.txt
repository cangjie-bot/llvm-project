set(COMMON_TSAN_SOURCE
	tsan_cangjie.cpp
	../rtl/tsan_external.cpp
	../rtl/tsan_flags.cpp
	../rtl/tsan_interface_atomic.cpp
	../rtl/tsan_md5.cpp
	../rtl/tsan_mutexset.cpp
	../rtl/tsan_report.cpp
	../rtl/tsan_rtl.cpp
	../rtl/tsan_rtl_access.cpp
	../rtl/tsan_rtl_mutex.cpp
	../rtl/tsan_rtl_report.cpp
	../rtl/tsan_rtl_thread.cpp
	../rtl/tsan_rtl_proc.cpp
	../rtl/tsan_stack_trace.cpp
	../rtl/tsan_suppressions.cpp
	../rtl/tsan_symbolize.cpp
	../rtl/tsan_sync.cpp
	../rtl/tsan_vector_clock.cpp
	../../sanitizer_common/sanitizer_allocator.cpp
	../../sanitizer_common/sanitizer_common.cpp
	../../sanitizer_common/sanitizer_common_libcdep.cpp
	../../sanitizer_common/sanitizer_deadlock_detector2.cpp
	../../sanitizer_common/sanitizer_file.cpp
	../../sanitizer_common/sanitizer_flag_parser.cpp
	../../sanitizer_common/sanitizer_flags.cpp
	../../sanitizer_common/sanitizer_libc.cpp
	../../sanitizer_common/sanitizer_mutex.cpp
	../../sanitizer_common/sanitizer_printf.cpp
	../../sanitizer_common/sanitizer_suppressions.cpp
	../../sanitizer_common/sanitizer_stack_store.cpp
	../../sanitizer_common/sanitizer_stackdepot.cpp
	../../sanitizer_common/sanitizer_stacktrace.cpp
	../../sanitizer_common/sanitizer_stacktrace_libcdep.cpp
	../../sanitizer_common/sanitizer_symbolizer.cpp
	../../sanitizer_common/sanitizer_symbolizer_libcdep.cpp
	../../sanitizer_common/sanitizer_symbolizer_report.cpp
	../../sanitizer_common/sanitizer_symbolizer_libbacktrace.cpp
	../../sanitizer_common/sanitizer_termination.cpp
	../../sanitizer_common/sanitizer_thread_registry.cpp
	../../sanitizer_common/sanitizer_stacktrace_printer.cpp
)

set(CJ_TSAN_CFLAG -Wall -fno-exceptions -fno-rtti -fno-omit-frame-pointer -DSANITIZER_CJ=1 -DSANITIZER_DEADLOCK_DETECTOR_VERSION=2)

string(TOUPPER "${CMAKE_BUILD_TYPE}" uppercase_CMAKE_BUILD_TYPE)
if (uppercase_CMAKE_BUILD_TYPE MATCHES "DEBUG")
    set(CJ_TSAN_CFLAG ${CJ_TSAN_CFLAG} -DSANITIZER_DEBUG=1 -g)
else ()
    set(CJ_TSAN_CFLAG ${CJ_TSAN_CFLAG} -DSANITIZER_DEBUG=0 -O3)
endif ()

if (OS_NAME MATCHES "Linux")
    set(CJ_TSAN_CFLAG ${CJ_TSAN_CFLAG} -fPIC -Wno-uninitialized -Wno-suggest-override -Wno-format-pedantic -Wno-c99-extensions -Wno-gnu-zero-variadic-macro-arguments -Wno-unused-function)
    set(CJ_TSAN_LDFLAG -lpthread -fPIC -fpie)
    set(TSAN_SOURCE
        ${COMMON_TSAN_SOURCE}
        ../rtl/tsan_platform_linux.cpp
		../rtl/tsan_platform_posix.cpp
		../../sanitizer_common/sanitizer_linux.cpp
		../../sanitizer_common/sanitizer_linux_libcdep.cpp
		../../sanitizer_common/sanitizer_platform_limits_posix.cpp
		../../sanitizer_common/sanitizer_posix.cpp
		../../sanitizer_common/sanitizer_posix_libcdep.cpp
		../../sanitizer_common/sanitizer_procmaps_common.cpp
		../../sanitizer_common/sanitizer_procmaps_linux.cpp
		../../sanitizer_common/sanitizer_stoptheworld_linux_libcdep.cpp
		../../sanitizer_common/sanitizer_symbolizer_posix_libcdep.cpp
		../../sanitizer_common/sanitizer_unwind_linux_libcdep.cpp
    )

    if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86_64")
        set(CJ_TSAN_CFLAG ${CJ_TSAN_CFLAG} -m64 -msse3)
        set(CJ_TSAN_LDFLAG ${CJ_TSAN_LDFLAG} -ffreestanding -Wno-unused-const-variable -Wno-unknown-warning-option)
    elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "aarch64")

    else()
        message(WARNING "TSan for cangjie is not support on ${CMAKE_SYSTEM_PROCESSOR} for now")
        return()
    endif ()
    set(libname clang_rt.tsan_cangjie-${CMAKE_SYSTEM_PROCESSOR})
else ()
    message(WARNING "TSan for cangjie is not support on ${OS_NAME} for now")
    return()
endif ()

add_library(${libname} STATIC ${TSAN_SOURCE})
target_include_directories(${libname} PRIVATE ../rtl)
target_include_directories(${libname} PRIVATE ../../sanitizer_common)
target_include_directories(${libname} PRIVATE ../../)
target_include_directories(${libname} PRIVATE ../../../include)
target_compile_options(${libname} PRIVATE ${CJ_TSAN_CFLAG})
target_link_options(${libname} PRIVATE ${CJ_TSAN_LDFLAG})
get_compiler_rt_install_dir(${CMAKE_SYSTEM_PROCESSOR} install_dir_tsan_cangjie)

add_sanitizer_rt_symbols(clang_rt.tsan_cangjie
	ARCHS ${CMAKE_SYSTEM_PROCESSOR}
	EXTRA ../rtl/tsan.syms.extra)

install(TARGETS ${libname}
        ARCHIVE DESTINATION ${install_dir_tsan_cangjie}
            COMPONENT ${libname}
        LIBRARY DESTINATION ${install_dir_tsan_cangjie}
            COMPONENT ${libname}
        RUNTIME DESTINATION ${install_dir_tsan_cangjie}
            COMPONENT ${libname})

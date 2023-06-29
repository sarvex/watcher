option(WTR_WATCHER_USE_RELEASE     "Build with all optimizations"                ON)
option(WTR_WATCHER_USE_TEST        "Build the test programs"                     OFF)
option(WTR_WATCHER_USE_BENCH       "Build the benchmarking programs"             OFF)
option(WTR_WATCHER_USE_NOSAN       "This option does nothing"                    OFF)
option(WTR_WATCHER_USE_ASAN        "Build with the address sanitizer"            OFF)
option(WTR_WATCHER_USE_MSAN        "Build with the memory sanitizer"             OFF)
option(WTR_WATCHER_USE_TSAN        "Build with the thread sanitizer"             OFF)
option(WTR_WATCHER_USE_UBSAN       "Build with the undefined behavior sanitizer" OFF)
option(WTR_WATCHER_USE_STACKSAN    "Build with the stack safety sanitizer"       OFF)
option(WTR_WATCHER_USE_DATAFLOWSAN "Build with the data flow sanitizer"          OFF)
option(WTR_WATCHER_USE_CFISAN      "Build with the cfi sanitizer"                OFF)
option(WTR_WATCHER_USE_KCFISAN     "Build with the kernel cfi sanitizer"         OFF)

set(WTR_WATCHER_CXX_STD 20)

if(MSVC)
# It's not that we don't want these, it's just that I hate Windows.
# Also, MSVC doesn't support some of these arguments, so it's not possible.
set(COMPILE_OPTIONS_HIGH_ERR)
else()
set(COMPILE_OPTIONS_HIGH_ERR
  "-Wall"
  "-Wextra"
  "-Werror"
  "-Wno-unused-function"
  "-Wno-unneeded-internal-declaration")
endif()
if(MSVC)
set(COMPILE_OPTIONS_RELEASE
  "-O2"
  "${COMPILE_OPTIONS_HIGH_ERR}")
else()
set(COMPILE_OPTIONS_RELEASE
  "-O3"
  "${COMPILE_OPTIONS_HIGH_ERR}")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Android")
  # Android's stdlib ("bionic") doesn't need
  # to be linked with a pthread-like library.
  set(LINK_LIBRARIES)
else()
  find_package(Threads REQUIRED)
  set(LINK_LIBRARIES "Threads::Threads")
  if(APPLE)
    list(APPEND LINK_LIBRARIES
      "-framework CoreFoundation"
      "-framework CoreServices")
  endif()
endif()

set(TEST_LINK_LIBRARIES
  "${LINK_LIBRARIES}"
  "snitch::snitch")

set(WTR_WATCHER_SOURCE_SET
  "${WTR_WATCHER_ROOT_SOURCE_DIR}/src/wtr.watcher/main.cpp")

set(WTR_TEST_WATCHER_PROJECT_NAME
  "test_watcher")
set(WTR_TEST_WATCHER_SOURCE_SET
  "test_concurrent_watch_targets"
  "test_watch_targets"
  "test_new_directories"
  "test_simple")
list(TRANSFORM WTR_TEST_WATCHER_SOURCE_SET PREPEND
  "${WTR_WATCHER_ROOT_SOURCE_DIR}/src/${WTR_TEST_WATCHER_PROJECT_NAME}/")
list(TRANSFORM WTR_TEST_WATCHER_SOURCE_SET APPEND ".cpp")

set(WTR_BENCH_WATCHER_PROJECT_NAME
  "bench_watcher")
set(WTR_BENCH_WATCHER_SOURCE_SET
  "bench_concurrent_watch_targets")
list(TRANSFORM WTR_BENCH_WATCHER_SOURCE_SET PREPEND
  "${WTR_WATCHER_ROOT_SOURCE_DIR}/src/${WTR_BENCH_WATCHER_PROJECT_NAME}/")
list(TRANSFORM WTR_BENCH_WATCHER_SOURCE_SET APPEND ".cpp")

set(INCLUDE_PATH_SINGLE_HEADER
  "${WTR_WATCHER_ROOT_SOURCE_DIR}/include")
set(INCLUDE_PATH_DEVEL
  "${WTR_WATCHER_ROOT_SOURCE_DIR}/devel/include")

set(LINK_OPTIONS)

set(COMPILE_OPTIONS_HIGH_ERR_ASAN "${COMPILE_OPTIONS_HIGH_ERR}"
  "-fno-omit-frame-pointer" "-fsanitize=address")
set(COMPILE_OPTIONS_HIGH_ERR_MSAN "${COMPILE_OPTIONS_HIGH_ERR}"
  "-fno-omit-frame-pointer" "-fsanitize=memory")
set(COMPILE_OPTIONS_HIGH_ERR_TSAN "${COMPILE_OPTIONS_HIGH_ERR}"
  "-fno-omit-frame-pointer" "-fsanitize=memory")
set(COMPILE_OPTIONS_HIGH_ERR_UBSAN "${COMPILE_OPTIONS_HIGH_ERR}"
  "-fno-omit-frame-pointer" "-fsanitize=undefined")
set(COMPILE_OPTIONS_HIGH_ERR_STACKSAN "${COMPILE_OPTIONS_HIGH_ERR}"
  "-fno-omit-frame-pointer" "-fsanitize=safe-stack")
set(COMPILE_OPTIONS_HIGH_ERR_DATAFLOWSAN "${COMPILE_OPTIONS_HIGH_ERR}"
  "-fno-omit-frame-pointer" "-fsanitize=dataflow")
set(COMPILE_OPTIONS_HIGH_ERR_CFISAN "${COMPILE_OPTIONS_HIGH_ERR}"
  "-fno-omit-frame-pointer" "-fsanitize=cfi")
set(COMPILE_OPTIONS_HIGH_ERR_KCFISAN "${COMPILE_OPTIONS_HIGH_ERR}"
  "-fno-omit-frame-pointer" "-fsanitize=kcfi")
set(COMPILE_OPTIONS_RELEASE_ASAN "${COMPILE_OPTIONS_RELEASE}"
  "-fno-omit-frame-pointer" "-fsanitize=address")
set(COMPILE_OPTIONS_RELEASE_MSAN "${COMPILE_OPTIONS_RELEASE}"
  "-fno-omit-frame-pointer" "-fsanitize=memory")
set(COMPILE_OPTIONS_RELEASE_TSAN "${COMPILE_OPTIONS_RELEASE}"
  "-fno-omit-frame-pointer" "-fsanitize=memory")
set(COMPILE_OPTIONS_RELEASE_UBSAN "${COMPILE_OPTIONS_RELEASE}"
  "-fno-omit-frame-pointer" "-fsanitize=undefined")
set(COMPILE_OPTIONS_RELEASE_STACKSAN "${COMPILE_OPTIONS_RELEASE}"
  "-fno-omit-frame-pointer" "-fsanitize=safe-stack")
set(COMPILE_OPTIONS_RELEASE_DATAFLOWSAN "${COMPILE_OPTIONS_RELEASE}"
  "-fno-omit-frame-pointer" "-fsanitize=dataflow")
set(COMPILE_OPTIONS_RELEASE_CFISAN "${COMPILE_OPTIONS_RELEASE}"
  "-fno-omit-frame-pointer" "-fsanitize=cfi")
set(COMPILE_OPTIONS_RELEASE_KCFISAN "${COMPILE_OPTIONS_RELEASE}"
  "-fno-omit-frame-pointer" "-fsanitize=kcfi")
set(LINK_OPTIONS_ASAN "${LINK_OPTIONS}"
  "-fno-omit-frame-pointer" "-fsanitize=address")
set(LINK_OPTIONS_MSAN "${LINK_OPTIONS}"
  "-fno-omit-frame-pointer" "-fsanitize=memory")
set(LINK_OPTIONS_TSAN "${LINK_OPTIONS}"
  "-fno-omit-frame-pointer" "-fsanitize=memory")
set(LINK_OPTIONS_UBSAN "${LINK_OPTIONS}"
  "-fno-omit-frame-pointer" "-fsanitize=undefined")
set(LINK_OPTIONS_STACKSAN "${LINK_OPTIONS}"
  "-fno-omit-frame-pointer" "-fsanitize=safe-stack")
set(LINK_OPTIONS_DATAFLOWSAN "${LINK_OPTIONS}"
  "-fno-omit-frame-pointer" "-fsanitize=dataflow")
set(LINK_OPTIONS_CFISAN "${LINK_OPTIONS}"
  "-fno-omit-frame-pointer" "-fsanitize=cfi")
set(LINK_OPTIONS_KCFISAN "${LINK_OPTIONS}"
  "-fno-omit-frame-pointer" "-fsanitize=kcfi")

function(WTR_ADD_TARGET
      NAME
      IS_TEST
      IS_INSTALLABLE
      SRC_SET
      COPT_SET
      LOPT_SET
      INCLUDE_PATH
      LLIB_SET)
  if(IS_TEST)
    include(CTest)
    include(FetchContent)
    FetchContent_Declare(
      snitch
      GIT_REPOSITORY https://github.com/cschreib/snitch.git
      GIT_TAG        ea200a0830394f8e0ef732064f0935a77c003bd6 # Friday, January 20th, 2023 @ v1.0.0
      # GIT_TAG        8165d6c85353f9c302ce05f1c1c47dcfdc6aeb2c # Saturday, January 7th, 2023 @ main
      # GIT_TAG        f313bccafe98aaef617af3bf457d091d8d50cdcd # Tuesday, December 18th, 2022 @ v0.1.3
      # GIT_TAG        c0b6ac4efe4019e4846e8967fe21de864b0cc1ed # Friday, December 2nd, 2022 @ main
    )
    FetchContent_MakeAvailable(snitch)
    set(RUNTIME_TEST_FILES "${SRC_SET}") # For Snitch
  endif()
  add_executable("${NAME}" "${SRC_SET}")
  set_property(TARGET "${NAME}" PROPERTY CXX_STANDARD "${WTR_WATCHER_CXX_STD}")
  target_compile_options("${NAME}" PRIVATE "${COPT_SET}")
  target_link_options("${NAME}" PRIVATE "${LOPT_SET}")
  target_include_directories("${NAME}" PUBLIC "${INCLUDE_PATH}")
  target_link_libraries("${NAME}" PRIVATE "${LLIB_SET}")
  if(APPLE)
    set_property(
      TARGET "${NAME}"
      PROPERTY XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "org.${NAME}")
  endif()
  if(IS_INSTALLABLE)
    include(GNUInstallDirs)
    install(
      TARGETS                   "${NAME}"
      LIBRARY DESTINATION       "${CMAKE_INSTALL_LIBDIR}"
      BUNDLE DESTINATION        "${CMAKE_INSTALL_PREFIX}/bin"
      PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
  endif()
endfunction()

function(WTR_ADD_TEST_TARGET NAME COPT_SET LOPT_SET)
  wtr_add_target(
    "${NAME}"
    "ON"
    "OFF"
    "${WTR_TEST_WATCHER_SOURCE_SET}"
    "${COPT_SET}"
    "${LOPT_SET}"
    "${INCLUDE_PATH_DEVEL}"
    "${TEST_LINK_LIBRARIES}")
endfunction()

function(WTR_ADD_BENCH_TARGET NAME COPT_SET LOPT_SET)
  wtr_add_target(
    "${NAME}"
    "ON"
    "OFF"
    "${WTR_BENCH_WATCHER_SOURCE_SET}"
    "${COPT_SET}"
    "${LOPT_SET}"
    "${INCLUDE_PATH_DEVEL}"
    "${TEST_LINK_LIBRARIES}")
endfunction()
cmake_minimum_required(VERSION 3.21)

project(
  FixFormat
  VERSION 1.1.0
  DESCRIPTION "Fix source codes formatting in your CMake project"
  HOMEPAGE_URL https://github.com/threeal/FixFormat.cmake
  LANGUAGES NONE)

option(FIX_FORMAT_ENABLE_TESTS "Enable test targets.")
option(FIX_FORMAT_ENABLE_INSTALL
  "Enable install targets." "${PROJECT_IS_TOP_LEVEL}")

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# Prefer system packages over the find modules provided by this project.
if(NOT DEFINED CMAKE_FIND_PACKAGE_PREFER_CONFIG)
  set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)
endif()

# Include the main module.
include(FixFormat)

if(FIX_FORMAT_ENABLE_TESTS)
  enable_testing()

  find_package(Assertion 2.0.0 REQUIRED)
  add_cmake_script_test(test/fix_format.cmake DEFINITIONS CMAKE_MODULE_PATH)
endif()

if(FIX_FORMAT_ENABLE_INSTALL)
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/cmake/FixFormatConfig.cmake
    "list(PREPEND CMAKE_MODULE_PATH \${CMAKE_CURRENT_LIST_DIR})\n"
    "include(FixFormat)\n")

  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(cmake/FixFormatConfigVersion.cmake
    COMPATIBILITY SameMajorVersion ARCH_INDEPENDENT)

  install(
    FILES cmake/FixFormat.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/cmake/FixFormatConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/cmake/FixFormatConfigVersion.cmake
    DESTINATION lib/cmake/FixFormat)

  set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}")
  include(CPack)
endif()

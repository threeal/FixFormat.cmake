cmake_minimum_required(VERSION 3.21)

project(
  FixFormat
  VERSION 1.1.0
  DESCRIPTION "Fix source codes formatting in your CMake project"
  HOMEPAGE_URL https://github.com/threeal/FixFormat.cmake
  LANGUAGES NONE
)

option(FIX_FORMAT_ENABLE_TESTS "Enable test targets.")
option(FIX_FORMAT_ENABLE_INSTALL "Enable install targets."
  "${PROJECT_IS_TOP_LEVEL}")

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# Include the main module.
include(FixFormat)

if(FIX_FORMAT_ENABLE_TESTS)
  enable_testing()

  file(
    DOWNLOAD https://github.com/threeal/assertion-cmake/releases/download/v2.0.0/Assertion.cmake
      ${CMAKE_BINARY_DIR}/cmake/Assertion.cmake
    EXPECTED_MD5 5ebe475aee6fc5660633152f815ce9f6)
  include(${CMAKE_BINARY_DIR}/cmake/Assertion.cmake)

  add_cmake_script_test(test/fix_format.cmake
    DEFINITIONS CMAKE_MODULE_PATH=${CMAKE_BINARY_DIR}/cmake)
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

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

include(cmake/FixFormat.cmake)

if(FIX_FORMAT_ENABLE_TESTS)
  enable_testing()

  file(
    DOWNLOAD https://github.com/threeal/assertion-cmake/releases/download/v1.0.0/Assertion.cmake
      ${CMAKE_BINARY_DIR}/Assertion.cmake
    EXPECTED_MD5 1d8ec589d6cc15772581bf77eb3873ff)
  include(${CMAKE_BINARY_DIR}/Assertion.cmake)

  assertion_add_test(test/fix_format.cmake)
endif()

if(FIX_FORMAT_ENABLE_INSTALL)
  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(
    FixFormatConfigVersion.cmake
    COMPATIBILITY SameMinorVersion
  )

  install(
    FILES
      cmake/FixFormat.cmake
      cmake/FixFormatConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/FixFormatConfigVersion.cmake
    DESTINATION lib/cmake/FixFormat
  )
endif()

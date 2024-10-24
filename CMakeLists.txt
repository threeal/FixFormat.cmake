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
    DOWNLOAD https://github.com/threeal/assertion-cmake/releases/download/v2.0.0/Assertion.cmake
      ${CMAKE_BINARY_DIR}/cmake/Assertion.cmake
    EXPECTED_MD5 5ebe475aee6fc5660633152f815ce9f6)
  include(${CMAKE_BINARY_DIR}/cmake/Assertion.cmake)

  add_cmake_script_test(test/fix_format.cmake
    DEFINITIONS CMAKE_MODULE_PATH=${CMAKE_BINARY_DIR}/cmake)
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

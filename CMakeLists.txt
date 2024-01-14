cmake_minimum_required(VERSION 3.21)

project(
  FixFormat
  VERSION 0.0.0
  DESCRIPTION "Fix source codes formatting in your CMake project"
  HOMEPAGE_URL https://github.com/threeal/FixFormat.cmake
  LANGUAGES NONE
)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR AND BUILD_TESTING)
  enable_testing()

  list(APPEND ARGS -B ${CMAKE_CURRENT_BINARY_DIR} -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH})

  add_test(
    NAME "Testing source codes formatting"
    COMMAND cmake ${ARGS} -P ${CMAKE_CURRENT_SOURCE_DIR}/test/FixFormatTest.cmake
  )
endif()

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  FixFormatConfigVersion.cmake
  COMPATIBILITY SameMajorVersion
)

install(
  FILES
    cmake/FixFormat.cmake
    cmake/FixFormatConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/FixFormatConfigVersion.cmake
  DESTINATION lib/cmake/FixFormat
)

cmake_minimum_required(VERSION 3.18)

project(
  FixFormat
  VERSION 0.0.0
  DESCRIPTION "Fix source codes formatting in your CMake project "
  HOMEPAGE_URL https://github.com/threeal/FixFormat.cmake
  LANGUAGES NONE
)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(MkdirRecursive)

if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR AND BUILD_TESTING)
  enable_testing()

  list(APPEND ARGS -B ${CMAKE_CURRENT_BINARY_DIR} -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH})

  add_test(
    NAME MkdirRecursiveTest
    COMMAND cmake ${ARGS} -P ${CMAKE_CURRENT_SOURCE_DIR}/test/MkdirRecursiveTest.cmake
  )
endif()

install(
  FILES cmake/MkdirRecursive.cmake
  DESTINATION lib/cmake
)

cmake_minimum_required(VERSION 3.18)

project(Sample LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 11)

find_package(FixFormat REQUIRED PATHS ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake)

add_library(sample src/fibonacci.cpp src/is_odd.cpp)

if(USE_FILE_SET_HEADERS)
  target_sources(
    sample PUBLIC
    FILE_SET HEADERS
    BASE_DIRS include
    FILES
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
  )
else()
  target_include_directories(sample PUBLIC include)
endif()

if(NOT USE_GLOBAL_FORMAT)
  target_fix_format(sample)
  if(FORMAT_TWICE)
    target_fix_format(sample)
  endif()
endif()

add_executable(main src/main.cpp)
target_link_libraries(main PRIVATE sample)

if(NOT USE_GLOBAL_FORMAT)
  target_fix_format(main)
  if(FORMAT_TWICE)
    target_fix_format(main)
  endif()
endif()

if(USE_GLOBAL_FORMAT)
  add_fix_format()
  if(FORMAT_TWICE)
    add_fix_format()
  endif()
endif()

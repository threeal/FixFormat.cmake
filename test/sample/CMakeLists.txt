cmake_minimum_required(VERSION 3.18)

project(Sample LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 11)

include(FixFormat)

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

if(USE_GLOBAL_FORMAT)
  add_fix_format()
else()
  target_fix_format(sample)
endif()

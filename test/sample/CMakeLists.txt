cmake_minimum_required(VERSION 3.18)

project(Sample LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 11)

include(FixFormat)

add_library(sample src/fibonacci.cpp src/is_odd.cpp)
target_include_directories(sample PUBLIC include)

target_fix_format(sample)

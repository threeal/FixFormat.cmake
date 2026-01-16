cmake_minimum_required(VERSION 3.21)

include(FixFormat RESULT_VARIABLE FIX_FORMAT_LIST_FILE)

file(WRITE include/foo.hpp "void foo();\n")

file(WRITE src/foo.cpp "void foo() {}\n")

file(WRITE sample/CMakeLists.txt
  "cmake_minimum_required(VERSION 3.5)\n"
  "project(Sample LANGUAGES CXX)\n"
  "\n"
  "include(${FIX_FORMAT_LIST_FILE})\n"
  "\n"
  "add_library(sample src/foo.cpp)\n"
  "target_include_directories(sample PUBLIC include)\n")

file(REMOVE_RECURSE sample)

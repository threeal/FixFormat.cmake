add_test(
  NAME "Testing source codes formatting"
  COMMAND ${CMAKE_COMMAND}
    -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/FixFormatTest.cmake
)

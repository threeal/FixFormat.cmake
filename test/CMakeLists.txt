function(add_cmake_test FILE)
  foreach(NAME ${ARGN})
    string(TOLOWER "${NAME}" TEST_COMMAND)
    string(REPLACE " " "_" TEST_COMMAND "${TEST_COMMAND}")
    add_test(
      NAME "${NAME}"
      COMMAND "${CMAKE_COMMAND}"
        -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
        -D TEST_COMMAND=${TEST_COMMAND}
        -P ${CMAKE_CURRENT_SOURCE_DIR}/${FILE}
    )
  endforeach()
endfunction()

add_cmake_test(
  FixFormatTest.cmake
  "Format sources files"
  "Format include directories"
  "Format header files"
  "Format all files globally"
  "Format all files of some targets without building"
  "Format all files of all targets without building"
  "Format all files twice"
  "Format all files globally twice"
)

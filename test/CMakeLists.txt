function(add_cmake_test FILE)
  math(EXPR STOP "${ARGC} - 1")
  foreach(I RANGE 1 "${STOP}")
    add_test(
      NAME "${ARGV${I}}"
      COMMAND "${CMAKE_COMMAND}"
        -D "TEST_COMMAND=${ARGV${I}}"
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

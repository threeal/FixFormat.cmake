# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

function(check_source_codes_format)
  cmake_parse_arguments(ARG "USE_GLOBAL_FORMAT;USE_FILE_SET_HEADERS;FORMAT_TWICE" "FORMAT_TARGET" "SRCS" ${ARGN})

  # Use the default source files if not specified.
  if(NOT ARG_SRCS)
    set(
      ARG_SRCS
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
      src/fibonacci.cpp
      src/is_odd.cpp
    )
  endif()

  message(STATUS "Getting the original source file hashes")
  foreach(SRC ${ARG_SRCS})
    file(MD5 ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC} ${SRC}_HASH)
  endforeach()

  execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)

  message(STATUS "Copying the dirty source files")
  foreach(SRC ${ARG_SRCS})
    file(
      COPY_FILE
      ${CMAKE_CURRENT_LIST_DIR}/sample/dirty/${SRC}
      ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC}
    )
  endforeach()

  message(STATUS "Configuring sample project")
  if(ARG_USE_GLOBAL_FORMAT)
    list(APPEND CONFIGURE_ARGS -D USE_GLOBAL_FORMAT=TRUE)
  endif()
  if(ARG_USE_FILE_SET_HEADERS)
    list(APPEND CONFIGURE_ARGS -D USE_FILE_SET_HEADERS=TRUE)
  endif()
  if(ARG_FORMAT_TWICE)
    list(APPEND CONFIGURE_ARGS -D FORMAT_TWICE=TRUE)
  endif()
  execute_process(
    COMMAND ${CMAKE_COMMAND}
      -B ${CMAKE_CURRENT_LIST_DIR}/sample/build
      -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
      ${CONFIGURE_ARGS}
      --fresh
      ${CMAKE_CURRENT_LIST_DIR}/sample
    RESULT_VARIABLE RES
  )
  if(NOT ${RES} EQUAL 0)
    message(FATAL_ERROR "Failed to configure sample project")
  endif()

  if(ARG_FORMAT_TARGET)
    message(STATUS "Formatting sample project")
    execute_process(
      COMMAND ${CMAKE_COMMAND}
        --build ${CMAKE_CURRENT_LIST_DIR}/sample/build
        --target ${ARG_FORMAT_TARGET}
      RESULT_VARIABLE RES
    )
    if(NOT ${RES} EQUAL 0)
      message(FATAL_ERROR "Failed to format sample project")
    endif()
  else()
    message(STATUS "Building sample project")
    execute_process(
      COMMAND ${CMAKE_COMMAND} --build ${CMAKE_CURRENT_LIST_DIR}/sample/build
      RESULT_VARIABLE RES
    )
    if(NOT ${RES} EQUAL 0)
      message(FATAL_ERROR "Failed to build sample project")
    endif()
  endif()

  message(STATUS "Comparing the source file hashes")
  foreach(SRC ${ARG_SRCS})
    file(MD5 ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC} HASH)
    if(NOT ${HASH} STREQUAL ${${SRC}_HASH})
      message(FATAL_ERROR "File hash of ${SRC} is different: got ${HASH}, should be ${${SRC}_HASH}")
    endif()
  endforeach()
endfunction()

if("Testing sources formatting" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(
    SRCS
      src/fibonacci.cpp
      src/is_odd.cpp
  )
endif()

if("Testing include directories formatting" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(
    SRCS
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
  )
endif()

if("Testing file set headers formatting" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(
    USE_FILE_SET_HEADERS
    SRCS
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
  )
endif()

if("Testing formatting globally" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(USE_GLOBAL_FORMAT)
endif()

if("Testing formatting a target without build" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(FORMAT_TARGET format-sample)
endif()

if("Testing formatting all targets without build" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(FORMAT_TARGET format-all)
endif()

if("Testing formatting twice" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(FORMAT_TWICE)
endif()

if("Testing formatting globally twice" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(USE_GLOBAL_FORMAT FORMAT_TWICE)
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()

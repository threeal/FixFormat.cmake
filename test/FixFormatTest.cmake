# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

function(check_source_codes_format)
  cmake_parse_arguments(
    ARG
    "USE_GLOBAL_FORMAT;USE_FILE_SET_HEADERS;FORMAT_TWICE"
    ""
    "SRCS;FORMAT_TARGETS"
    ${ARGN}
  )

  # Use the default source files if not specified.
  if(NOT ARG_SRCS)
    set(
      ARG_SRCS
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
      src/fibonacci.cpp
      src/is_odd.cpp
      src/main.cpp
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
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to configure sample project")
  endif()

  if(ARG_FORMAT_TARGETS)
    message(STATUS "Formatting sample project")
    foreach(TARGET ${ARG_FORMAT_TARGETS})
      list(APPEND TARGETS_ARGS --target ${TARGET})
    endforeach()
    execute_process(
      COMMAND ${CMAKE_COMMAND}
        --build ${CMAKE_CURRENT_LIST_DIR}/sample/build
        ${TARGETS_ARGS}
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Failed to format sample project")
    endif()
  else()
    message(STATUS "Building sample project")
    execute_process(
      COMMAND ${CMAKE_COMMAND} --build ${CMAKE_CURRENT_LIST_DIR}/sample/build
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Failed to build sample project")
    endif()
  endif()

  message(STATUS "Comparing the source file hashes")
  foreach(SRC ${ARG_SRCS})
    file(MD5 ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC} HASH)
    if(NOT HASH STREQUAL ${SRC}_HASH)
      message(FATAL_ERROR "File hash of ${SRC} is different: got ${HASH}, should be ${${SRC}_HASH}")
    endif()
  endforeach()
endfunction()

if("Format sources files" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(
    SRCS
      src/fibonacci.cpp
      src/is_odd.cpp
      src/main.cpp
  )
endif()

if("Format include directories" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(
    SRCS
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
  )
endif()

if("Format header files" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(
    USE_FILE_SET_HEADERS
    SRCS
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
  )
endif()

if("Format all files globally" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(USE_GLOBAL_FORMAT)
endif()

if("Format all files of some targets without building" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(FORMAT_TARGETS format-sample format-main)
endif()

if("Format all files of all targets without building" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(FORMAT_TARGETS format-all)
endif()

if("Format all files twice" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(FORMAT_TWICE)
endif()

if("Format all files globally twice" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  check_source_codes_format(USE_GLOBAL_FORMAT FORMAT_TWICE)
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()

# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

if("Testing source codes formatting" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  set(
    SRCS
    include/fibonacci.hpp
    include/is_odd.hpp
    src/fibonacci.cpp
    src/is_odd.cpp
  )

  message(STATUS "Getting the original source file hashes")
  foreach(SRC ${SRCS})
    file(MD5 ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC} ${SRC}_HASH)
  endforeach()

  message(STATUS "Copying the ugly source files")
  foreach(SRC ${SRCS})
    file(
      COPY_FILE
      ${CMAKE_CURRENT_LIST_DIR}/sample/dirty/${SRC}
      ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC}
    )
  endforeach()

  message(STATUS "Configuring sample project")
  execute_process(
    COMMAND ${CMAKE_COMMAND}
      -B ${CMAKE_CURRENT_LIST_DIR}/sample/build
      -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
      --fresh
      ${CMAKE_CURRENT_LIST_DIR}/sample
    ERROR_VARIABLE ERR
    RESULT_VARIABLE RES
  )
  if(NOT ${RES} EQUAL 0)
    message(FATAL_ERROR "Failed to configure sample project: ${ERR}")
  endif()

  message(STATUS "Building sample project")
  execute_process(
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_CURRENT_LIST_DIR}/sample/build
    ERROR_VARIABLE ERR
    RESULT_VARIABLE RES
  )
  if(NOT ${RES} EQUAL 0)
    message(FATAL_ERROR "Failed to build sample project: ${ERR}")
  endif()

  message(STATUS "Comparing the source file hashes")
  foreach(SRC ${SRCS})
    file(MD5 ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC} HASH)
    if(NOT ${HASH} STREQUAL ${${SRC}_HASH})
      message(FATAL_ERROR "File hash of ${SRC} is different: got ${HASH}, should be ${${SRC}_HASH}")
    endif()
  endforeach()
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()

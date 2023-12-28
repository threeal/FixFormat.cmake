set(SRCS src/fibonacci.cpp src/is_odd.cpp)

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

if(EXISTS ${CMAKE_CURRENT_LIST_DIR}/sample/build)
  message(STATUS "Removing build directory")
  file(REMOVE_RECURSE ${CMAKE_CURRENT_LIST_DIR}/sample/build)
endif()

message(STATUS "Configuring sample project")
execute_process(
  COMMAND
    cmake ${CMAKE_CURRENT_LIST_DIR}/sample
      -B ${CMAKE_CURRENT_LIST_DIR}/sample/build
      -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
  RESULT_VARIABLE RES
)
if(NOT ${RES} EQUAL 0)
  message(FATAL_ERROR "Failed to configure sample project")
endif()

message(STATUS "Building sample project")
execute_process(
  COMMAND cmake --build ${CMAKE_CURRENT_LIST_DIR}/sample/build
  RESULT_VARIABLE RES
)
if(NOT ${RES} EQUAL 0)
  message(FATAL_ERROR "Failed to build sample project")
endif()

message(STATUS "Comparing the source file hashes")
foreach(SRC ${SRCS})
  file(MD5 ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC} HASH)
  if(NOT ${HASH} STREQUAL ${${SRC}_HASH})
    message(FATAL_ERROR "File hash of ${SRC} is different: got ${HASH}, should be ${${SRC}_HASH}")
  endif()
endforeach()

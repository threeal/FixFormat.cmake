if(EXISTS ${CMAKE_CURRENT_LIST_DIR}/sample/build)
  message(STATUS "Removing build directory")
  file(REMOVE_RECURSE ${CMAKE_CURRENT_LIST_DIR}/sample/build)
endif()

list(APPEND CONFIGURE_ARGS )
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

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

  message(STATUS "Restoring the source files backup")
  foreach(SRC ${ARG_SRCS})
    set(SRC_PATH ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC})
    set(BACKUP_PATH ${CMAKE_CURRENT_LIST_DIR}/sample/.backup/${SRC})
    if(EXISTS "${BACKUP_PATH}")
      file(COPY_FILE "${BACKUP_PATH}" "${SRC_PATH}")
    else()
      message(STATUS "Backing up the `${SRC}` file instead")
      get_filename_component(BACKUP_DIR "${BACKUP_PATH}" DIRECTORY)
      if(NOT EXISTS "${BACKUP_DIR}")
        file(MAKE_DIRECTORY "${BACKUP_DIR}")
      endif()
      file(COPY_FILE "${SRC_PATH}" "${BACKUP_PATH}")
    endif()
  endforeach()

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
    COMMAND "${CMAKE_COMMAND}"
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
      list(APPEND TARGETS_ARGS --target "${TARGET}")
    endforeach()
    execute_process(
      COMMAND "${CMAKE_COMMAND}"
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
      COMMAND "${CMAKE_COMMAND}" --build ${CMAKE_CURRENT_LIST_DIR}/sample/build
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Failed to build sample project")
    endif()
  endif()

  message(STATUS "Comparing the source file hashes")
  foreach(SRC ${ARG_SRCS})
    file(MD5 ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC} SRC_HASH)
    file(MD5 ${CMAKE_CURRENT_LIST_DIR}/sample/.backup/${SRC} BACKUP_HASH)
    if(NOT SRC_HASH STREQUAL BACKUP_HASH)
      message(FATAL_ERROR "File hash of ${SRC} is different: got ${SRC_HASH}, should be ${BACKUP_HASH}")
    endif()
  endforeach()
endfunction()

function(test_format_sources_files)
  check_source_codes_format(
    SRCS
      src/fibonacci.cpp
      src/is_odd.cpp
      src/main.cpp
  )
endfunction()

function(test_format_include_directories)
  check_source_codes_format(
    SRCS
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
  )
endfunction()

function(test_format_header_files)
  check_source_codes_format(
    USE_FILE_SET_HEADERS
    SRCS
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
  )
endfunction()

function(test_format_all_files_globally)
  check_source_codes_format(USE_GLOBAL_FORMAT)
endfunction()

function(test_format_all_files_of_some_targets_without_building)
  check_source_codes_format(FORMAT_TARGETS format-sample format-main)
endfunction()

function(test_format_all_files_of_all_targets_without_building)
  check_source_codes_format(FORMAT_TARGETS format-all)
endfunction()

function(test_format_all_files_twice)
  check_source_codes_format(FORMAT_TWICE)
endfunction()

function(test_format_all_files_globally_twice)
  check_source_codes_format(USE_GLOBAL_FORMAT FORMAT_TWICE)
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})

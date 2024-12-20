cmake_minimum_required(VERSION 3.21)

include(Assertion)

function(check_source_codes_format)
  set(OPTIONS USE_GLOBAL_FORMAT USE_FILE_SET_HEADERS FORMAT_TWICE)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "${OPTIONS}" "" "SRCS;FORMAT_TARGETS")

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
  assert_execute_process(
    "${CMAKE_COMMAND}"
      -B ${CMAKE_CURRENT_LIST_DIR}/sample/build
      ${CONFIGURE_ARGS}
      --fresh
      ${CMAKE_CURRENT_LIST_DIR}/sample)

  if(ARG_FORMAT_TARGETS)
    message(STATUS "Formatting sample project")
    foreach(TARGET ${ARG_FORMAT_TARGETS})
      list(APPEND TARGETS_ARGS --target "${TARGET}")
    endforeach()
    assert_execute_process(
      "${CMAKE_COMMAND}"
        --build ${CMAKE_CURRENT_LIST_DIR}/sample/build
        ${TARGETS_ARGS})
  else()
    message(STATUS "Building sample project")
    assert_execute_process(
      "${CMAKE_COMMAND}" --build ${CMAKE_CURRENT_LIST_DIR}/sample/build)
  endif()

  message(STATUS "Comparing the source file hashes")
  foreach(SRC ${ARG_SRCS})
    file(MD5 ${CMAKE_CURRENT_LIST_DIR}/sample/${SRC} SRC_HASH)
    file(MD5 ${CMAKE_CURRENT_LIST_DIR}/sample/.backup/${SRC} BACKUP_HASH)
    assert(SRC_HASH STREQUAL BACKUP_HASH)
  endforeach()
endfunction()

section("it should format sources files")
  check_source_codes_format(
    SRCS
      src/fibonacci.cpp
      src/is_odd.cpp
      src/main.cpp
  )
endsection()

section("it should format include directories")
  check_source_codes_format(
    SRCS
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
  )
endsection()

section("it should format header files")
  check_source_codes_format(
    USE_FILE_SET_HEADERS
    SRCS
      include/sample/fibonacci.hpp
      include/sample/is_odd.hpp
      include/sample.hpp
  )
endsection()

section("it should format all files globally")
  check_source_codes_format(USE_GLOBAL_FORMAT)
endsection()

section("it should format all files of some targets without building")
  check_source_codes_format(FORMAT_TARGETS format-sample format-main)
endsection()

section("it should format all files of all targets without building")
  check_source_codes_format(FORMAT_TARGETS format-all)
endsection()

section("it should format all files twice")
  check_source_codes_format(FORMAT_TWICE)
endsection()

section("it should format all files globally twice")
  check_source_codes_format(USE_GLOBAL_FORMAT FORMAT_TWICE)
endsection()

# This code is licensed under the terms of the MIT License.
# Copyright (c) 2023-2024 Alfi Maulana

include_guard(GLOBAL)

# Function to format source files of a specific target.
# Arguments:
#   - TARGET: The target for which to format the source files.
function(target_fix_format TARGET)
  # Skip if the format target is already exists.
  if(TARGET format-${TARGET})
    message(WARNING "A format target for `${TARGET}` target already exists")
    return()
  endif()

  # Skip formatting non-library and non-executable targets.
  get_target_property(TARGET_TYPE ${TARGET} TYPE)
  if(NOT TARGET_TYPE MATCHES "LIBRARY$" AND NOT TARGET_TYPE EQUAL EXECUTABLE)
    message(WARNING "Cannot format `${TARGET}` target of type: ${TARGET_TYPE}")
    return()
  endif()

  find_program(CLANG_FORMAT_PROGRAM clang-format REQUIRED)

  # Append source files of the target to be formatted.
  get_target_property(TARGET_SOURCE_DIR ${TARGET} SOURCE_DIR)
  get_target_property(TARGET_SOURCES ${TARGET} SOURCES)
  if(NOT "${TARGET_SOURCES}" STREQUAL TARGET_SOURCES-NOTFOUND)
    foreach(SOURCE ${TARGET_SOURCES})
      list(APPEND FILES ${TARGET_SOURCE_DIR}/${SOURCE})
    endforeach()
  endif()

  # Append header files from include directories of the target to be formatted.
  get_target_property(TARGET_INCLUDE_DIRS ${TARGET} INCLUDE_DIRECTORIES)
  if(NOT "${TARGET_INCLUDE_DIRS}" STREQUAL TARGET_INCLUDE_DIRS-NOTFOUND)
    foreach(INCLUDE_DIR ${TARGET_INCLUDE_DIRS})
      file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS "${INCLUDE_DIR}/*")
      list(APPEND FILES ${HEADERS})
    endforeach()
  endif()

  # Append header files from file set of the target to be formatted.
  get_target_property(TARGET_HEADER_SET ${TARGET} HEADER_SET)
  if(NOT "${TARGET_HEADER_SET}" STREQUAL TARGET_HEADER_SET-NOTFOUND)
    list(APPEND FILES ${TARGET_HEADER_SET})
  endif()

  if(FILES)
    # Set a lock file to prevent formatting from always running.
    get_target_property(TARGET_BINARY_DIR ${TARGET} BINARY_DIR)
    set(TARGET_LOCK ${TARGET_BINARY_DIR}/format-${TARGET}.lock)

    # Add a custom target for formatting source files of the target.
    add_custom_command(
      OUTPUT ${TARGET_LOCK}
      COMMAND ${CLANG_FORMAT_PROGRAM} -i ${FILES}
      COMMAND ${CMAKE_COMMAND} -E touch ${TARGET_LOCK}
      DEPENDS ${FILES}
      VERBATIM
    )
    add_custom_target(format-${TARGET} DEPENDS ${TARGET_LOCK})

    # Mark the target to depend on the format target.
    add_dependencies(${TARGET} format-${TARGET})

    # Mark the format all target to depend on the format target.
    if(NOT TARGET format-all)
      add_custom_target(format-all)
    endif()
    add_dependencies(format-all format-${TARGET})
  else()
    message(WARNING "Target `${TARGET}` does not have any source files")
  endif()
endfunction()

# Function to format source files of all targets in the directory.
function(add_fix_format)
  get_directory_property(TARGETS BUILDSYSTEM_TARGETS)
  foreach(TARGET ${TARGETS})
    target_fix_format(${TARGET})
  endforeach()
endfunction()

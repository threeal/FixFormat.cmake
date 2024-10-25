# MIT License
#
# Copyright (c) 2023-2024 Alfi Maulana
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
  get_target_property(TARGET_TYPE "${TARGET}" TYPE)
  if(NOT TARGET_TYPE MATCHES LIBRARY$ AND NOT TARGET_TYPE STREQUAL EXECUTABLE)
    message(WARNING "Cannot format `${TARGET}` target of type: ${TARGET_TYPE}")
    return()
  endif()

  find_program(CLANG_FORMAT_PROGRAM clang-format)
  if(CLANG_FORMAT_PROGRAM STREQUAL CLANG_FORMAT_PROGRAM-NOTFOUND)
    message(WARNING "Cannot find the `clang-format` program required for formatting the `${TARGET}` target")
    return()
  endif()

  # Append source files of the target to be formatted.
  get_target_property(TARGET_SOURCE_DIR "${TARGET}" SOURCE_DIR)
  get_target_property(TARGET_SOURCES "${TARGET}" SOURCES)
  if(NOT TARGET_SOURCES STREQUAL TARGET_SOURCES-NOTFOUND)
    foreach(SOURCE ${TARGET_SOURCES})
      list(APPEND FILES ${TARGET_SOURCE_DIR}/${SOURCE})
    endforeach()
  endif()

  # Append header files from include directories of the target to be formatted.
  get_target_property(TARGET_INCLUDE_DIRS "${TARGET}" INCLUDE_DIRECTORIES)
  if(NOT TARGET_INCLUDE_DIRS STREQUAL TARGET_INCLUDE_DIRS-NOTFOUND)
    foreach(INCLUDE_DIR ${TARGET_INCLUDE_DIRS})
      file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS "${INCLUDE_DIR}/*")
      list(APPEND FILES ${HEADERS})
    endforeach()
  endif()

  # Append header files from file set of the target to be formatted.
  get_target_property(TARGET_HEADER_SET "${TARGET}" HEADER_SET)
  if(NOT TARGET_HEADER_SET STREQUAL TARGET_HEADER_SET-NOTFOUND)
    list(APPEND FILES ${TARGET_HEADER_SET})
  endif()

  if(NOT FILES)
    message(WARNING "Target `${TARGET}` does not have any source files")
    return()
  endif()

  # Set a lock file to prevent formatting from always running.
  get_target_property(TARGET_BINARY_DIR "${TARGET}" BINARY_DIR)
  set(TARGET_LOCK ${TARGET_BINARY_DIR}/format-${TARGET}.lock)

  # Add a custom target for formatting source files of the target.
  add_custom_command(
    OUTPUT "${TARGET_LOCK}"
    COMMAND "${CLANG_FORMAT_PROGRAM}" -i ${FILES}
    COMMAND "${CMAKE_COMMAND}" -E touch "${TARGET_LOCK}"
    DEPENDS ${FILES}
    VERBATIM)
  add_custom_target(format-${TARGET} DEPENDS "${TARGET_LOCK}")

  # Mark the target to depend on the format target.
  add_dependencies("${TARGET}" format-${TARGET})

  # Mark the format all target to depend on the format target.
  if(NOT TARGET format-all)
    add_custom_target(format-all)
  endif()
  add_dependencies(format-all format-${TARGET})
endfunction()

# Function to format source files of all targets in the directory.
function(add_fix_format)
  get_directory_property(TARGETS BUILDSYSTEM_TARGETS)
  foreach(TARGET ${TARGETS})
    # Skip if the format target is already exists.
    if(TARGET format-${TARGET})
      return()
    endif()

    # Skip formatting non-library and non-executable targets.
    get_target_property(TARGET_TYPE "${TARGET}" TYPE)
    if(NOT TARGET_TYPE MATCHES LIBRARY$ AND NOT TARGET_TYPE STREQUAL EXECUTABLE)
      continue()
    endif()

    target_fix_format("${TARGET}")
  endforeach()
endfunction()

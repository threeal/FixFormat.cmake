# Function to format source files of a specific target.
# Arguments:
#   - TARGET: The target for which to format the source files.
function(target_fix_format TARGET)
  find_program(CLANG_FORMAT_PROGRAM clang-format REQUIRED)

  # Append source files of the target to be formatted.
  get_target_property(TARGET_SOURCE_DIR ${TARGET} SOURCE_DIR)
  get_target_property(TARGET_SOURCES ${TARGET} SOURCES)
  if(NOT "${TARGET_SOURCES}" STREQUAL TARGET_SOURCES-NOTFOUND)
    foreach(SOURCE ${TARGET_SOURCES})
      list(APPEND FILES ${TARGET_SOURCE_DIR}/${SOURCE})
    endforeach()
  endif()

  # Append header files of the target to be formatted.
  foreach(PROP INCLUDE_DIRECTORIES INTERFACE_INCLUDE_DIRECTORIES)
    get_target_property(TARGET_INCLUDE_DIRS ${TARGET} ${PROP})
    if(NOT "${TARGET_INCLUDE_DIRS}" STREQUAL TARGET_INCLUDE_DIRS-NOTFOUND)
      foreach(INCLUDE_DIR ${TARGET_INCLUDE_DIRS})
        file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS "${INCLUDE_DIR}/*")
        list(APPEND FILES ${HEADERS})
      endforeach()
    endif()
  endforeach()

  if(FILES)
    # Set a lock file to prevent formatting from always running.
    get_target_property(TARGET_BINARY_DIR ${TARGET} BINARY_DIR)
    set(TARGET_LOCK ${TARGET_BINARY_DIR}/${TARGET}_format.lock)

    # Add a custom target for formatting source files of the target.
    add_custom_command(
      OUTPUT ${TARGET_LOCK}
      COMMAND ${CLANG_FORMAT_PROGRAM} -i ${FILES}
      COMMAND ${CMAKE_COMMAND} -E touch ${TARGET_LOCK}
      DEPENDS ${FILES}
      VERBATIM
    )
    add_custom_target(${TARGET}_format DEPENDS ${TARGET_LOCK})

    # Mark the target to depend on the format target.
    add_dependencies(${TARGET} ${TARGET}_format)
  else()
    message(WARNING "Target `${TARGET}` does not have any source files")
  endif()
endfunction()

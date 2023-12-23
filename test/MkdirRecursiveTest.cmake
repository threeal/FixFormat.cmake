if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/parent)
  file(REMOVE_RECURSE ${CMAKE_CURRENT_BINARY_DIR}/parent)
endif()

include(MkdirRecursive)
mkdir_recursive(${CMAKE_CURRENT_BINARY_DIR}/parent/child)

if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/parent/child)
  file(REMOVE_RECURSE ${CMAKE_CURRENT_BINARY_DIR}/parent)
else()
  message(FATAL_ERROR "Directory `${CMAKE_CURRENT_BINARY_DIR}/parent/child` should exist!")
endif()

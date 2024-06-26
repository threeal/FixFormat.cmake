cmake_minimum_required(VERSION 3.21)

project(
  FixFormat
  VERSION 1.1.0
  DESCRIPTION "Fix source codes formatting in your CMake project"
  HOMEPAGE_URL https://github.com/threeal/FixFormat.cmake
  LANGUAGES NONE
)

include(cmake/FixFormat.cmake)

if(PROJECT_IS_TOP_LEVEL)
  if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(test)
  endif()

  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(
    FixFormatConfigVersion.cmake
    COMPATIBILITY SameMinorVersion
  )

  install(
    FILES
      cmake/FixFormat.cmake
      cmake/FixFormatConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/FixFormatConfigVersion.cmake
    DESTINATION lib/cmake/FixFormat
  )
endif()

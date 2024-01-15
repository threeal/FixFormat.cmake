# FixFormat.cmake

[![version](https://img.shields.io/github/v/release/threeal/FixFormat.cmake?style=flat-square)](https://github.com/threeal/FixFormat.cmake/releases)
[![license](https://img.shields.io/github/license/threeal/FixFormat.cmake?style=flat-square)](./LICENSE)
[![build status](https://img.shields.io/github/actions/workflow/status/threeal/FixFormat.cmake/build.yaml?branch=main&style=flat-square)](https://github.com/threeal/FixFormat.cmake/actions/workflows/build.yaml)
[![test status](https://img.shields.io/github/actions/workflow/status/threeal/FixFormat.cmake/test.yaml?branch=main&label=test&style=flat-square)](https://github.com/threeal/FixFormat.cmake/actions/workflows/test.yaml)

FixFormat.cmake is a [CMake](https://cmake.org/) module that provides utility functions for fixing source codes formatting during your project's build process.
This module mainly contains a `target_fix_format` function for fixing the source codes formatting required by the target before the compilation step.

## Integration

### Including the Script File

You can integrate this module into your project by including the [FixFormat.cmake](./cmake/FixFormat.cmake) file in your project.

```cmake
include(FixFormat)
```

### Using CPM.cmake

Alternatively, you can use [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake) to seamlessly integrate this module into your project.

```cmake
cpmaddpackage(gh:threeal/FixFormat.cmake@1.0.0)
include(FixFormat)
```

## Usage

### Fixing Formatting on a Target

To fix the source codes formatting required by a target, use the `target_fix_format` function. This function will automatically fix the formatting right before the compilation step of the target.

```cmake
add_executable(main main.cpp)
target_include_directories(main PRIVATE include)

target_fix_format(main)
```

## License

This project is licensed under the terms of the [MIT License](./LICENSE).

Copyright © 2023-2024 [Alfi Maulana](https://github.com/threeal)

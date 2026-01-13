# FixFormat.cmake

**FixFormat.cmake** is a [CMake](https://cmake.org/) module that provides utility functions for fixing source code formatting during your project's build process.
This module primarily includes `target_fix_format` and `add_fix_format` functions designed to fix the source code formatting required by the target before the compilation step.

Behind the scenes, this module utilizes [ClangFormat](https://clang.llvm.org/docs/ClangFormat.html) to format the source codes.
To enable the formatting to be fixed before the compilation step, the module searches through all source files used by the target and creates a format target that the main target later depends on.

## Requirements

- CMake version 3.21 or above.
- ClangFormat.

## Integration

### Including the Script File

You can integrate this module into your project by including the [FixFormat.cmake](./cmake/FixFormat.cmake) file in your project.

```cmake
include(FixFormat)
```

### Using CPM.cmake

Alternatively, you can use [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake) to seamlessly integrate this module into your project.

```cmake
cpmaddpackage(gh:threeal/FixFormat.cmake@1.2.0)
```

## Usage

### Fixing Formatting on a Target

To fix the source codes formatting required by a target, use the `target_fix_format` function. This function will automatically fix the formatting right before the compilation step of the target.

```cmake
add_library(foo foo.cpp)
target_fix_format(foo)

add_executable(main main.cpp)
target_fix_format(main)
```

Instead of calling the `target_fix_format` function individually for each target, you can also call the `add_fix_format` function after declaring all targets in the directory to enable formatting for those targets.

```cmake
add_library(foo foo.cpp)
add_executable(main main.cpp)

add_fix_format()
```

### Fixing Formatting Without Building Targets

To fix the formatting of a target directly without building it, call a target named `format-` followed by the target name.
For example, the following command will fix the formatting of the `main` target:

```bash
cmake --build build --target format-main
```

Alternatively, you can also use the `format-all` target to fix the formatting of all targets without building them.

```bash
cmake --build build --target format-all
```

### Configuring the Formatting Style

Similar to ClangFormat, you can configure the formatting style by including a `.clang-format` file.
Refer to [this documentation](https://clang.llvm.org/docs/ClangFormatStyleOptions.html) for more information on configuring the formatting style.

## License

This project is licensed under the terms of the [MIT License](./LICENSE).

Copyright © 2023-2026 [Alfi Maulana](https://github.com/threeal)

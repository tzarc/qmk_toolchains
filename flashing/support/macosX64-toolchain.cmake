# the name of the target operating system
set(CMAKE_SYSTEM_NAME Darwin)

# which compilers to use for C and C++
set(CMAKE_C_COMPILER   x86_64-apple-darwin24-gcc)
set(CMAKE_CXX_COMPILER x86_64-apple-darwin24-g++)

# Ensure sysroot can be properly specified during compilation
set(CMAKE_C_COMPILE_OPTIONS_SYSROOT "--sysroot=")
set(CMAKE_CXX_COMPILE_OPTIONS_SYSROOT "--sysroot=")

# adjust the default behavior of the FIND_XXX() commands:
# search programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# search headers and libraries in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
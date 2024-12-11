cmake_minimum_required(VERSION 3.15)
project(MyC++Project VERSION 1.0)

# Set C++ Standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add source files
add_executable(${PROJECT_NAME} 
    src/main.cpp 
    src/utils.cpp
)

# Enable Testing
enable_testing()
add_subdirectory(tests)

# Compiler Warnings
if(MSVC)
    add_compile_options(/W4)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Dependency Management with Conan
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

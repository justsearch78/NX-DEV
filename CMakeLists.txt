cmake_minimum_required(VERSION 3.10)
project(HelloWorld)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add executable
add_executable(hello_world main.cpp)

# Optional: Find and link packages using vcpkg
# find_package(fmt CONFIG REQUIRED)
# target_link_libraries(hello_world PRIVATE fmt::fmt)

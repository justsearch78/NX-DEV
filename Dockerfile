# Use vcpkg base image
FROM acgetchell/vcpkg-image:latest

# Set working directory
WORKDIR /app

# Install necessary build tools
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . /app

# Optional: Install project dependencies using vcpkg
# Uncomment and modify as needed
# COPY vcpkg.json vcpkg.json
# RUN vcpkg install $(cat vcpkg.json | jq -r '.dependencies[]')

# Compile the application
RUN mkdir -p build \
    && cd build \
    && cmake .. \
    && make

# Optional: Add a simple CMakeLists.txt if not already present
RUN if [ ! -f CMakeLists.txt ]; then \
    echo "cmake_minimum_required(VERSION 3.10)" > CMakeLists.txt && \
    echo "project(HelloWorld)" >> CMakeLists.txt && \
    echo "add_executable(hello_world main.cpp)" >> CMakeLists.txt; \
    fi

# Set the default command to run the application
CMD ["./build/hello_world"]

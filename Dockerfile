# Multi-stage build for C++
FROM ubuntu:22.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3-pip \
    wget

# Install Conan
RUN pip3 install conan

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN conan profile detect
RUN conan install . --output-folder=build --build=missing

# Build the project
RUN cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
RUN cmake --build build --config Release

# Final stage
FROM ubuntu:22.04

# Copy compiled binary
COPY --from=builder /app/build/bin/MyC++Project /usr/local/bin/

# Run the application
CMD ["MyC++Project"]

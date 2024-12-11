FROM gcc:latest
WORKDIR /app
COPY . /app
RUN mkdir build \
    && cd build \
    && cmake .. \
    && cmake --build .
CMD ["./build/hello_world"]

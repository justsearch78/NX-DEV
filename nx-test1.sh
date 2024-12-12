#!/bin/bash

########################################################
# Shell Script to Build Docker Image and Run Container #
########################################################

DATE=$(date +%Y.%m.%d.%H.%M)
USERNAME="justsearch78"
PASSWORD="Qtx@12345$#2"
DIR="/root/nx-dev"
CONTAINER_NAME="nx_dev_container"
IMAGE_NAME="nx_dev_image"

echo "Build Process Started at $DATE"

# Ensure the directory exists
if [ ! -d "$DIR" ]; then
    echo "Directory does not exist. Creating: $DIR"
    mkdir -p "$DIR"
else
    echo "Directory already exists: $DIR"
fi

# Remove any existing files in the directory
echo "Cleaning directory: $DIR"
rm -rf "$DIR"/*

# Clone the repository
echo "Cloning repository into $DIR"
if git clone https://$USERNAME:$PASSWORD@github.com/justsearch78/NX-DEV.git "$DIR"; then
    echo "Repository cloned successfully"
else
    echo "Failed to clone repository"
    exit 1
fi

# Navigate to the directory
cd "$DIR" || { echo "Failed to navigate to $DIR"; exit 1; }
echo "Current working directory: ${PWD}"

# Remove existing container if it exists
if docker ps -aq -f name="$CONTAINER_NAME" > /dev/null; then
    echo "Removing existing container: $CONTAINER_NAME"
    docker rm "$CONTAINER_NAME" -f
else
    echo "No existing container found: $CONTAINER_NAME"
fi

# Remove existing image if it exists
IMAGE_ID=$(docker images -q "$IMAGE_NAME")
if [ -n "$IMAGE_ID" ]; then
    echo "Removing existing image: $IMAGE_NAME"
    docker rmi -f "$IMAGE_ID"
else
    echo "No existing image found: $IMAGE_NAME"
fi

# Build the Docker image
echo "Building Docker image: $IMAGE_NAME"
if docker build -t "$IMAGE_NAME" -f Dockerfile .; then
    echo "Docker image created successfully"
else
    echo "Docker image build failed"
    exit 1
fi

# Run the Docker container
echo "Creating and starting Docker container: $CONTAINER_NAME"
if docker run --name="$CONTAINER_NAME" -itd -p 34076:34076 "$IMAGE_NAME"; then
    echo "Docker container created and started successfully"
else
    echo "Failed to start Docker container"
    exit 1
fi

echo "Build Process Completed at $DATE"


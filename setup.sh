#!/bin/bash

# Setup Script for Multiple Node

# Step 1: Check for prerequisites
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: ./setup.sh <UNIQUE_IDENTIFIER> <PIN_CODE>"
    exit 1
fi

UNIQUE_IDENTIFIER=$1
PIN_CODE=$2

# Step 2: Check Linux version and architecture
ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

# Step 3: Download the appropriate client
if [ "$ARCH" == "x86_64" ]; then
    echo "Downloading client for x64 architecture..."
    wget https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar
elif [ "$ARCH" == "aarch64" ]; then
    echo "Downloading client for ARM64 architecture..."
    wget https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Step 4: Extract the installation package
echo "Extracting the installation package..."
tar -xvf multipleforlinux.tar

# Step 5: Grant permissions
echo "Granting execute permissions..."
chmod +x ./multiple-cli
chmod +x ./multiple-node

# Step 6: Configure environment variables
EXTRACTED_DIR=$(pwd)
PATH=$PATH:$EXTRACTED_DIR
export PATH
source /etc/profile

echo "Environment variables configured."

# Step 7: Grant permissions for the directory
echo "Granting permissions to the extracted directory..."
chmod -R 777 $EXTRACTED_DIR

# Step 8: Start the program
echo "Starting the multiple-node program..."
nohup ./multiple-node > output.log 2>&1 &

echo "Program started. Logs are being written to output.log."

# Step 9: Bind the unique account identifier
echo "Binding the unique account identifier..."
./multiple-cli bind \
    --bandwidth-download 10000 \
    --identifier $UNIQUE_IDENTIFIER \
    --pin $PIN_CODE \
    --storage 20000000 \
    --bandwidth-upload 10000

if [ $? -eq 0 ]; then
    echo "Binding successful! Setup complete."
else
    echo "Binding failed. Please check your input and try again."
    exit 1
fi

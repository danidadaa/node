#!/bin/bash

# Menampilkan header
echo "======================================"
echo "  Multiple.cc Network Node Installer"
echo "             By Kiui"
echo "======================================"
sleep 2

echo "Starting system update..."
sudo apt update && sudo apt upgrade -y

echo "Checking system architecture..."
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
elif [[ "$ARCH" == "aarch64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar"
else
    echo "Unsupported system architecture: $ARCH"
    exit 1
fi

echo "Downloading the client from $CLIENT_URL..."
wget $CLIENT_URL -O multipleforlinux.tar

echo "Extracting files..."
tar -xvf multipleforlinux.tar

cd multipleforlinux

echo "Granting permissions..."
chmod +x ./multiple-cli
chmod +x ./multiple-node

echo "Adding directory to system PATH..."
echo "PATH=\$PATH:$(pwd)" >> ~/.bash_profile
source ~/.bash_profile

echo "Setting permissions..."
chmod -R 777 $(pwd)

echo "Launching multiple-node..."
nohup ./multiple-node > output.log 2>&1 &

echo "Please enter your Account ID and PIN to bind your account:"
read -p "Account ID: " IDENTIFIER
read -p "Set your PIN: " PIN

echo "Binding account with ID: $IDENTIFIER and PIN: $PIN..."
./multiple-cli bind --bandwidth-download 5000 --identifier $IDENTIFIER --pin $PIN --storage 2000000 --bandwidth-upload 5000

if [ $? -eq 0 ]; then
    echo "Binding successful! Setup complete."
else
    echo "Binding failed. Please check your input and try again."
    exit 1
fi

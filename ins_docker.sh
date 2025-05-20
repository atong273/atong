#!/bin/bash

set -e

echo "Updating apt and installing dependencies..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

echo "Creating keyrings directory..."
sudo install -m 0755 -d /etc/apt/keyrings

echo "Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Ensure the sources.list.d directory exists
if [ ! -d /etc/apt/sources.list.d ]; then
    echo "Creating /etc/apt/sources.list.d directory..."
    sudo mkdir -p /etc/apt/sources.list.d
    sudo chmod 755 /etc/apt/sources.list.d
fi

echo "Adding Docker repository to APT sources..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating apt package list..."
sudo apt-get update

echo "Installing Docker ...."

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

echo "Done!"

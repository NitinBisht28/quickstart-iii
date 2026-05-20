#!/bin/bash

set -e

echo "Updating packages..."
sudo apt update

echo "Installing required packages..."
sudo apt install -y curl git unzip

echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

sudo apt install -y nodejs

echo "Installing iii CLI..."
curl -fsSL https://install.iii.dev/iii/main/install.sh | sh

export PATH="$HOME/.local/bin:$PATH"

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

source ~/.bashrc

echo "Checking iii installation..."
iii --version

echo "Installing caller-worker dependencies..."
cd ~/quickstart-iii/quickstart/workers/caller-worker

npm install

echo "Caller worker setup completed successfully."
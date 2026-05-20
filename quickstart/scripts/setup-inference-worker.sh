#!/bin/bash

set -e

echo "Updating packages..."
sudo apt update

echo "Installing Python dependencies..."
sudo apt install -y python3 python3-venv python3-pip curl git

echo "Installing iii CLI..."
curl -fsSL https://install.iii.dev/iii/main/install.sh | sh

export PATH="$HOME/.local/bin:$PATH"

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

source ~/.bashrc

echo "Checking iii installation..."
iii --version

echo "Creating Python virtual environment..."

cd ~/quickstart-iii/quickstart/workers/inference-worker

python3 -m venv .venv

source .venv/bin/activate

echo "Installing Python packages..."

pip install --upgrade pip

pip install -r requirements.txt

echo "Inference worker setup completed successfully."
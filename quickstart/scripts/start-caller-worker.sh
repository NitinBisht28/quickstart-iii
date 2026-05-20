#!/bin/bash

set -e

export PATH="$HOME/.local/bin:$PATH"

cd ~/quickstart-iii/quickstart

echo "Starting iii engine..."

iii --config configs/caller-config.yaml &

sleep 5

echo "Starting caller-worker..."

cd ~/quickstart-iii/quickstart/workers/caller-worker

npm run dev
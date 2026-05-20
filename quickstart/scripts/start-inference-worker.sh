#!/bin/bash

set -e

export PATH="$HOME/.local/bin:$PATH"

export III_URL=ws://10.0.2.251:49134

cd ~/quickstart-iii/quickstart/workers/inference-worker

source .venv/bin/activate

python3 inference_worker.py
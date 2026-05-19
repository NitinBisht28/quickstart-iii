#!/bin/bash

cd ~/quickstart/workers/inference-worker

source venv/bin/activate

export III_URL=ws://10.0.2.116:49134 # i have used ny caller ip here , replace with ur own

python inference_worker.py
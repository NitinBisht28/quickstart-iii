#!/bin/bash

cd ~/quickstart

iii --config configs/caller-config.yaml &

sleep 5

cd workers/caller-worker

export III_URL=ws://localhost:49134

npm run dev
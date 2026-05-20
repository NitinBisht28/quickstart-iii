#!/bin/bash

set -e

sudo apt update

sudo apt install -y curl git

curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

sudo apt install -y nodejs

cd ~/quickstart-iii/quickstart/workers/caller-worker

npm install
# Quickstart Runtime Deployment

This directory contains the runtime configuration, deployment scripts, and worker implementations used for the distributed inference deployment.

---

# Directory Structure

```text id="h2f7qp"
quickstart/
├── configs/
├── scripts/
├── workers/
├── iii.lock
└── README.md
```

---

# Components

## configs/

Contains deployment-specific iii configuration files.

### caller-config.yaml

Used on the API/caller-worker VM.

Includes:

* iii-http
* caller-worker

### inference-config.yaml

Used on the inference-worker VM.

Includes:

* inference-worker

---

# scripts/

Contains setup and startup scripts for each VM role.

## setup-caller-worker.sh

Installs Node.js dependencies required by the caller worker.

### Usage

```bash id="x9m2vr"
chmod +x scripts/*.sh

./scripts/setup-caller-worker.sh
```

---

## start-caller-worker.sh

Starts:

* iii engine
* iii-http
* caller-worker

### Usage

```bash id="q5t1wx"
./scripts/start-caller-worker.sh
```

---

## setup-inference-worker.sh

Creates Python virtual environment and installs dependencies.

### Usage

```bash id="r8k3qn"
./scripts/setup-inference-worker.sh
```

---

## start-inference-worker.sh

Starts the Python inference worker and connects it to the caller-worker VM over RPC.

### Usage

```bash id="w6p2vr"
./scripts/start-inference-worker.sh
```

---

# Worker Layout

```text id="m3q7yx"
workers/
├── caller-worker/
└── inference-worker/
```

---

# caller-worker

TypeScript worker responsible for:

* accepting HTTP requests
* dispatching RPC calls
* returning JSON responses

### Main Entry

```text id="z2n8qp"
workers/caller-worker/src/worker.ts
```

---

# inference-worker

Python worker responsible for:

* loading the GGUF model
* running inference
* returning generated responses

### Main Entry

```text id="u5f1wr"
workers/inference-worker/inference_worker.py
```

---

# Environment Variables

## III_URL

Used by remote workers to connect to the iii engine.

Example:

```bash id="j7x4mn"
export III_URL=ws://<caller-worker-private-ip>:49134
```

---

# Full Deployment Steps

## 1. Clone Repository

On both VMs:

```bash id="b1q7vr"
git clone <your-repository-url>

cd alchemyst-assignment/quickstart
```

---

# 2. API / caller-worker VM Setup

Run setup script:

```bash id="n8w2qp"
./scripts/setup-caller-worker.sh
```

Start API VM services:

```bash id="s4m9tx"
./scripts/start-caller-worker.sh
```

This starts:

* iii engine
* iii-http
* caller-worker

The API endpoint becomes available on:

```text id="f2x7vr"
http://<public-ip>:3111/v1/chat/completions
```

---

# 3. inference-worker VM Setup

Run setup script:

```bash id="g6r1wp"
./scripts/setup-inference-worker.sh
```

Before starting the worker, update the private RPC address:

```bash id="k3p8vn"
export III_URL=ws://<caller-worker-private-ip>:49134
```

Start inference worker:

```bash id="t5w2yx"
./scripts/start-inference-worker.sh
```

---

# 4. Test the API

From the API VM:

```bash id="v9m4qp"
curl -X POST http://localhost:3111/v1/chat/completions \
-H "Content-Type: application/json" \
-d '{"messages":[{"role":"user","content":"hello"}]}'
```

Or externally:

```bash id="d2r7wx"
curl -X POST http://<public-ip>:3111/v1/chat/completions \
-H "Content-Type: application/json" \
-d '{"messages":[{"role":"user","content":"hello"}]}'
```

---

# Example Response

```json id="c8q1vr"
{
  "result": {
    "success": "You've connected two workers and they're interoperating seamlessly."
  }
}
```

---

# Deployment Notes

The deployment was executed across multiple AWS EC2 instances inside a private subnet.

* The API/caller-worker VM exposes the HTTP endpoint.
* The inference-worker VM remains private.
* Workers communicate internally over WebSocket RPC.

---

# Runtime Flow

1. Start caller-worker VM services
2. Start inference-worker
3. Send HTTP request to `/v1/chat/completions`
4. caller-worker dispatches RPC call
5. inference-worker performs model inference
6. JSON response returned to client

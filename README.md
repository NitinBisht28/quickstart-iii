# Distributed Inferencing Prototype on AWS

## Project Overview

This project demonstrates a distributed inference architecture deployed on AWS using multiple virtual machines inside a secure VPC.

The application exposes a JSON HTTP API that forwards requests through a TypeScript-based caller worker to a Python inference worker over RPC communication inside a private subnet.

The inference worker runs the `gemma-3-270m` GGUF model and returns generated responses back through the distributed worker mesh.

---

# Architecture

```text
                Internet
                    |
         +----------------------+
         |   API Gateway VM     |
         |  Public Subnet       |
         +----------------------+
                    |
                    v
         +----------------------+
         |  caller-worker VM    |
         |  iii-http :3111      |
         |  TypeScript Worker   |
         +----------------------+
                    |
          RPC over private subnet
                    |
                    v
         +----------------------+
         | inference-worker VM  |
         | Python + Gemma GGUF  |
         +----------------------+
```

---

# AWS Infrastructure

## Networking

The infrastructure was deployed using a custom AWS VPC.

### Components

* Custom VPC: `devops-assignment-vpc`
* Public Subnet: `assignment-public-subnet`
* Private Subnet: `assignment-private-subnet`
* Internet Gateway: `assignment-igw`
* NAT Gateway: `assignment-nat-gateway`

### Deployment Layout

| Resource            | Subnet         |
| ------------------- | -------------- |
| API Gateway VM      | Public Subnet  |
| caller-worker VM    | Private Subnet |
| inference-worker VM | Private Subnet |

---

# Security Design

* Only the API Gateway VM is publicly reachable
* Worker VMs are deployed in a private subnet
* RPC communication happens only inside the VPC
* Security Groups restrict unnecessary external access
* Private workers communicate internally over WebSocket RPC

---

# Worker Responsibilities

| Worker           | Language   | Responsibility                               |
| ---------------- | ---------- | -------------------------------------------- |
| caller-worker    | TypeScript | Accepts HTTP requests and forwards RPC calls |
| inference-worker | Python     | Loads GGUF model and performs inference      |

---

# Request Flow

1. Client sends HTTP request to `/v1/chat/completions`
2. `caller-worker` receives the request
3. `caller-worker` triggers RPC call to `inference::run_inference`
4. `inference-worker` performs model inference
5. Response is returned as JSON through the caller worker

---

# API Usage

## Example Request

```bash
curl -X POST http://<PUBLIC-IP>:3111/v1/chat/completions \
-H "Content-Type: application/json" \
-d '{"messages":[{"role":"user","content":"hello"}]}'
```

## Example Response

```json
{
  "result": {
    "response": "Hello! How can I help you today?"
  }
}
```

---

# Infrastructure as Code

Terraform configuration is included inside:

```text
iac-terraform/
```

The Terraform setup provisions:

* VPC
* Public and Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Groups
* EC2 Instances

---

# Repository Structure

```text
.
├── README.md
├── images/
├── iac-terraform/
└── quickstart/
```

---

# Deployment Steps

## 1. Provision Infrastructure

Inside the Terraform directory:

```bash
terraform init
terraform validate
terraform plan
```

## 2. Deploy caller-worker VM

Install:

* Node.js
* iii runtime
* npm dependencies

Start:

* iii engine
* caller-worker
* iii-http

## 3. Deploy inference-worker VM

Install:

* Python
* transformers
* torch
* iii-sdk

Run:

* inference_worker.py

## 4. Connect Workers

Workers communicate internally using:

```text
ws://<caller-worker-private-ip>:49134
```

---

# Screenshots

## VPC Resource Map

![VPC Resource Map](images/vpc-map.png)

---

## EC2 Instances

![EC2 Instances](images/ec2-instances.png)

---

## Successful API Response

![Successful Curl Response](images/curl-success.png)

---

## inference-worker Running

![Inference Worker Running](images/inference-worker-running.png)

---

## Terraform Validate

![Terraform Validate](images/terraform-validate.png)

---

## Terraform Plan

![Terraform Plan](images/terraform-plan.png)

---

# Challenges Faced

During deployment several issues were encountered and resolved:

* Nested KVM virtualization limitations on AWS EC2
* Worker registration mismatches caused by stale worker naming
* RPC registration and distributed communication debugging
* Python dependency and virtual environment setup
* Distributed worker communication across private subnet

---

# Future Improvements

If this project were extended further, the following improvements would be added:

* HTTPS/TLS support
* Kubernetes orchestration
* Auto-scaling inference workers
* CI/CD pipeline automation
* Centralized logging and monitoring
* Authentication and API rate limiting
* GPU-based inference instances for larger models

---

# Scaling Considerations

If the model size increased significantly:

* GPU instances would be required
* Model sharding or quantization would be needed
* Kubernetes/EKS orchestration would help scale inference workers
* Dedicated model serving infrastructure would likely be introduced

---

# Technologies Used

* AWS EC2
* AWS VPC
* NAT Gateway
* Terraform
* TypeScript
* Python
* iii framework
* Transformers
* GGUF model format
* Linux

---

# Conclusion

This project demonstrates a distributed inference architecture where API handling and model inference are separated across different virtual machines inside a secure AWS network.

The final deployment successfully exposes a working JSON API that communicates with a remote inference worker over RPC inside a private subnet.

# Terraform GCP Reusable Modules

Central repository for reusable Google Cloud Platform Terraform modules.

## Available Modules

| Module | Source Path | Description |
| :--- | :--- | :--- |
| **APIs** | `git::https://github.com/tribagus6/tf-gcp-module.git//modules/apis` | Enables GCP services on projects. |
| **Backend** | `git::https://github.com/tribagus6/tf-gcp-module.git//modules/backend` | Provisions versioned GCS buckets for Terraform state storage. |
| **Compute Engine** | `git::https://github.com/tribagus6/tf-gcp-module.git//modules/compute-engine` | Provisions Compute Engine VM instances (Spot/Standard, custom sizing). |
| **Firewall** | `git::https://github.com/tribagus6/tf-gcp-module.git//modules/firewall` | Manages VPC ingress and egress firewall rules. |
| **GKE Standard** | `git::https://github.com/tribagus6/tf-gcp-module.git//modules/gke` | Provisions Private GKE Standard clusters with custom node pools & Gateway API. |
| **Network** | `git::https://github.com/tribagus6/tf-gcp-module.git//modules/network` | Provisions Custom VPCs, Subnets with secondary IP ranges, Cloud Router, and Cloud NAT. |

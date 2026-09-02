variable "project_id" {
  description = "The GCP project ID where the GKE cluster will be created"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "location" {
  description = "The region or zone for the GKE cluster"
  type        = string
}

variable "network" {
  description = "The VPC network self link or name"
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The subnetwork self link or name"
  type        = string
}

variable "pod_secondary_range_name" {
  description = "The secondary IP range name for pods"
  type        = string
  default     = "gke-pod-ip-dev"
}

variable "service_secondary_range_name" {
  description = "The secondary IP range name for services"
  type        = string
  default     = "gke-svc-ip-dev"
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the GKE master network"
  type        = string
  default     = "172.16.0.0/28"
}

variable "enable_private_nodes" {
  description = "Whether nodes have internal IP addresses only"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Whether the master's internal IP address is used as the cluster endpoint"
  type        = bool
  default     = false
}

variable "master_authorized_networks_config" {
  description = "List of master authorized networks CIDR blocks"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "gateway_api_channel" {
  description = "Gateway API channel (CHANNEL_STANDARD, CHANNEL_EXPERIMENTAL, or CHANNEL_DISABLED)"
  type        = string
  default     = "CHANNEL_STANDARD"
}

variable "release_channel" {
  description = "Release channel for GKE updates (REGULAR, RAPID, STABLE, UNSPECIFIED)"
  type        = string
  default     = "REGULAR"
}

variable "deletion_protection" {
  description = "Whether to enable Terraform deletion protection for the cluster"
  type        = bool
  default     = false
}

variable "node_pools" {
  description = "Map of node pool configurations"
  type = map(object({
    machine_type = optional(string)
    disk_size_gb = optional(number)
    disk_type    = optional(string)
    is_spot      = optional(bool)
    node_count   = optional(number)
    autoscaling = optional(object({
      min_node_count = number
      max_node_count = number
    }))
    max_pods_per_node = optional(number)
    service_account   = optional(string)
    tags              = optional(list(string))
    labels            = optional(map(string))
  }))
  default = {}
}

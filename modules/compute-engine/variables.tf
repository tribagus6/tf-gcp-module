variable "instance_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "region" {
  type    = string
  default = null
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "image" {
  type    = string
  default = "debian-cloud/debian-12"
}

variable "subnetwork" {
  type = string
}

variable "disk_size_gb" {
  type    = number
  default = 10
}

variable "is_spot" {
  type    = bool
  default = false
}

variable "add_public_ip" {
  type    = bool
  default = false
}

variable "use_static_ip" {
  type        = bool
  description = "Whether to allocate and attach a permanent reserved static IP"
  default     = false
}

variable "static_ip_address" {
  type        = string
  description = "Specific existing static IP address to assign to this VM (e.g. from a promoted IP)"
  default     = null
}

variable "network_tier" {
  type        = string
  description = "The networking tier used for the public IP. Options: STANDARD or PREMIUM."
  default     = "STANDARD"
}

variable "max_run_duration_seconds" {
  type    = number
  default = null
}

variable "metadata_startup_script" {
  type        = string
  description = "User startup script to pass to VM instance"
  default     = null
}

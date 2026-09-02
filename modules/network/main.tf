variable "project_id" {
  type = string
}

variable "network_name" {
  type = string
}

variable "region" {
  type = string
}

variable "subnets" {
  type = map(object({
    region        = string
    ip_cidr_range = string
    secondary_ip_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
}

resource "google_compute_network" "vpc" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  for_each      = var.subnets
  name          = each.key
  project       = var.project_id
  region        = each.value.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = each.value.ip_cidr_range

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_ranges != null ? each.value.secondary_ip_ranges : []
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}

# Firewall rule removed from here to be moved to the dedicated module

resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  project                            = var.project_id
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "subnet_self_links" {
  value = { for k, v in google_compute_subnetwork.subnet : k => v.self_link }
}

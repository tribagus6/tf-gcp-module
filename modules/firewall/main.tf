variable "project_id" {
  type = string
}

variable "network_name" {
  type = string
}

variable "custom_rules" {
  description = "List of custom firewall rules"
  type = map(object({
    direction = string
    priority  = number
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
    source_ranges = list(string)
    target_tags   = list(string)
  }))
  default = {}
}

resource "google_compute_firewall" "rules" {
  for_each = var.custom_rules

  name    = each.key
  project = var.project_id
  network = var.network_name

  direction = each.value.direction
  priority  = each.value.priority

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags
}

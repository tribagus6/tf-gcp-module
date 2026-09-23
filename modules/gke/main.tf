resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.location

  network    = var.network
  subnetwork = var.subnetwork

  # We create a GKE Standard cluster without the default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  # IP Allocation Policy for Secondary Ranges (VPC-native cluster)
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_secondary_range_name
    services_secondary_range_name = var.service_secondary_range_name
  }

  # Private Cluster Configuration
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # Gateway API Configuration
  gateway_api_config {
    channel = var.gateway_api_channel
  }

  # Release Channel
  release_channel {
    channel = var.release_channel
  }

  # Dataplane V2 configuration
  datapath_provider = var.datapath_provider

  # Workload Identity Configuration
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Master Authorized Networks (optional)
  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config != null && length(coalesce(var.master_authorized_networks_config, [])) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = coalesce(var.master_authorized_networks_config, [])
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  deletion_protection = var.deletion_protection
}

resource "google_container_node_pool" "custom_pools" {
  for_each = var.node_pools

  name       = each.key
  project    = var.project_id
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = each.value.autoscaling == null ? coalesce(each.value.node_count, 1) : null

  dynamic "autoscaling" {
    for_each = each.value.autoscaling != null ? [each.value.autoscaling] : []
    content {
      min_node_count = autoscaling.value.min_node_count
      max_node_count = autoscaling.value.max_node_count
    }
  }

  max_pods_per_node = each.value.max_pods_per_node

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb
    disk_type    = each.value.disk_type
    spot         = each.value.is_spot
    tags         = each.value.tags
    labels       = each.value.labels

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    service_account = each.value.service_account

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}

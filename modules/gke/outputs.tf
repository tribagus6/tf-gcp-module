output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_id" {
  description = "The GKE cluster ID"
  value       = google_container_cluster.primary.id
}

output "endpoint" {
  description = "The IP address of the GKE cluster master endpoint"
  value       = google_container_cluster.primary.endpoint
}

output "ca_certificate" {
  description = "The public certificate authority of the cluster"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "node_pools" {
  description = "Map of node pools created"
  value       = { for k, v in google_container_node_pool.custom_pools : k => v.id }
}

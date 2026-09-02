output "instance_id" {
  description = "The server-assigned unique identifier of this instance"
  value       = google_compute_instance.vm_instance.instance_id
}

output "instance_self_link" {
  description = "The URI of the created resource"
  value       = google_compute_instance.vm_instance.self_link
}

output "internal_ip" {
  description = "The internal IP address assigned to the instance"
  value       = google_compute_instance.vm_instance.network_interface[0].network_ip
}

output "public_ip" {
  description = "The public IP address assigned to the instance"
  value       = var.add_public_ip ? (var.use_static_ip ? google_compute_address.static_ip[0].address : try(google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip, null)) : null
}

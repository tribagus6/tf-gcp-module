output "instance_self_link" {
  value = google_compute_instance.vm_instance.self_link
}

output "private_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].network_ip
}

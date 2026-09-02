resource "google_compute_instance" "vm_instance" {
  name                    = var.instance_name
  project                 = var.project_id
  machine_type            = var.machine_type
  zone                    = var.zone
  metadata_startup_script = var.metadata_startup_script

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size_gb
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    # Only add access_config (public IP) if it's NOT a spot VM (matching user's previous request for private spot VMs)
    # OR we can add a variable for this. Let's add a variable for clarity.
    dynamic "access_config" {
      for_each = var.add_public_ip ? [1] : []
      content {
        network_tier = var.network_tier
      }
    }
  }

  scheduling {
    preemptible                 = var.is_spot
    automatic_restart           = !var.is_spot
    provisioning_model          = var.is_spot ? "SPOT" : "STANDARD"
    instance_termination_action = var.is_spot ? "STOP" : null

    dynamic "max_run_duration" {
      for_each = var.max_run_duration_seconds != null ? [1] : []
      content {
        seconds = var.max_run_duration_seconds
      }
    }
  }
}

resource "google_compute_address" "static_ip" {
  count        = var.add_public_ip && var.use_static_ip && var.static_ip_address == null ? 1 : 0
  name         = "${var.instance_name}-ip"
  project      = var.project_id
  region       = coalesce(var.region, join("-", slice(split("-", var.zone), 0, 2)))
  network_tier = var.network_tier
}

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
    dynamic "access_config" {
      for_each = var.add_public_ip ? [1] : []
      content {
        nat_ip       = var.static_ip_address != null ? var.static_ip_address : (var.use_static_ip ? google_compute_address.static_ip[0].address : null)
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

  service_account {
    scopes = ["cloud-platform"]
  }
}

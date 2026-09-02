variable "project_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "region" {
  type = string
}

resource "google_storage_bucket" "tf_state" {
  name          = var.bucket_name
  project       = var.project_id
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

output "bucket_name" {
  value = google_storage_bucket.tf_state.name
}

output "bucket_url" {
  value = google_storage_bucket.tf_state.url
}


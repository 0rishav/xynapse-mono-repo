resource "google_compute_instance" "ephemeral_runner" {
  name         = "arc-runner-${var.job_id}"
  machine_type = "n2-standard-4"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts" 
      size  = 30            
      type  = "pd-standard"
    }
  }

  scheduling {
    preemptible       = true 
    automatic_restart = false
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.arc_subnet_id
  }

  metadata_startup_script = templatefile("${path.module}/setup-runner.sh", {
    REPO_OWNER   = var.repo_owner
    REPO_NAME    = var.repo_name
    RUNNER_TOKEN = var.github_token
  })

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
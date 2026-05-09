# 1. GCS Bucket for Terraform State
resource "google_storage_bucket" "tf_state" {
  name          = "${var.project_id}-tfstate-${var.env}"
  location      = var.region
  force_destroy = false # Safety: Don't delete bucket if it has files
  
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  # Versioning is CRUCIAL for state files
  versioning {
    enabled = true
  }

  # Encryption at rest
  encryption {
    default_kms_key_name = "" # Use Google-managed keys by default
  }

  # Prevents public access (Security First)
  public_access_prevention = "enforced"
}
variable "job_id" {
  description = "Unique ID from GitHub Actions (GITHUB_RUN_ID) to prevent name conflicts"
  type        = string
}

variable "zone" {
  description = "The GCP zone where the runner instance will be created"
  type        = string
  default     = "us-central1-a"
}

variable "vpc_id" {
  description = "The ID of the VPC network"
  type        = string
}

variable "arc_subnet_id" {
  description = "The ID of the dedicated private subnet for ARC runners"
  type        = string
}

variable "repo_owner" {
  description = "GitHub Organization or Username"
  type        = string
}

variable "repo_name" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "github_token" {
  description = "Short-lived Runner Registration Token from GitHub API"
  type        = string
  sensitive   = true 
}

variable "service_account_email" {
  description = "The service account email with permissions to run the VM and pull images"
  type        = string
}
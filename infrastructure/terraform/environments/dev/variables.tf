variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the environment"
  type        = string
  default     = "us-central1"
}

variable "job_id" {
  description = "GitHub Run ID for ephemeral runner"
  type        = string
}

variable "repo_owner" {
  description = "GitHub username or org"
  type        = string
}

variable "repo_name" {
  description = "GitHub repository name"
  type        = string
}

variable "github_token" {
  description = "GitHub runner registration token"
  type        = string
  sensitive   = true
}
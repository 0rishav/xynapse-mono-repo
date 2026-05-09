variable "project_id" {
  description = "The GCP Production Project ID"
  type        = string
}

variable "region" {
  description = "Production region"
  type        = string
  default     = "us-east1" 
}

variable "job_id" { type = string }
variable "repo_owner" { type = string }
variable "repo_name" { type = string }
variable "github_token" { 
  type      = string
  sensitive = true 
}
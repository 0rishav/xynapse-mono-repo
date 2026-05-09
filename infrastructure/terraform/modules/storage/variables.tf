variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The region for the storage bucket"
  type        = string
}

variable "env" {
  description = "Environment name (dev/prod)"
  type        = string
}
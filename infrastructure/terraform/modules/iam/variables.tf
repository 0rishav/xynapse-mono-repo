variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster for Workload Identity binding"
  type        = string
}
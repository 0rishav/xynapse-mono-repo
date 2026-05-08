variable "cluster_name" {
  description = "Name of the GKE Standard cluster"
  type        = string
}

variable "region" {
  description = "Region for the regional cluster (for high availability)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID from the network module"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet ID where nodes will reside"
  type        = string
}

variable "gke_num_nodes" {
  description = "Number of nodes per zone in the node pool"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for the GKE nodes"
  type        = string
  default     = "e2-standard-2"
}
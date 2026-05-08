variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "region" {
  description = "The GCP region where the infrastructure will be deployed"
  type        = string
}

variable "main_cidr_range" {
  description = "The primary IP CIDR range for the private application subnet"
  type        = string
  default     = "10.0.0.0/18"
}

variable "secondary_ip_ranges" {
  description = "Secondary IP CIDR ranges for GKE pods and services (Alias IPs)"
  type        = map(string)
  default     = {
    pods     = "10.48.0.0/14"
    services = "10.52.0.0/20"
  }
}

variable "arc_runner_cidr" {
  description = "Dedicated CIDR range for the self-hosted ARC runner subnet"
  type        = string
  default     = "10.0.64.0/24"
}
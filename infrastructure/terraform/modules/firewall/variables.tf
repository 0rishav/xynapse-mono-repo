variable "vpc_id" {
  description = "The ID of the VPC where rules will be applied"
  type        = string
}

variable "network_name" {
  description = "Name of the network for prefixing rule names"
  type        = string
}

variable "firewall_rules" {
  description = "Map of firewall rules to create"
  type = map(object({
    description   = string
    protocol      = string
    ports         = list(string)
    source_ranges = list(string)
    target_tags   = list(string)
  }))
  default = {
    "allow-internal" = {
      description   = "Allow all internal traffic between subnets"
      protocol      = "icmp"
      ports         = []
      source_ranges = ["10.0.0.0/8"]
      target_tags   = []
    },
    "allow-gke-master-to-nodes" = {
      description   = "Allow GKE Master to communicate with nodes"
      protocol      = "tcp"
      ports         = ["443", "10250"]
      source_ranges = ["172.16.0.0/28"] 
      target_tags   = ["gke-node"]
    },
    "allow-lb-health-checks" = {
      description   = "Allow Google Cloud LB Health Checks"
      protocol      = "tcp"
      ports         = ["80", "443", "8080"]
      source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
      target_tags   = ["gke-node"]
    }
  }
}
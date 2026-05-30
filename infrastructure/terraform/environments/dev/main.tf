provider "google" {
  project = var.project_id
  region  = var.region
}

import {
  id = "projects/xynapse-system/global/networks/xynapse-dev-vpc"
  to = module.vpc.google_compute_network.main
}

import {
  id = "projects/xynapse-system/regions/us-central1/subnetworks/xynapse-dev-vpc-private-subnet"
  to = module.vpc.google_compute_subnetwork.private
}

import {
  id = "projects/xynapse-system/regions/us-central1/subnetworks/xynapse-dev-vpc-arc-subnet"
  to = module.vpc.google_compute_subnetwork.arc_subnet
}

import {
  id = "projects/xynapse-system/regions/us-central1/routers/xynapse-dev-vpc-router"
  to = module.vpc.google_compute_router.router
}

import {
  id = "projects/xynapse-system/regions/us-central1/routers/xynapse-dev-vpc-router/xynapse-dev-vpc-nat"
  to = module.vpc.google_compute_router_nat.nat
}

import {
  id = "projects/xynapse-system/locations/us-central1/clusters/xynapse-dev-gke"
  to = module.gke.google_container_cluster.primary
}

# 1. VPC Module
module "vpc" {
  source              = "../../modules/vpc"
  network_name        = "xynapse-dev-vpc"
  region              = var.region
  main_cidr_range     = "10.0.0.0/18"
  arc_runner_cidr     = "10.0.64.0/24"
  secondary_ip_ranges = {
    pods     = "10.48.0.0/14"
    services = "10.52.0.0/20"
  }
}

# 2. IAM Module
module "iam" {
  source       = "../../modules/iam"
  project_id   = var.project_id
  environment  = "dev"
  cluster_name = "xynapse-dev-gke"
}

# 3. GKE Module
module "gke" {
  source        = "../../modules/gke"
  cluster_name  = "xynapse-dev-gke"
  region        = var.region
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnet_id
  gke_num_nodes = 1
  machine_type  = "e2-medium"
}

# 4. Firewall Modulessss

module "security" {
  source       = "../../modules/firewall"
  vpc_id       = module.vpc.vpc_id
  network_name = module.vpc.network_name
}

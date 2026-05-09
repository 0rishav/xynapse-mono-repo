provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. VPC Module 
module "vpc" {
  source              = "../../modules/vpc"
  network_name        = "xynapse-prod-vpc"
  region              = var.region
  main_cidr_range     = "10.1.0.0/18"   
  arc_runner_cidr     = "10.1.64.0/24"
  secondary_ip_ranges = {
    pods     = "10.56.0.0/14"          
    services = "10.60.0.0/20"
  }
}

# 2. IAM Module
module "iam" {
  source       = "../../modules/iam"
  project_id   = var.project_id
  environment  = "prod"
  cluster_name = "xynapse-prod-gke"
}

# 3. GKE Module 
module "gke" {
  source        = "../../modules/gke"
  cluster_name  = "xynapse-prod-gke"
  region        = var.region
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnet_id
  gke_num_nodes = 2              
  machine_type  = "e2-medium" 
}

# 4. Firewall Module

module "security" {
  source       = "../../modules/firewall"
  vpc_id       = module.vpc.vpc_id
  network_name = module.vpc.network_name
}

# 5. ARC Runner 
module "arc_runner" {
  source                = "../../modules/arc-runner"
  job_id                = var.job_id
  vpc_id                = module.vpc.vpc_id
  arc_subnet_id         = module.vpc.arc_subnet_id
  repo_owner            = var.repo_owner
  repo_name             = var.repo_name
  github_token          = var.github_token
  service_account_email = module.iam.arc_sa_email
  zone                  = "${var.region}-b" 
}
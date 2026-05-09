# 1. The Core VPC
resource "google_compute_network" "main" {
  name                            = var.network_name
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = false
}

# 2. Private Subnet for GKE & App Services
resource "google_compute_subnetwork" "private" {
  name                     = "${var.network_name}-private-subnet"
  ip_cidr_range            = var.main_cidr_range
  region                   = var.region
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  # Secondary ranges for GKE (Crucial for Zero-Downtime Networking)
  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = var.secondary_ip_ranges["pods"]
  }

  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = var.secondary_ip_ranges["services"]
  }
}

# 3. Dedicated Private Subnet for ARC Runner (Isolation Phase)
resource "google_compute_subnetwork" "arc_subnet" {
  name                     = "${var.network_name}-arc-subnet"
  ip_cidr_range            = var.arc_runner_cidr
  region                   = var.region
  network                  = google_compute_network.main.id
  private_ip_google_access = true
}

# 4. Cloud NAT (For Egress - ARC needs this to pull packages)
resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
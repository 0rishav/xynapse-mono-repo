# 1. Service Account for GKE Nodes
resource "google_service_account" "gke_nodes_sa" {
  account_id   = "gke-nodes-sa-${var.environment}"
  display_name = "GKE Nodes Service Account for ${var.environment}"
}

# Standard Roles for GKE Nodes (Logging, Monitoring, Registry Read)
resource "google_project_iam_member" "gke_nodes_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_nodes_sa.email}"
}

# 2. Service Account for ARC Runner (CI/CD)
resource "google_service_account" "arc_runner_sa" {
  account_id   = "arc-runner-sa-${var.environment}"
  display_name = "ARC Runner Service Account for ${var.environment}"
}

# Roles for ARC Runner (Compute admin to destroy itself, GCR/AR to push images)
resource "google_project_iam_member" "arc_runner_roles" {
  for_each = toset([
    "roles/compute.instanceAdmin.v1",
    "roles/artifactregistry.writer",
    "roles/container.developer",  # To deploy to GKE
    "roles/iam.serviceAccountUser" # To act as other SAs
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.arc_runner_sa.email}"
}

# 3. Workload Identity Binding (Connecting K8s SA to Google SA)
resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.gke_nodes_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[default/default]"
}
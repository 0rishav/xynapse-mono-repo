output "gke_sa_email" {
  value = google_service_account.gke_nodes_sa.email
}

output "arc_sa_email" {
  value = google_service_account.arc_runner_sa.email
}
output "vpc_id" {
  value = google_compute_network.main.id
}

output "private_subnet_id" {
  value = google_compute_subnetwork.private.id
}

output "arc_subnet_id" {
  value = google_compute_subnetwork.arc_subnet.id
}

output "network_name" {
  value = google_compute_network.main.name
}
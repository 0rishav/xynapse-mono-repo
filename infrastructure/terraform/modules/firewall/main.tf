resource "google_compute_firewall" "rules" {
  for_each = var.firewall_rules

  name        = "${var.network_name}-${each.key}"
  network     = var.vpc_id
  description = each.value.description

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }

  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags
}
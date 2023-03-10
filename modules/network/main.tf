resource "google_compute_network" "vnet" {
  project                 = var.project
  name = "${var.namespace}-vnet"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sn" {
  for_each = var.subnet_conf

  name = "${var.namespace}-${each.key}-sn"
  ip_cidr_range = cidrsubnet(var.address_space, 8, each.value)

  region        = var.region
  network       = google_compute_network.vnet.id
}

resource "google_compute_firewall" "fw" {
  name = "${var.namespace}-firewall"
  network = google_compute_network.vnet.name
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = var.ports
  }

  target_tags = var.target_tags
}

resource "google_compute_address" "public_ip" {
  name = "${var.namespace}-public-ip"
}

resource "google_compute_address" "private_ip" {
  name = "${var.namespace}-private-ip"
}

resource "google_compute_http_health_check" "http_health_check" {
  name = "${var.namespace}-http-health-check"

  port         = 8081
  request_path = "/status"
}

resource "google_compute_target_pool" "pool" {
  name      = "${var.namespace}-target-pool"
  instances = var.instances
  health_checks = [
    "${google_compute_http_health_check.http_health_check.name}"
  ]
}

resource "google_compute_forwarding_rule" "forwarding_rule" {
  count      = length(var.ports)
  name       = "${var.namespace}-forwarding-rule-${count.index}"
  target     = google_compute_target_pool.pool.id
  port_range = var.ports[count.index]
  region     = var.region

  load_balancing_scheme = var.is_lb_external ? "EXTERNAL" : "INTERNAL"
  ip_address            = var.is_lb_external ? google_compute_address.public_ip.address : google_compute_address.private_ip.address
}

output "lb_ip" {
  description = "the ip of load balancer"
  value       = var.is_lb_external ? google_compute_address.public_ip.address : google_compute_address.private_ip.address
}

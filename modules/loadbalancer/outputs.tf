output "public_ip" {
  description = "the ip of load balancer"
  value       = google_compute_address.public_ip.address
}

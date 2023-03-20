output "loadbalancer_ip" {
  description = "The ip address for loadbalancer resource"
  value       = module.emqx_lb.lb_ip
}

output "tls_key" {
  description = "The key for self signed certificate"
  value       = module.self_signed_cert.key
  sensitive   = true
}

output "tls_cert" {
  description = "The cert for self signed certificate"
  value       = module.self_signed_cert.cert
  sensitive   = true
}

output "tls_ca" {
  description = "The ca for self signed certificate"
  value       = module.self_signed_cert.ca
  sensitive   = true
}

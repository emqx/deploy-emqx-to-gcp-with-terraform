output "loadbalancer_public_ip" {
  description = "The public ip address for loadbalancer resource"
  value = module.emqx_lb.public_ip
}

# output "loadbalancer_private_ip" {
#   description = "The private ip address for loadbalancer resource"
#   value = module.emqx_lb.azurerm_lb_private_ip_address
# }

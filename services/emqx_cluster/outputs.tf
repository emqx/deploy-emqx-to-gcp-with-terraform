output "loadbalancer_ip" {
  description = "The ip address for loadbalancer resource"
  value = module.emqx_lb.lb_ip
}



#######################################
# network modules
#######################################

module "emqx_network" {
  source = "../../modules/network"

  project = var.project
  namespace = var.namespace
  region = var.region
  subnet_conf = var.subnet_conf
  ports = var.firewall_ports
  target_tags = var.target_tags
  address_space = var.emqx_address_space
}


#######################################
# emqx cluster modules
#######################################

module "emqx_cluster" {
  source = "../../modules/emqx_cluster"

  namespace                   = var.namespace
  instance_type = var.emqx_instance_type
  ssh_user = var.gce_ssh_user

  instance_count = var.emqx_instance_count
  tags = var.target_tags
  network = module.emqx_network.network
  subnetwork = module.emqx_network.subnetwork[0]
  emqx_package = var.emqx_package
  emqx_lic = var.emqx_lic
}


#######################################
#  loadbalancer modules
#######################################

module "emqx_lb" {
  source                                 = "../../modules/loadbalancer"
  namespace = var.namespace
  instances = module.emqx_cluster.instance_ids
  ports = var.emqx_ports
  region = var.region
}

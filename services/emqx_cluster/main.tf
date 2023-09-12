locals {
  package_url = var.is_emqx5 ? var.emqx5_package : var.emqx4_package

}

#######################################
# check package
#######################################

resource "null_resource" "check_url" {
  triggers = {
    package = local.package_url
  }

  # Execute a local script
  provisioner "local-exec" {
    command = <<EOT
      #!/bin/bash
      set -e

      # Define the URL to check
      url="${local.package_url}"

      # Check if the URL ends with tar.gz or zip
      if [[ "$url" =~ ubuntu20.04-amd64\.(zip|tar\.gz)$ ]]; then
        echo "URL suffix is valid (ubuntu20.04-amd64.tar.gz or ubuntu20.04-amd64.zip)."

        # Attempt to download the package
        if curl -fsS --head "$url" > /dev/null; then
          echo "Package can be downloaded."
        else
          echo "Package download failed."
          exit 1
        fi
      else
        echo "Invalid URL suffix. URL should end with ubuntu20.04-amd64.tar.gz or ubuntu20.04-amd64.zip."
        exit 1
      fi
    EOT
  }
}

#######################################
# network modules
#######################################

module "emqx_network" {
  source = "../../modules/network"

  project       = var.project
  namespace     = var.namespace
  region        = var.region
  subnet_conf   = var.subnet_conf
  ports         = var.firewall_ports
  target_tags   = var.target_tags
  address_space = var.emqx_address_space
  depends_on = [null_resource.check_url]
}

#######################################
# emqx cluster modules
#######################################

module "self_signed_cert" {
  source = "../../modules/self_signed_cert"

  ca_common_name        = var.ca_common_name
  common_name           = var.common_name
  org                   = var.org
  early_renewal_hours   = var.early_renewal_hours
  validity_period_hours = var.validity_period_hours
  depends_on = [null_resource.check_url]
}

#######################################
# emqx4 cluster modules
#######################################

module "emqx4_cluster" {
  count = var.is_emqx5 ? 0 : 1

  source = "../../modules/emqx4_cluster"

  namespace     = var.namespace
  instance_type = var.emqx_instance_type
  ssh_user      = var.gce_ssh_user

  instance_count = var.emqx_instance_count
  tags           = var.target_tags
  network        = module.emqx_network.network
  subnetwork     = module.emqx_network.subnetwork[0]
  emqx_package   = var.emqx4_package
  emqx_lic       = var.emqx_lic
  cookie         = var.emqx_cookie

  # SSL/TLS
  enable_ssl_two_way = var.enable_ssl_two_way
  key                = module.self_signed_cert.key
  cert               = module.self_signed_cert.cert
  ca                 = module.self_signed_cert.ca
  depends_on = [null_resource.check_url]
}


#######################################
# emqx5 cluster modules
#######################################

module "emqx5_cluster" {
  count = var.is_emqx5 ? 1 : 0

  source = "../../modules/emqx5_cluster"

  namespace     = var.namespace
  instance_type = var.emqx_instance_type
  ssh_user      = var.gce_ssh_user

  instance_count = var.emqx_instance_count
  core_count     = var.emqx5_core_count
  tags           = var.target_tags
  network        = module.emqx_network.network
  subnetwork     = module.emqx_network.subnetwork[0]
  emqx_package   = var.emqx5_package
  emqx_lic       = var.emqx_lic
  cookie         = var.emqx_cookie

  # SSL/TLS
  enable_ssl_two_way = false
  key                = module.self_signed_cert.key
  cert               = module.self_signed_cert.cert
  ca                 = module.self_signed_cert.ca
  depends_on = [null_resource.check_url]
}


#######################################
#  loadbalancer modules
#######################################

module "emqx_lb" {
  source         = "../../modules/loadbalancer"
  namespace      = var.namespace
  instances      = var.is_emqx5 ? module.emqx5_cluster[0].instance_ids : module.emqx4_cluster[0].instance_ids
  is_lb_external = true
  ports          = var.emqx_ports
  region         = var.region
  depends_on = [null_resource.check_url]
}

locals {
  home             = "/home/ubuntu"
  replicant_count  = var.instance_count - var.core_count
  public_ips       = google_compute_instance.instance[*].network_interface.0.access_config.0.nat_ip
  private_ips      = google_compute_instance.instance[*].network_interface.0.network_ip
  private_ips_json = jsonencode([for ip in local.private_ips : format("emqx@%s", ip)])


  public_core_ips       = slice(local.public_ips, 0, var.core_count)
  private_core_ips      = slice(local.private_ips, 0, var.core_count)
  private_core_ips_json = jsonencode([for ip in local.private_core_ips : format("emqx@%s", ip)])

  public_replicant_ips  = slice(local.public_ips, var.core_count, var.instance_count)
  private_replicant_ips = slice(local.private_ips, var.core_count, var.instance_count)
}


# Create (and display) an SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Configure the GCE instance in a public subnet
resource "google_compute_instance" "instance" {
  count        = var.instance_count
  name         = "${var.namespace}-vm-${count.index}"
  machine_type = var.instance_type
  tags         = var.tags

  metadata = {
    ssh-keys = "${var.ssh_user}:${tls_private_key.ssh.public_key_openssh}"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 20
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "null_resource" "emqx-core" {
  depends_on = [google_compute_instance.instance]

  count = var.core_count
  connection {
    type        = "ssh"
    host        = local.public_core_ips[count.index]
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
  }

  # create init script
  provisioner "file" {
    content = templatefile("${path.module}/scripts/init-core.sh", { local_ip = local.private_core_ips[count.index],
      emqx_lic = var.emqx_lic, enable_ssl_two_way = var.enable_ssl_two_way, emqx_ca = var.ca, emqx_cert = var.cert,
    emqx_key = var.key, cookie = var.cookie, core_nodes = local.private_core_ips_json, all_nodes = local.private_ips_json })
    destination = "/tmp/init.sh"
  }

  # download emqx
  provisioner "remote-exec" {
    inline = [
      "curl -L --max-redirs -1 -o /tmp/emqx.tar.gz ${var.emqx_package}"
    ]
  }

  # init system
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
      "sudo mv /tmp/emqx ${local.home}",
    ]
  }

  # Note: validate the above variables, you have to start emqx separately
  provisioner "remote-exec" {
    inline = [
      "sudo ${local.home}/emqx/bin/emqx start"
    ]
  }
}

resource "null_resource" "emqx-replicant" {
  depends_on = [null_resource.emqx-core]

  count = local.replicant_count
  connection {
    type        = "ssh"
    host        = local.public_replicant_ips[count.index]
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
  }

  # create init script
  provisioner "file" {
    content = templatefile("${path.module}/scripts/init-replicant.sh", { local_ip = local.private_replicant_ips[count.index],
      emqx_lic = var.emqx_lic, enable_ssl_two_way = var.enable_ssl_two_way, emqx_ca = var.ca, emqx_cert = var.cert,
    emqx_key = var.key, cookie = var.cookie, core_nodes = local.private_core_ips_json, all_nodes = local.private_ips_json })
    destination = "/tmp/init.sh"
  }

  # download emqx
  provisioner "remote-exec" {
    inline = [
      "curl -L --max-redirs -1 -o /tmp/emqx.tar.gz ${var.emqx_package}"
    ]
  }

  # init system
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
      "sudo mv /tmp/emqx ${local.home}",
    ]
  }

  # Note: validate the above variables, you have to start emqx separately
  provisioner "remote-exec" {
    inline = [
      "sudo ${local.home}/emqx/bin/emqx start"
    ]
  }
}

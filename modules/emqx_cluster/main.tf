locals {
  public_ips  = google_compute_instance.instance[*].network_interface.0.access_config.0.nat_ip
  private_ips = google_compute_instance.instance[*].network_interface.0.network_ip

  emqx_anchor     = element(local.private_ips, 0)
  emqx_rest       = slice(local.public_ips, 1, var.instance_count)
  emqx_rest_count = var.instance_count - 1
}

data "google_client_openid_userinfo" "me" {}

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

resource "null_resource" "ssh_connection" {
  depends_on = [google_compute_instance.instance]

  count = var.instance_count
  connection {
    type        = "ssh"
    host        = local.public_ips[count.index]
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
  }

  # create init script
  provisioner "file" {
    content     = templatefile("${path.module}/scripts/init.sh", { local_ip = local.private_ips[count.index], emqx_lic = var.emqx_lic })
    destination = "/tmp/init.sh"
  }

  # download emqx
  provisioner "remote-exec" {
    inline = [
      "curl -L --max-redirs -1 -o /tmp/emqx.zip ${var.emqx_package}"
    ]
  }

  # init system
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
    ]
  }

  # Note: validate the above variables, you have to start emqx separately
  provisioner "remote-exec" {
    inline = [
      "sudo /home/ubuntu/emqx/bin/emqx start"
    ]
  }
}

resource "null_resource" "emqx_cluster" {
  depends_on = [null_resource.ssh_connection]

  count = local.emqx_rest_count

  connection {
    type        = "ssh"
    host        = local.emqx_rest[count.index % local.emqx_rest_count]
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "/home/ubuntu/emqx/bin/emqx_ctl cluster join emqx@${local.emqx_anchor}"
    ]
  }
}


# Terraform EMQX on GCP

This Terraform module is designed to deploy either EMQX or EMQX Enterprise on Google Cloud Platform (GCP). EMQX is a scalable and open-source MQTT broker that connects IoT devices.

## Compatability

|   OS/Version | EMQX Enterprise 4.4.x | EMQX Open Source 4.4.x | EMQX Open Source 5.0.x |
|--------------|-----------------------|------------------------|------------------------|
| ubuntu 20.04 | ✓                     | ✓                      | ✓                      |


## Prerequisites

### Terraform 

This module requires Terraform to be installed. If you haven't installed it already, you can follow the [official Terraform installation guide](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli)

### GCP Credentials

To interact with the Google Cloud API, you need to authenticate. Follow this [guide](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials) to get started with GCP authentication.

## Deploying EMQX Cluster

### Configuring EMQX4

To deploy EMQX version 4.x, provide the package URL in the emqx4_package variable. Replace ${emqx4_package_url} with your actual URL.

```bash
emqx4_package = ${emqx4_package_url}
```

### Configuring EMQX5

```bash
emqx5_package = ${emqx5_package_url}
is_emqx5 = true
emqx5_core_count = 1
emqx_instance_count = 4
```

> **Note**

> The emq5_core_count should be less than or equal to emqx_instance_count. 


### Running terraform

To apply the Terraform module, navigate to the services/emqx_cluster directory and run the following commands:

```bash
cd services/emqx_cluster
terraform init
terraform plan
terraform apply -auto-approve
```

> **Note**

> If you're deploying EMQX Enterprise and need more than 10 quotas, apply for an EMQX license and pass it in as a variable during the terraform apply command.



After successful execution, Terraform will output the load balancer IP and sensitive information such as `tls_ca`, `tls_cert`, and `tls_key`.


```bash
Outputs:
loadbalancer_ip = ${loadbalancer_ip}
tls_ca = <sensitive>
tls_cert = <sensitive>
tls_key = <sensitive>
```

Access various services using the provided ports, for example:

```bash
Dashboard: ${loadbalancer_ip}:18083
MQTT: ${loadbalancer_ip}:1883
MQTTS: ${loadbalancer_ip}:8883
WS: ${loadbalancer_public_ip}:8083
WSS: ${loadbalancer_public_ip}:8084
```

### Enable SSL/TLS

Follow these configurations for SSL/TLS:


```bash
# default one-way SSL
enable_ssl_two_way = false
# common name for root ca
ca_common_name = "RootCA"
# common name for cert
common_name    = "Server"
# organization name
org = "EMQ"
# hours that the cert will valid for
validity_period_hours = 8760
# hours before its actual expiry time
early_renewal_hours = 720
```

> **Note**

> EMQX 5.x does not currently support SSL/TLS. 

To store CA, cert, and key to files for client connection, run:


``` bash
terraform output -raw tls_ca > tls_ca.pem
terraform output -raw tls_cert > tls_cert.pem
terraform output -raw tls_key > tls_key.key
```

If a client needs to verify the server's certificate chain and host name, you should configure the hosts file:


``` bash
${loadbalancer_ip} ${common_name}
```

### Cleanup

After you've finished with the EMQX cluster, you can destroy it using the following command:


```bash
terraform destroy -auto-approve
```

This will delete all resources created by Terraform in this module.

## Contribution

We welcome contributions from the community. Please submit your pull requests for bug fixes, improvements, and new features.

## License

This project is licensed under the terms of the [MIT License](https://opensource.org/license/mit).


## Support

If you encounter any problems or have any questions about this module, please open an issue in the GitHub repository.

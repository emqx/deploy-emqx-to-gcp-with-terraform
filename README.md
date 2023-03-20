

# terraform-emqx-emqx-gcp
Deploy emqx or emqx enterprise on gcp

## Compatability

|                          | EMQX 4.4.x      | 
|--------------------------|-----------------|
| ubuntu 20.04             | ✓               | 

> **Note**

> Not support EMQX 5.x currently  


## Install terraform
Please refer to [terraform install doc](https://learn.hashicorp.com/tutorials/terraform/install-cli)


## Config gcp credentials
You could follow this
[guide](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials)

## Deploy EMQX cluster
```bash
cd services/emqx_cluster
terraform init
terraform plan
terraform apply -auto-approve
```

> **Note**

> You should apply for an emqx license if you want more than 10 quotas when deploying emqx enterprise.  
terraform apply -auto-approve -var="emqx_lic=${your_license_content}"


After applying successfully, it will output the following:

```bash
Outputs:
loadbalancer_ip = ${loadbalancer_ip}
tls_ca = <sensitive>
tls_cert = <sensitive>
tls_key = <sensitive>
```


You can access different services with related ports
```bash
Dashboard: ${loadbalancer_ip}:18083
MQTT: ${loadbalancer_ip}:1883
MQTTS: ${loadbalancer_ip}:8883
WS: ${loadbalancer_ip}:
WSS: ${loadbalancer_ip}
```

## Enable SSL/TLS
Some configurations for it

```bash
# default one-way SSL
enable_ssl_two_way = false
# common name for root ca
ca_common_name = "RootCA"
# common name for cert
common_name    = "Server"
# organization name
org = "EMQ"
```

Stores ca, cert and key to files for client connection

``` bash
terraform output -raw tls_ca > tls_ca.pem
terraform output -raw tls_cert > tls_cert.pem
terraform output -raw tls_key > tls_key.key
```

If a client need to verify server's certificate chain and host name, you have to config the hosts file

``` bash
${loadbalancer_ip} ${org}
```

## Destroy
```bash
terraform destroy -auto-approve
```

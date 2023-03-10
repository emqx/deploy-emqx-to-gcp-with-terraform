

# terraform-emqx-emqx-gcp
Deploy emqx or emqx enterprise on gcp

## Compatability

|                          | EMQX 4.4.x      | 
|--------------------------|-----------------|
| ubuntu 20.04             | ✓               | 

> **Note**

> Not support EMQX 5.x currently  
Not support TLS 


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
```


You can access different services with related ports
```bash
Dashboard: ${loadbalancer_ip}:18083
MQTT: ${loadbalancer_ip}:1883
```

## Destroy
```bash
terraform destroy -auto-approve
```

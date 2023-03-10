<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.51.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_emqx_cluster"></a> [emqx\_cluster](#module\_emqx\_cluster) | ../../modules/emqx_cluster | n/a |
| <a name="module_emqx_lb"></a> [emqx\_lb](#module\_emqx\_lb) | ../../modules/loadbalancer | n/a |
| <a name="module_emqx_network"></a> [emqx\_network](#module\_emqx\_network) | ../../modules/network | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_credentials"></a> [credentials](#input\_credentials) | (Required) Service account credentials from GCP | `string` | n/a | yes |
| <a name="input_emqx_address_space"></a> [emqx\_address\_space](#input\_emqx\_address\_space) | (Required) The address space that is used by the virtual network | `string` | n/a | yes |
| <a name="input_emqx_instance_count"></a> [emqx\_instance\_count](#input\_emqx\_instance\_count) | (Required) The count of emqx node | `number` | n/a | yes |
| <a name="input_emqx_instance_type"></a> [emqx\_instance\_type](#input\_emqx\_instance\_type) | (Required) The SKU which should be used for this Virtual Machine | `string` | n/a | yes |
| <a name="input_emqx_lic"></a> [emqx\_lic](#input\_emqx\_lic) | (Optional) the content of the license | `string` | `""` | no |
| <a name="input_emqx_package"></a> [emqx\_package](#input\_emqx\_package) | (Required) The install package of emqx | `string` | n/a | yes |
| <a name="input_emqx_ports"></a> [emqx\_ports](#input\_emqx\_ports) | (Required) Ingress of emqx | `list(string)` | <pre>[<br>  "1883",<br>  "8883",<br>  "8083",<br>  "8084",<br>  "18083"<br>]</pre> | no |
| <a name="input_firewall_ports"></a> [firewall\_ports](#input\_firewall\_ports) | (Required) Ingress of firewall | `list(string)` | <pre>[<br>  "22",<br>  "8081",<br>  "4370",<br>  "1883",<br>  "8883",<br>  "8083",<br>  "8084",<br>  "18083"<br>]</pre> | no |
| <a name="input_gce_ssh_user"></a> [gce\_ssh\_user](#input\_gce\_ssh\_user) | (Required) The ssh user of GCE | `string` | `"ubuntu"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Required) The prefix of these resources | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | (Required) The project where the resources reside in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | (Required) The GCP Region where the Resource should exist | `string` | n/a | yes |
| <a name="input_subnet_conf"></a> [subnet\_conf](#input\_subnet\_conf) | (Required) The netnum of subnet of emqx and lb | `map(number)` | <pre>{<br>  "emq": 1,<br>  "lb": 2<br>}</pre> | no |
| <a name="input_target_tags"></a> [target\_tags](#input\_target\_tags) | (Required) A list of instance tags indicating sets of instances located in the network | `list(string)` | <pre>[<br>  "emqx"<br>]</pre> | no |
| <a name="input_zone"></a> [zone](#input\_zone) | (Required) The GCP Zone where the Resource should exist | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loadbalancer_public_ip"></a> [loadbalancer\_public\_ip](#output\_loadbalancer\_public\_ip) | The public ip address for loadbalancer resource |
<!-- END_TF_DOCS -->
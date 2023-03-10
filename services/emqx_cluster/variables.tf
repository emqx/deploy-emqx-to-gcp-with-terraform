variable "region" {
  description = "(Required) The GCP Region where the Resource should exist"
  type    = string
}

variable "zone" {
  description = "(Required) The GCP Zone where the Resource should exist"
  type    = string
}

variable "project" {
  description = "(Required) The project where the resources reside in"
  type    = string
}

variable "namespace" {
  description = "(Required) The prefix of these resources"
  type = string
}

variable "gce_ssh_user" {
  description = "(Required) The ssh user of GCE"
  type = string
  default = "ubuntu"
}

variable "emqx_address_space" {
  description = "(Required) The address space that is used by the virtual network"
  type = string
}

variable "subnet_conf" {
  description = "(Required) The netnum of subnet of emqx and lb"
  type = map(number)

  # Note: `value` represents the`netnum` argument in cidrsubnet function
  # Refer to https://www.terraform.io/language/functions/cidrsubnet
  default = {
    "emq" = 1,
    "lb" = 2
  }
}

variable "firewall_ports" {
  description = "(Required) Ingress of firewall"
  type        = list(string)
  default = ["22", "8081", "4370", "1883", "8883", "8083", "8084", "18083"]
}

variable "emqx_ports" {
  description = "(Required) Ingress of emqx"
  type        = list(string)
  default = ["1883", "8883", "8083", "8084", "18083"]
}

variable "target_tags" {
  description = "(Required) A list of instance tags indicating sets of instances located in the network"
  type        = list(string)
  default = ["emqx"]
}

variable "emqx_instance_count" {
  description = "(Required) The count of emqx node"
  type = number
}

variable "emqx_instance_type" {
  description = "(Required) The SKU which should be used for this Virtual Machine"
  type = string
}

variable "emqx_package" {
  description = "(Required) The install package of emqx"
  type = string
}

variable "credentials" {
  description = "(Required) Service account credentials from GCP"
  type = string
}

variable "emqx_lic" {
  description = "(Optional) the content of the license"
  type        = string
  default     = ""
}

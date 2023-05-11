variable "namespace" {
  type = string
}

variable "ssh_user" {
  type = string
}

variable "tags" {
  type = list(string)
}

variable "instance_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "emqx_package" {
  type = string
}

variable "emqx_lic" {
  type = string
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "key" {
  type = string
}

variable "cert" {
  type = string
}

variable "ca" {
  type = string
}

variable "enable_ssl_two_way" {
  type = bool
}

variable "cookie" {
  type = string
}

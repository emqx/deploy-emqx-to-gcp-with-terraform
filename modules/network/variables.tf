variable "namespace" {
  type = string
}

variable "region" {
  type = string
}

variable "project" {
  type = string
}

variable "address_space" {
  type = string
}

variable "subnet_conf" {
  type = map(number)
}

variable "ports" {
  type = list(string)
}


variable "target_tags" {
  type = list(string)
}

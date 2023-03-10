variable "namespace" {
  type = string
}

variable "instances" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "ports" {
  type = list(string)
}

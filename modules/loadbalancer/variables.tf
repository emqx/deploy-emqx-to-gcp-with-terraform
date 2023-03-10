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

variable "is_lb_external" {
  type = bool
}

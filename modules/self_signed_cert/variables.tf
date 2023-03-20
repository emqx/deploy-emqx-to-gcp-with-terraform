variable "ca_common_name" {
  description = "The common name of the CA"
  type        = string
}

variable "common_name" {
  description = "The common name of the certificate"
  type        = string
}

variable "org" {
  description = "The organization of the certificate"
  type        = string
}

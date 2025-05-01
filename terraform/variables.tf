locals {
  arch_certificate_domain = var.arch_certificate_domain == "" ? "*.${trimsuffix(module.core.outputs.vpc.public_dns_zone.name, ".")}" : var.arch_certificate_domain
}

variable "additional_hostnames" {
  type    = list(string)
  default = []
}

variable "agentless_sso_key" {
  type    = string
}

variable "app_name" {
  type    = string
  default = "arch"
}

variable "arch_certificate_domain" {
  type    = string
  default = ""
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "certificate_name" {
  type    = string
  default = "*"
}

variable "dissertation_depositor" {
  type    = string
}

variable "doi_host" {
  type    = string
}

variable "doi_password" {
  type    = string
}

variable "doi_shoulder" {
  type    = string
}

variable "doi_username" {
  type    = string
}

variable "email_contact" {
  type    = string
  default = "repository@northwestern.edu"
}

variable "geonames_username" {
  type    = string
}

variable "honeybadger_api_key" {
  type    = string
  default = ""
}

variable "recaptcha_secret_key" {
  type    = string
}

variable "recaptcha_site_key" {
  type    = string
}

variable "enable_autoscaling" {
  type    = bool
  default = false
}

variable "service_count_min" {
  type    = number
  default = 1
}

variable "service_count_max" {
  type    = number
  default = 3
}

variable "service_count_desired" {
  type    = number
  default = 1
}

variable "cpu_target" {
  type    = number
  default = 70
}

variable "memory_target" {
  type    = number
  default = 70
}
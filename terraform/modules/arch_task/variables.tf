variable "container_config" {
  type    = map(string)
}

variable "cpu" {
  type    = number
}

variable "db_pool_size" {
  type    = number
  default = 5
}

variable "memory" {
  type    = number
}

variable "container_role" {
  type    = string
}

variable "role_arn" {
  type    = string
}

variable "app_name" {
  type    = string
}

variable "tags" {
  type    = map(string)
}


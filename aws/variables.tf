
variable "owner" {
  type = string
}

variable "usage" {
  type    = string
  default = "demo"
}

variable "name_prefix" {
  type = string
}

variable "short_name_prefix" {
  type = string
}

variable "tags" {
  type    = map
  default = {}
}

variable "additional_tags" {
  type    = map
  default = {}
}

variable "dependencies" {
  type    = list
  default = []
}

variable "cidr_block" {
  type = string
}

variable "availability_zones" {
  default = null
}

variable "deploy_nat_gateway" {
  default = "standalone"
}

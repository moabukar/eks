
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

variable "dependencies" {
  type    = list
  default = []
}

variable "kubernetes_version" {
  type = string
}

variable "subnet_ids" {
  type = list
}

variable "enable_public_api_access" {
  type    = bool
  default = true
}

variable "enable_private_api_access" {
  type    = bool
  default = true
}

variable "controller_public_access_cidrs" {
  type    = list
  default = ["0.0.0.0/0"]
}

variable "controller_log_retention" {
  type    = number
  default = 0
}

variable "controller_log_types" {
  type = list
  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

variable "worker_instance_type" {
  type    = string
  default = "t3.large"
}

variable "worker_ami_type" {
  type    = string
  default = "AL2_x86_64"
}

variable "worker_desired_count" {
  type    = number
  default = 3
}

variable "worker_max_count" {
  type    = number
  default = 5
}

variable "worker_min_count" {
  type    = number
  default = 1
}

variable "worker_disk_size" {
  type    = number
  default = 64
}

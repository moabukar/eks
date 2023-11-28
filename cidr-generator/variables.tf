
variable "subnets" {
  type    = list
  default = ["main"]
}

variable "cidr_block" {
  default = "10.0.0.0/8"
}

variable "new_bits" {
  default = 8
}

variable "random_allocation" {
  default = true
}

variable "sequential_allocation_offset" {
  type    = string
  default = 0
}

variable "name_prefix" {
  type    = string
  default = null
}

variable "short_name_prefix" {
  type    = string
  default = null
}

variable "default_name_prefix" {
  type    = string
  default = "demo"
}

variable "use_default_name_prefix_values" {
  type = list
  default = [
    "",
    "default"
  ]
}

variable "random_string" {
  type    = string
  default = null
}

variable "random_string_length" {
  type    = string
  default = 5
}

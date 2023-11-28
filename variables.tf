##############################################################################
# variables.tf                                                                #
#                                                                             #
# This file specifies variables that may defined to modify a given            #
# Kubernetes deployment.                                                      #
#                                                                             #
###############################################################################

# --------------------------------------------------------------------------- #
# GENERAL                                                                     #
# --------------------------------------------------------------------------- #

variable "owner" {
  type = string
}

variable "usage" {
  type    = string
  default = "demo"
}

variable "name_prefix" {
  type    = string
  default = null
}

variable "short_name_prefix" {
  type    = string
  default = null
}

# --------------------------------------------------------------------------- #
# PROVIDERS                                                                   #
# --------------------------------------------------------------------------- #

variable "aws_region" {
  description = "(Required) Name of region for deployment"
  type        = string
  default     = "eu-west-2"
}

# --------------------------------------------------------------------------- #
# NETWORKING                                                                  #
# --------------------------------------------------------------------------- #

variable "global_cidr_block" {
  description = <<DESCRIPTION
    (Optional) Specifies the CIDR range to be split amongst all of the networks
    provisioned by this module. Currently only "10.0.0.0/8" is fully supported,
    other ranges may cause issues.
DESCRIPTION

  type    = string
  default = null
}

variable "global_subnet_new_bits" {
  description = <<DESCRIPTION
    (Optional) Specifies the number of new net bits available for the network
DESCRIPTION

  type    = string
  default = null
}

variable "default_kubernetes_version" {
  type    = string
  default = null
}

variable "kubernetes_versions" {
  type    = map
  default = {}
}

variable "aws_context_name" {
  type    = string
  default = "eks"
}

# --------------------------------------------------------------------------- #
# APPLICATIONS                                                                #
# --------------------------------------------------------------------------- #

variable "export_kubeconfigs" {
  type    = bool
  default = true
}


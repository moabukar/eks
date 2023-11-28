###############################################################################
# main.tf                                                                     #
#                                                                             #
# This file defines the terraform configuration and generic configuration.    #
#                                                                             #
###############################################################################

terraform {
  required_version = "~> 0.12.20" # supports "try" function
  backend s3 {
    bucket  = "aws-docker-demo"
    key     = "gws-eks/terraform.tfstate"
    region  = "eu-west-2"
  }

}

# --------------------------------------------------------------------------- #
# DEFINE NAMING                                                               #
#                                                                             #
# This section determines what name prefix should be applied to all resources #
# provisioned by this module. It will either use a specified prefix, use      #
# a default or use a generated one (default behaviour).                       #
#                                                                             #
# Since certain resources have limits on the length of their name, a shorter  #
# prefix will also be defined. If the specified name prefix is five           #
# characters or less it can be used as the short prefix.                      #
#                                                                             #
# --------------------------------------------------------------------------- #

module "prefixes" {
  source = "./name-generator"

  name_prefix       = var.name_prefix
  short_name_prefix = var.short_name_prefix

  default_name_prefix = "demo"
}

locals {
  name_prefix       = module.prefixes.name_prefix
  short_name_prefix = module.prefixes.short_name_prefix
}



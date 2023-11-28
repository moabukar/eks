module "cidr_generator" {
  source = "./cidr-generator"

  cidr_block = var.global_cidr_block
  new_bits   = var.global_subnet_new_bits

  subnets = [
    "aws",
    "azure",
    "gcp"
  ]
}

module "network_aws" {
  source = "./aws"

  owner = var.owner
  usage = var.usage

  name_prefix       = local.name_prefix
  short_name_prefix = local.short_name_prefix

  cidr_block = module.cidr_generator.cidr_blocks["aws"]

  tags = {
    "kubernetes.io/cluster/${local.name_prefix}-aws" = "shared"
  }

  additional_tags = {
    private_subnets = {
      "kubernetes.io/role/internal-elb" = 1
    }

    public_subnets = {
      "kubernetes.io/role/elb" = 1
    }
  }
}



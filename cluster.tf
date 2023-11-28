module "aws_cluster" {
  source = "./aws-eks"

  owner = var.owner
  usage = var.usage

  name_prefix       = format("%s-aws", local.name_prefix)
  short_name_prefix = local.short_name_prefix

  subnet_ids = concat(
    values(module.network_aws.public_subnets)[*].id
  )

  kubernetes_version = lookup(
    var.kubernetes_versions, "aws", var.default_kubernetes_version
  )

  dependencies = [
    module.network_aws.depended_on
  ]
}


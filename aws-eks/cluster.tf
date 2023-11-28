resource "aws_eks_cluster" "main" {
  depends_on = [
    aws_iam_role_policy_attachment.controller_cluster_policy,
    aws_iam_role_policy_attachment.controller_service_policy,
    aws_cloudwatch_log_group.main
  ]

  name = var.name_prefix

  version = var.kubernetes_version

  role_arn = aws_iam_role.controller.arn

  vpc_config {
    subnet_ids = var.subnet_ids

    endpoint_private_access = var.enable_private_api_access
    endpoint_public_access  = var.enable_public_api_access

    public_access_cidrs = var.controller_public_access_cidrs
  }

  enabled_cluster_log_types = (
    var.controller_log_retention > 0 ?
    var.controller_log_types :
    []
  )

  tags = merge(
    local.default_tags,
    {
      Name = var.name_prefix
    }
  )
}

resource "aws_eks_node_group" "main" {
  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.worker_cni_policy,
    aws_iam_role_policy_attachment.worker_registry_policy,
  ]

  node_group_name = var.name_prefix

  version = var.kubernetes_version

  cluster_name = aws_eks_cluster.main.name

  node_role_arn = aws_iam_role.worker.arn

  subnet_ids = var.subnet_ids

  scaling_config {
    desired_size = var.worker_desired_count
    max_size     = var.worker_max_count
    min_size     = var.worker_min_count
  }

  ami_type       = var.worker_ami_type
  instance_types = [var.worker_instance_type]
  disk_size      = var.worker_disk_size


  tags = merge(
    local.default_tags,
    {
      Name = var.name_prefix
    }
  )
}

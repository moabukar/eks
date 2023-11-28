resource "aws_cloudwatch_log_group" "main" {
  depends_on = [null_resource.dependency_getter]

  count = var.controller_log_retention > 0 ? 1 : 0

  name              = "/aws/eks/${var.name_prefix}/cluster"
  retention_in_days = var.controller_log_retention

  tags = local.default_tags
}

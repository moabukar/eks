
locals {
  default_tags = merge(
    map(
      "Owner", var.owner,
      "Usage", var.usage
    ),
    (
      var.tags != null ?
      var.tags : {}
    )
  )
}

resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    aws_eks_node_group.main
  ]
}

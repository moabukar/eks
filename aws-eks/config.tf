data "template_file" "kubeconfig" {
  depends_on = [
    aws_eks_node_group.main # cluster not usable until after nodes are ready...
  ]

  template = file("${path.module}/templates/kubeconfig.template")

  vars = {
    ca_data  = aws_eks_cluster.main.certificate_authority[0].data
    endpoint = aws_eks_cluster.main.endpoint
    name     = aws_eks_cluster.main.id
    region   = data.aws_region.current.name
  }
}

resource "local_file" "kubeconfig_aws" {
  count = var.export_kubeconfigs ? 1 : 0

  lifecycle {
    ignore_changes = [content]
  }

  filename = "./kubeconfig"
  content  = module.aws_cluster.kubeconfig
}



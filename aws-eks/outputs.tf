output "kubeconfig" {
  value = data.template_file.kubeconfig.rendered
}

output "controller_security_group_id" {
  value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "worker_security_group_id" {
  value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "depended_on" {
  value = null_resource.dependency_setter.id
}

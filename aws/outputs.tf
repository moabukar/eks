output "vpc" {
  value = aws_vpc.main
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "public_route_tables" {
  value = aws_route_table.public
}

output "private_route_tables" {
  value = aws_route_table.private
}

output "depended_on" {
  value = null_resource.dependency_setter.id
}


locals {
  default_tags = merge(
    (
      var.tags != null ?
      var.tags : {}
    ),
    map(
      "Owner", var.owner,
      "Usgae", var.usage
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
    aws_route.internet,
    aws_route.nat,
    aws_route_table_association.public,
    aws_route_table_association.private
  ]
}

data "aws_availability_zones" "current" {
  state = "available"
}

resource "aws_vpc" "main" {
  depends_on = [null_resource.dependency_getter]

  cidr_block = var.cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.default_tags,
    lookup(var.additional_tags, "vpc", {})
  )
}

resource "aws_subnet" "public" {
  for_each = toset(data.aws_availability_zones.current.names)

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value

  cidr_block = cidrsubnet(
    cidrsubnet(var.cidr_block, 4, 0),
    4,
    index(data.aws_availability_zones.current.names, each.value)
  )

  map_public_ip_on_launch = true

  tags = merge(
    map(
      "Name", "Public (${each.value})"
    ),
    local.default_tags,
    lookup(var.additional_tags, "public_subnets", {})
  )
}

resource "aws_subnet" "private" {
  for_each = toset(data.aws_availability_zones.current.names)

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value

  cidr_block = cidrsubnet(
    cidrsubnet(var.cidr_block, 4, 1),
    4,
    index(data.aws_availability_zones.current.names, each.value)
  )

  map_public_ip_on_launch = true

  tags = merge(
    map(
      "Name", "Private (${each.value})"
    ),
    local.default_tags,
    lookup(var.additional_tags, "private_subnets", {})
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {}
}

locals {
  nat_gateway_count_lookup = {
    none       = []
    null       = []
    single     = [data.aws_availability_zones.current.names[0]]
    standalone = [data.aws_availability_zones.current.names[0]]
    ha         = data.aws_availability_zones.current.names
  }
}

resource "aws_eip" "nat" {
  depends_on = [null_resource.dependency_getter]

  for_each = toset(
    lookup(local.nat_gateway_count_lookup, var.deploy_nat_gateway, [])
  )
}

resource "aws_nat_gateway" "main" {
  depends_on = [aws_internet_gateway.main]

  for_each = toset(
    lookup(local.nat_gateway_count_lookup, var.deploy_nat_gateway, [])
  )

  allocation_id = aws_eip.nat[each.value].id
  subnet_id     = aws_subnet.public[each.value].id
}

resource "aws_route_table" "public" {
  for_each = toset(data.aws_availability_zones.current.names)

  vpc_id = aws_vpc.main.id

  tags = {}
}

resource "aws_route_table" "private" {
  for_each = toset(data.aws_availability_zones.current.names)

  vpc_id = aws_vpc.main.id

  tags = {}
}

resource "aws_route" "internet" {
  depends_on = [aws_route_table.public]

  for_each = toset(data.aws_availability_zones.current.names)

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public[each.value].id
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route" "nat" {
  depends_on = [aws_route_table.private]

  for_each = toset(data.aws_availability_zones.current.names)

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[each.value].id

  nat_gateway_id = element(
    values(aws_nat_gateway.main)[*].id,
    index(data.aws_availability_zones.current.names, each.value)
  )
}

resource "aws_route_table_association" "public" {
  for_each = toset(data.aws_availability_zones.current.names)

  subnet_id      = aws_subnet.public[each.value].id
  route_table_id = aws_route_table.public[each.value].id
}

resource "aws_route_table_association" "private" {
  for_each = toset(data.aws_availability_zones.current.names)

  subnet_id      = aws_subnet.private[each.value].id
  route_table_id = aws_route_table.private[each.value].id
}

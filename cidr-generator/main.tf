
locals {
  cidr_block = (
    var.cidr_block != null ?
    var.cidr_block :
    "10.0.0.0/8"
  )

  new_bits = (
    var.new_bits != null ?
    var.new_bits :
    8
  )

  subnet_count = length(var.subnets)

  subnet_count_to_nearest_base_2 = (
    local.subnet_count > 1 ?
    ceil(local.subnet_count / 2) * 2 :
    1
  )

  network_bit_ranges = chunklist(
    range(0, pow(2, local.new_bits)),
    pow(2, local.new_bits) / local.subnet_count_to_nearest_base_2
  )
}

resource "random_integer" "network" {
  count = local.subnet_count

  min = element(local.network_bit_ranges[count.index], 0)
  max = element(reverse(local.network_bit_ranges[count.index]), 0)
}

locals {
  subnet_cidr_blocks = {
    for net in var.subnets :
    net => (
      var.random_allocation ?
      cidrsubnet(
        local.cidr_block,
        local.new_bits,
        element(random_integer.network.*.result, index(var.subnets, net))
      ) :
      cidrsubnet(
        local.cidr_block,
        local.new_bits,
        index(var.subnets, net) + var.sequential_allocation_offset
      )
    )
  }
}

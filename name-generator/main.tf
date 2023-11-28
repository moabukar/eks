resource "random_string" "prefix" {
  # use if no name prefix or short name prefix are specified
  count = (var.name_prefix == null || var.short_name_prefix == null) ? 1 : 0

  length  = var.random_string_length
  lower   = true
  upper   = false
  number  = false
  special = false
}

locals {
  random_prefix = (
    var.name_prefix == null || var.short_name_prefix == null ?
    (
      var.random_string != null ?
      var.random_string :
      random_string.prefix[0].result
    ) :
    null
  )

  name_prefix = (
    # check if specified a prefix
    var.name_prefix != null ?
    (
      # check if want specified or default prefix
      contains(
        var.use_default_name_prefix_values,
        replace(lower(var.name_prefix), " ", "")
      ) ?
      var.default_name_prefix : # use default prefix
      var.name_prefix           # use specified prefix, add "-" if required
    ) :
    # automatically generate a random prefix
    format(
      "%s-%s",
      var.default_name_prefix,
      local.random_prefix
    )
  )

  short_name_prefix = (
    var.short_name_prefix != null ?
    (
      contains(
        var.use_default_name_prefix_values,
        replace(lower(var.short_name_prefix), " ", "")
      ) ?
      var.default_name_prefix : # use default prefix
      var.short_name_prefix     # use specified prefix, add "-" if required
    ) :
    (
      length(local.name_prefix) <= 6 ?
      local.name_prefix :
      local.random_prefix
    )
  )
}

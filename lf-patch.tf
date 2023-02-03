locals {
  # use aws managed ipv6 or not
  assign_aws_managed_ipv6_cidr_block = length(var.ipv6_cidr_config) == 0 ? (
    var.enable_ipv6 && !var.use_ipam_pool ? true : null
  ) : null

  # because of https://discuss.hashicorp.com/t/error-on-second-apply-of-aws-vpc-with-ipv6-ipam-pool-id/46293
  # have to ignore changes of ipv6_ipam_pool_id
  # in order to support update, we will force aws_vpc_ipv6_cidr_block_association
  # recreate for any change of ipam_pool_id or cidr
  ipv6_cidr_name_map = {
    for name, obj in var.ipv6_cidr_config :
    name => format("${name}-${obj.ipam_pool_id}_%s", obj.cidr != null ? obj.cidr : "${obj.netmask_length}")
  }

  ipv6_cidr_to_associate = var.enable_ipv6 && local.create_vpc ? {
    for name, obj in var.ipv6_cidr_config : local.ipv6_cidr_name_map[name] => obj
  } : {}

  ipv6_subnet_cidrs = var.enable_ipv6 ? {
    for t, obj in var.ipv6_subnet_config :
    t => [for pos in obj.subnet_pos :
      cidrsubnet(
        aws_vpc_ipv6_cidr_block_association.ipv6[local.ipv6_cidr_name_map[obj.cidr_name]].ipv6_cidr_block,
        8, pos
    )]
  } : {}
}

resource "aws_vpc_ipv6_cidr_block_association" "ipv6" {
  for_each = local.ipv6_cidr_to_associate

  vpc_id              = aws_vpc.this[0].id # depend on vpc
  ipv6_ipam_pool_id   = each.value.ipam_pool_id
  ipv6_cidr_block     = each.value.cidr
  ipv6_netmask_length = each.value.cidr == null ? each.value.netmask_length : null

  lifecycle {
    ignore_changes = [
      # seem to me a bug in aws side, vpc created with ipv6_ipam_pool_id be set to a pool id will become "IPAM Managed"
      # https://discuss.hashicorp.com/t/error-on-second-apply-of-aws-vpc-with-ipv6-ipam-pool-id/46293
      ipv6_ipam_pool_id
    ]
  }
}

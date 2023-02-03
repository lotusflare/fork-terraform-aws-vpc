variable "ipv6_cidr_config" {
  type = map(object({
    ipam_pool_id = string
    cidr         = optional(string) # if omitted, will choose dynamically
    # /56 of cidr, ignored if cidr is provided
    netmask_length = optional(number, 56)
  }))
  default = {}
}

variable "ipv6_subnet_config" {
  description = "IPv6 subnets configs"
  type = map(object({  # key is subnet type, private, public, intra, database, ...
    cidr_name = string # key in var.ipv6_cidr_config
    # each subnet must be /64, instead of finding the cidr, we use pos
    # subnet_pos = [0, 1] define two subnets
    # subnet 1's cidr: cidrsubnet(cidr in the key, 8, 0)
    # subnet 2's cidr: cidrsubnet(cidr in the key, 8, 1)
    subnet_pos = optional(list(number), [])
  }))
}

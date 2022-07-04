variable "ipv4_ipam_pool_id" {
  description = "The ID of an BYOIP IPv4 IPAM pool"
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "Netmask length to request from IPAM Pool. Conflicts with cidr_block. This can be omitted if IPAM pool as a allocation_default_netmask_length set"
  type        = number
  default     = null
}

variable "ipv6_ipam_pool_id" {
  description = "The ID of an BYOIP ipv6 IPAM pool. Conflicts with enable_ipv6"
  type        = string
  default     = null
}

variable "ipv6_netmask_length" {
  description = "Netmask length to request from IPAM Pool. Conflicts with ipv6_cidr_block. This can be omitted if IPAM pool as a allocation_default_netmask_length set"
  type        = number
  default     = null
}

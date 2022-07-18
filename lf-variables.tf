variable "ipv6_ipam_pool_id" {
  description = "The ID of an BYOIP ipv6 IPAM pool. Conflicts with enable_ipv6"
  type        = string
  default     = null
}

variable "ipv6_cidrs" {
  description = "The IPv6 CIDR blocks for the VPC"
  type        = list(string)
  default     = []
}

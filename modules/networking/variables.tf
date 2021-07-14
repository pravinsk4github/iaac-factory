variable "resource_group_name" {
  type        = string
  description = "Name of resource group"
}

variable "location" {
  type        = string
  description = "Location for vnet"
}

variable "vnets" {
  type        = map(any)
  description = "List of vnets and subnets under each vnet"
  default = {
    vnet0 = {
      name          = "vnet0"
      address_space = ["10.0.0.0/16"]
      subnets = {
        subnet1 = {
          name           = "vnet0_subnet0"
          address_prefix = "10.0.0.0/24"
        }
        subnet2 = {
          name           = "vnet0_subnet1"
          address_prefix = "10.0.1.0/24"
        }
      }
    }
  }
}

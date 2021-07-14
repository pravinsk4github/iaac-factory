variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "Location/region"
}

variable "nsg_name" {
  type        = string
  default     = "nsg"
  description = "Name of the network security group"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags for the network security group"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "Location/region"
}

variable "asg_name" {
  type        = string
  default     = "asg"
  description = "Name for the application security group"
}

variable "tags" {
  default     = null
  type        = map(any)
  description = "Tags of the resource group"
}

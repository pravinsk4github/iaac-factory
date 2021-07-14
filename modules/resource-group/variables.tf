variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment to create resource group"
}

variable "location" {
  type        = string
  default     = "North Europe"
  description = "Location of the resource group"
}

variable "postfix" {
  type        = string
  default     = "resource"
  description = "Fixed string/any string to mitigate resource name collisions"
}

variable "tags" {
  default     = null
  type        = map(any)
  description = "Tags of the resource group"
}



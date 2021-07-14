variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "Location/region"
}

variable "ws_sku" {
  type        = string
  default     = "PerGB2018"
  description = "Sku of log analytics workspace"
}

variable "storage_account_ids" {
  type        = []
  description = "Storage account for log analytics on"
}

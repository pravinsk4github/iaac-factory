variable "resource_group_name" {
  type        = string
  description = "Name of resource group"
}

variable "location" {
  type        = string
  description = "Location for vnet"
}

variable "keyvault_name" {
  type        = string
  default     = "kv"
  description = "Name of the keyvault"
}

variable "diagnostics_storage_account_id" {
  type        = string
  description = "Id of storage account for diagnostics"
}

variable "sku_name" {
  type        = string
  description = "Sku  of keyvault"
}

variable "tags" {
  default     = null
  type        = map(any)
  description = "Tags of the resource group"
}

variable "retention_policy" {
  default = {
    enabled = true
    days    = 7
  }
}

variable "virtual_network_subnet_ids" {
  type = list(string)
}

variable "enabled_for_disk_encryption" {
  default = true
}

variable "purge_protection_enabled" {
  default = true
}

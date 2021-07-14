variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "Location/region"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the azure storage account"
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "Type of storage account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
}

variable "skuname" {
  description = "SKUs supported by MS Azure Storage. Valid options are Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, Standard_LRS, Standard_RAGRS, Standard_RAGZRS, Standard_ZRS"
  default     = "Standard_RAGRS"
}

variable "access_tier" {
  default     = "Hot"
  description = "Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cool."
}

variable "delete_retention_policy" {
  default     = {}
  description = "Number of retention days for soft delete. If set to null it will disable soft delete all together."
}

variable "allow_blob_public_access" {
  default     = false
  description = "Allow or disallow public access to all blobs or containers in the storage account."
}

variable "containers" {
  type        = list(object({ name = string, access_type = string }))
  default     = []
  description = "List of containers to create and their access levels."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags"
}

variable "enable_https_traffic_only" {
  type        = bool
  default     = true
  description = "Flag for restricing to https traffic only"
}

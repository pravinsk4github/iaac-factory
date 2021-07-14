resource "random_string" "unique" {
  length  = (24 - length(lower(replace(var.storage_account_name, "/[[:^alnum:]]/", ""))))
  special = false
  upper   = false
}

locals {
  storage_account_name      = format("%s%s", lower(replace(var.storage_account_name, "/[[:^alnum:]]/", "")), random_string.unique.result)
  location                  = var.location
  resource_group_name       = var.resource_group_name
  account_kind              = var.account_kind
  account_tier              = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.skuname)[0])
  account_replication_type  = (local.account_tier == "Premium" ? "LRS" : split("_", var.skuname)[1])
  enable_https_traffic_only = var.enable_https_traffic_only
  allow_blob_public_access  = var.allow_blob_public_access
  tags                      = merge({ "ResourceName" = format("sta%s%s", lower(replace(var.storage_account_name, "/[[:^alnum:]]/", "")), random_string.unique.result) }, var.tags)
  delete_retention_policy   = var.delete_retention_policy
  containers                = var.containers
  access_tier               = var.access_tier
}

resource "azurerm_storage_account" "storage_account" {
  name                      = local.storage_account_name
  resource_group_name       = local.resource_group_name
  location                  = local.location
  account_kind              = local.account_kind
  account_tier              = local.account_tier
  account_replication_type  = local.account_replication_type
  access_tier               = local.access_tier
  enable_https_traffic_only = local.enable_https_traffic_only
  allow_blob_public_access  = local.allow_blob_public_access
  tags                      = local.tags
  blob_properties {
    delete_retention_policy {
      days = local.delete_retention_policy.days
    }
  }
}

resource "azurerm_storage_container" "container" {
  count                 = length(local.containers)
  name                  = local.containers[count.index].name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = local.containers[count.index].access_type
}

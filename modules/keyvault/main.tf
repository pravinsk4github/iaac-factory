resource "random_string" "unique" {
  length  = (24 - length(lower(replace(var.keyvault_name, "/[[:^alnum:]]/", ""))))
  special = false
  upper   = false
}

locals {
  location                       = var.location
  resource_group_name            = var.resource_group_name
  keyvault_name                  = format("%s%s", lower(replace(var.keyvault_name, "/[[:^alnum:]]/", "")), random_string.unique.result)
  keyvault_id                    = azurerm_key_vault.keyvault.id
  sku_name                       = var.sku_name
  tags                           = var.tags
  tenant_id                      = data.azurerm_client_config.current_config.tenant_id
  object_id                      = data.azurerm_client_config.current_config.object_id
  purge_protection_enabled       = var.purge_protection_enabled
  enabled_for_disk_encryption    = var.enabled_for_disk_encryption
  virtual_network_subnet_ids     = var.virtual_network_subnet_ids
  diagnostics_storage_account_id = var.diagnostics_storage_account_id
  retention_policy               = var.retention_policy
}

resource "azurerm_key_vault" "keyvault" {
  name                = local.keyvault_name
  location            = local.location
  resource_group_name = local.resource_group_name
  tenant_id           = local.tenant_id
  sku_name            = local.sku_name
  tags                = local.tags

  soft_delete_retention_days  = local.retention_policy.days
  purge_protection_enabled    = local.purge_protection_enabled
  enabled_for_disk_encryption = local.enabled_for_disk_encryption

  # network_acls {
  #   default_action             = "Deny"
  #   bypass                     = "AzureServices"
  #   virtual_network_subnet_ids = local.virtual_network_subnet_ids
  # }
}


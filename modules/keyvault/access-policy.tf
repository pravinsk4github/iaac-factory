resource "azurerm_key_vault_access_policy" "service_principal" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = local.tenant_id
  object_id    = local.object_id

  key_permissions = [
    "Create",
    "Decrypt",
    "Encrypt",
    "Get",
    "List"
  ]

  secret_permissions = [
    "Get",
    "Set",
    "Delete",
    "List",
    "Purge"
  ]

  storage_permissions = [
    "Get",
    "List",
  ]

  certificate_permissions = [
    "Create",
    "Get",
    "Import",
    "Update"
  ]
}

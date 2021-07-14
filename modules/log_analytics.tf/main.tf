locals {
  location            = var.location
  resource_group_name = var.resource_group_name
  ws_sku              = var.ws_sku
  storage_account_ids = var.storage_account_ids
}

resource "azurerm_log_analytics_workspace" "la_ws" {
  name                = "la-workspace"
  location            = local.location
  resource_group_name = local.name
  sku                 = local.ws_sku
}

resource "azurerm_log_analytics_linked_storage_account" "la_sa" {
  data_source_type      = "customlogs"
  resource_group_name   = local.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.la_ws.id
  storage_account_ids   = local.storage_account_ids
}




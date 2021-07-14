locals {
  location                  = var.location
  resource_group_name       = var.resource_group_name
  net_watcher_name          = var.net_watcher_name
  network_security_group_id = var.network_security_group_id
  storage_account_id        = var.storage_account_id
  flow_log_enabled          = var.flow_log_enabled
  retention_policy          = var.retention_policy
  traffic_analytics         = var.traffic_analytics
}

resource "azurerm_network_watcher" "net_watcher" {
  name                = local.net_watcher_name
  location            = local.location
  resource_group_name = local.resource_group_name
}

resource "azurerm_network_watcher_flow_log" "flow_log" {
  network_watcher_name = local.net_watcher_name
  resource_group_name  = local.resource_group_name

  network_security_group_id = local.network_security_group_id
  storage_account_id        = local.storage_account_id
  enabled                   = local.flow_log_enabled

  retention_policy {
    enabled = local.retention_policy.enabled
    days    = local.retention_policy.days
  }

  traffic_analytics {
    enabled               = local.traffic_analytics.enabled
    workspace_id          = local.traffic_analytics.workspace_id
    workspace_region      = local.location
    workspace_resource_id = local.traffic_analytics.workspace_resource_id
    interval_in_minutes   = local.traffic_analytics.interval_in_minutes
  }
}

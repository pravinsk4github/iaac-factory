resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name               = "diag-${local.keyvault_name}"
  target_resource_id = local.keyvault_id
  storage_account_id = local.diagnostics_storage_account_id

  log {
    category = "AuditEvent"
    enabled  = true
    retention_policy {
      enabled = local.retention_policy.enabled
      days    = local.retention_policy.days
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = local.retention_policy.enabled
      days    = local.retention_policy.days
    }
  }
}

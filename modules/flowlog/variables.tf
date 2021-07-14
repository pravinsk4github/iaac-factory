variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "Location/region"
}

variable "net_watcher_name" {
  type        = string
  default     = "netwatch"
  description = "Name for the network watcher"
}

variable "network_security_group_id" {
  type        = string
  default     = "netwatch"
  description = "Id of the network security group"
}

variable "storage_account_id" {
  type        = string
  default     = "netwatch"
  description = "Id of the diagnostic storage account"
}

variable "flow_log_enabled" {
  type        = bool
  default     = false
  description = "Wheather folow is to enable"
}

variable "retention_policy" {
  default = {
    enabled = true
    days    = 7
  }
  description = "Retention policy for network watcher"
}

variable "traffic_analytics" {
  type = object(
    {
      enabled               = bool,
      workspace_id          = string,
      access_type           = string,
      location              = string,
      workspace_resource_id = string
      interval_in_minutes   = number
  })
  description = "Settings for traffic analytics"
}

variable "global_settings" {
  default = {}
}

variable "storage_account_settings" {
  type = object({
    name         = string
    account_kind = string
    skuname      = string
    access_tier  = string
    delete_retention_policy = object({
      days = number
    })
    allow_blob_public_access = bool
    containers = list(object({
      name        = string
      access_type = string
    }))
  })
}

variable "network_settings" {
  type    = map(any)
  default = {}
}

variable "keyvault_settings" {
  type = object({
    keyvault_name = string
    sku_name      = string
  })
}

variable "web_vm_settings" {
  type = object({
    vmss_name                        = string
    admin_user                       = string
    lbpip_allocation_method          = string
    private_ip_allocation_method     = string
    sku_capacity                     = number
    sku_name                         = string
    sku_tier                         = string
    image_publisher                  = string
    image_sku                        = string
    image_version                    = string
    image_offer                      = string
    admin_user                       = string
    upgrade_policy_mode              = string
    disable_password_authentication  = bool
    data_disk_type                   = string
    data_disk_size_gb                = string
    data_disk_create_option          = string
    delete_os_disk_on_termination    = bool
    delete_data_disks_on_termination = bool
  })
}

variable "web_application_settings" {
  type = object({
    application_port  = number,
    domain_name_label = string
  })
  default = {
    application_port  = 80
    domain_name_label = "webapp"
  }
}

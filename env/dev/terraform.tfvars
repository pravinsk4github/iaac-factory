## Global settings
global_settings = {
  regions = {
    default_region = "northeurope"
  }
  environment = "dev"
  location    = "northeurope"

  tags = {
    application = "iaac-factory"
    environment = "dev"
    product     = "iaac"
  }
}

## Network settings
network_settings = {
  vnets = {
    vnet1 = {
      name          = "dev-vnet1"
      address_space = ["10.0.0.0/16"]
      subnets = {
        # firewall = {
        #   name           = "AzureFirewallSubnet"
        #   address_prefix = "10.0.0.0/27"
        # }
        subnet1 = {
          name           = "dev-subnet1"
          address_prefix = "10.0.1.0/24"
        }
      }
    }
  }
}

## Keyvault settings
keyvault_settings = {
  keyvault_name = "kv"
  sku_name      = "premium"
}

## Web App VM settings
web_vm_settings = {
  vmss_name                        = "webvmss"
  admin_user                       = "vmadmin"
  lbpip_allocation_method          = "Static"
  private_ip_allocation_method     = "dynamic"
  sku_capacity                     = 2
  sku_name                         = "Standard_DS1_v2"
  sku_tier                         = "Standard"
  image_publisher                  = "Canonical"
  image_sku                        = "20_04-lts"
  image_version                    = "latest"
  image_offer                      = "0001-com-ubuntu-server-focal"
  admin_user                       = "vmadmin"
  upgrade_policy_mode              = "Manual"
  data_disk_type                   = "Standard_LRS"
  data_disk_size_gb                = "20"
  data_disk_create_option          = "Empty"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  disable_password_authentication  = false
  fault_domain_count               = 2
  update_domain_count              = 2
  managed_availability_set         = true
  vm_size                          = "Standard_F2"
}

## Storage account settings //common for all storage account, in reality will have separate settings
storage_account_settings = {
  name         = "webappstorage"
  account_kind = "BlobStorage"
  # Account Tier options are Standard and Premium. 
  # For BlockBlobStorage and FileStorage accounts only Premium is valid.
  # Valid redundancy options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS
  skuname     = "Standard_LRS"
  access_tier = "Hot"
  delete_retention_policy = {
    days = 15
  }
  allow_blob_public_access = false
  containers               = [{ name = "appresources", access_type = "private" }]
}

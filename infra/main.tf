#***********************************************************#
# Local variables block                                     #
#***********************************************************#
locals {
  resource_group_name            = data.azurerm_resource_group.resource_group.name
  location                       = data.azurerm_resource_group.resource_group.location
  tags                           = var.global_settings.tags
  admin_password                 = random_string.password.result
  environment                    = var.global_settings.environment
  web_application_settings       = var.web_application_settings
  web_vm_settings                = var.web_vm_settings
  storage_account_settings       = var.storage_account_settings
  keyvault_settings              = var.keyvault_settings
  network_settings               = var.network_settings
  diagnostics_storage_account_id = data.azurerm_storage_account.diagnostics_stacc.id
  subnet1                        = data.azurerm_subnet.subnet1
}

#***********************************************************#
# Resource: Random String                                   #
# Purpose: Generate random string for vm password           #
#***********************************************************#
resource "random_string" "password" {
  length      = 16
  special     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

#***********************************************************#
# Module: Resource Group                                    #
# Purpose: Create resource group for the enviroment         #
#***********************************************************#
# module "resource_group" {
#   source      = "../modules/resource-group"
#   environment = var.global_settings.environment
#   location    = var.global_settings.location
#   postfix     = var.global_settings.location
#   tags        = var.global_settings.tags
# }

#***********************************************************#
# Module: Networking                                        #
# Purpose: Create virtual networks and subnets              #
#***********************************************************#
module "networking" {
  source              = "../modules/networking"
  vnets               = local.network_settings.vnets
  resource_group_name = local.resource_group_name
  location            = local.location
}

#***********************************************************#
# Module: Subnet1 NSG                                       #
# Purpose: Create Network security group for subnet         #
#***********************************************************#
module "subnet1_nsg" {
  source              = "../modules/nsg"
  nsg_name            = "${local.environment}-subnet1-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
}

#***********************************************************#
# Module: WebVMs ASG                                        #
# Purpose: Create application security group for web vms    #
#***********************************************************#
module "webvms_asg" {
  source              = "../modules/asg"
  asg_name            = "${local.environment}-webvms-asg"
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = merge({ "tier" = "web" }, local.tags)
}

#***********************************************************#
# Resource: NSG & ASG association                           #
# Purpose: Apply NSG rules for associated ASG               #
#***********************************************************#
resource "azurerm_subnet_network_security_group_association" "nsg_subnet1" {
  subnet_id                 = local.subnet1.id
  network_security_group_id = module.subnet1_nsg.id

  depends_on = [
    module.networking,
    module.subnet1_nsg
  ]
}

#***********************************************************#
# Module: Diagnostics storage account                       #
# Purpose: Create storage account for diagnostics logs      #
#***********************************************************#
module "diagnostics_stacc" {
  source                  = "../modules/storage-account"
  storage_account_name    = "${local.environment}-diagnostics"
  account_kind            = "StorageV2"
  skuname                 = local.storage_account_settings.skuname
  access_tier             = local.storage_account_settings.access_tier
  delete_retention_policy = local.storage_account_settings.delete_retention_policy
  resource_group_name     = local.resource_group_name
  location                = local.location
  tags                    = local.tags
  containers              = [{ name = "diagnostics", access_type = "private" }]
}

#***********************************************************#
# Module: Storage account                                   #
# Purpose: Create storage for webapp's static contents      #
#***********************************************************#
module "storage_account" {
  source                  = "../modules/storage-account"
  storage_account_name    = "${local.environment}-${local.storage_account_settings.name}"
  account_kind            = local.storage_account_settings.account_kind
  skuname                 = local.storage_account_settings.skuname
  access_tier             = local.storage_account_settings.access_tier
  delete_retention_policy = local.storage_account_settings.delete_retention_policy
  resource_group_name     = local.resource_group_name
  location                = local.location
  tags                    = local.tags
  containers              = local.storage_account_settings.containers
}

#***********************************************************#
# Module: Keyvault                                          #
# Purpose: Create keyvault for storing secret               #
#***********************************************************#
module "keyvault" {
  source                         = "../modules/keyvault"
  keyvault_name                  = "${local.environment}-${local.keyvault_settings.keyvault_name}-${local.location}"
  sku_name                       = local.keyvault_settings.sku_name
  resource_group_name            = local.resource_group_name
  location                       = local.location
  tags                           = local.tags
  diagnostics_storage_account_id = local.diagnostics_storage_account_id
  virtual_network_subnet_ids     = [local.subnet1.id]
  enabled_for_disk_encryption    = true
  purge_protection_enabled       = false
}

#***********************************************************#
# Module: Web VM Scale set                                  #
# Purpose: Create VM scale set for web app hosting          #
#***********************************************************#
module "webappvmss" {
  source                               = "../modules/vmss"
  vmss_name                            = var.web_vm_settings.vmss_name
  resource_group_name                  = local.resource_group_name
  location                             = local.location
  lbpip_allocation_method              = local.web_vm_settings.lbpip_allocation_method
  private_ip_allocation_method         = local.web_vm_settings.private_ip_allocation_method
  sku_capacity                         = local.web_vm_settings.sku_capacity
  sku_name                             = local.web_vm_settings.sku_name
  sku_tier                             = local.web_vm_settings.sku_tier
  admin_user                           = local.web_vm_settings.admin_user
  admin_password                       = local.admin_password
  upgrade_policy_mode                  = local.web_vm_settings.upgrade_policy_mode
  disable_password_authentication      = local.web_vm_settings.disable_password_authentication
  subnet_id                            = local.subnet1.id
  keyvault_id                          = module.keyvault.id
  image_sku                            = local.web_vm_settings.image_sku
  image_publisher                      = local.web_vm_settings.image_publisher
  image_offer                          = local.web_vm_settings.image_offer
  image_version                        = local.web_vm_settings.image_version
  data_disk_create_option              = local.web_vm_settings.data_disk_create_option
  data_disk_size_gb                    = local.web_vm_settings.data_disk_size_gb
  data_disk_type                       = local.web_vm_settings.data_disk_type
  delete_os_disk_on_termination        = local.web_vm_settings.delete_os_disk_on_termination
  delete_data_disks_on_termination     = local.web_vm_settings.delete_data_disks_on_termination
  application_port                     = local.web_application_settings.application_port
  domain_name_label                    = local.web_application_settings.domain_name_label
  boot_diagnostics_storage_account_uri = module.diagnostics_stacc.primary_blob_endpoint
  application_security_group_ids       = [module.webvms_asg.id]

  depends_on = [
    module.networking,
    module.keyvault,
    module.diagnostics_stacc,
    module.webvms_asg
  ]
}

#***********************************************************#
# Module: Jumpbox                                           #
# Purpose: Create jumpbox for VM scale set                  #
# VM access on port 22 will be blocked and only allowed     #
# from jumpbox's private ip (Could use Azure Bastion)       #                                
#***********************************************************#
module "jumpbox" {
  source                               = "../modules/vm"
  vm_name                              = "${local.environment}-jumpbox"
  resource_group_name                  = local.resource_group_name
  location                             = local.location
  admin_user                           = local.web_vm_settings.admin_user
  admin_password                       = local.admin_password
  pip_allocation_method                = local.web_vm_settings.lbpip_allocation_method
  private_ip_allocation_method         = local.web_vm_settings.private_ip_allocation_method
  delete_os_disk_on_termination        = local.web_vm_settings.delete_os_disk_on_termination
  delete_data_disks_on_termination     = local.web_vm_settings.delete_data_disks_on_termination
  data_disk_create_option              = local.web_vm_settings.data_disk_create_option
  data_disk_size_gb                    = local.web_vm_settings.data_disk_size_gb
  data_disk_type                       = local.web_vm_settings.data_disk_type
  image_sku                            = local.web_vm_settings.image_sku
  image_publisher                      = local.web_vm_settings.image_publisher
  image_offer                          = local.web_vm_settings.image_offer
  image_version                        = local.web_vm_settings.image_version
  subnet_id                            = local.subnet1.id
  keyvault_id                          = module.keyvault.id
  boot_diagnostics_storage_account_uri = module.diagnostics_stacc.primary_blob_endpoint
  tags                                 = local.tags

  depends_on = [
    module.networking,
    module.keyvault,
    module.diagnostics_stacc,
  ]
}

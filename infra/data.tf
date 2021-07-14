data "azurerm_resource_group" "resource_group" {
  name = "1-bb6f94b0-playground-sandbox"
  # name = module.resource_group.name
  # depends_on = [
  #   module.resource_group
  # ]
}

data "azurerm_subnet" "subnet1" {
  name                 = local.network_settings.vnets.vnet1.subnets.subnet1.name
  virtual_network_name = local.network_settings.vnets.vnet1.name
  resource_group_name  = local.resource_group_name

  depends_on = [
    module.networking
  ]
}

data "azurerm_network_security_group" "subnet1_nsg" {
  name                = module.subnet1_nsg.name
  resource_group_name = data.azurerm_resource_group.resource_group.name

  depends_on = [
    module.subnet1_nsg
  ]
}

data "azurerm_application_security_group" "webvms_asg" {
  name                = module.webvms_asg.name
  resource_group_name = data.azurerm_resource_group.resource_group.name

  depends_on = [
    module.webvms_asg
  ]
}

data "azurerm_storage_account" "diagnostics_stacc" {
  name                = module.diagnostics_stacc.name
  resource_group_name = local.resource_group_name

  depends_on = [
    module.diagnostics_stacc
  ]
}

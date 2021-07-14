locals {
  vnets               = var.vnets
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  for_each            = local.vnets
  name                = each.value.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = each.value.address_space
  dynamic "subnet" {
    for_each = each.value.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
    }
  }
}

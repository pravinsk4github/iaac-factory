locals {
  asg_name            = var.asg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_application_security_group" "asg" {
  name                = local.asg_name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
}



locals {
  network_security_group_name = data.azurerm_network_security_group.subnet1_nsg.name
}

resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = local.resource_group_name
  network_security_group_name = local.network_security_group_name
}

resource "azurerm_network_security_rule" "http_rule" {
  name                                       = "HTTP"
  priority                                   = 1002
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_ranges                    = [80, 443]
  source_address_prefix                      = "*"
  destination_application_security_group_ids = [data.azurerm_application_security_group.webvms_asg.id]
  resource_group_name                        = local.resource_group_name
  network_security_group_name                = local.network_security_group_name
}

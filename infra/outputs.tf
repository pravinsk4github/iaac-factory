output "resource_group_name" {
  value = data.azurerm_resource_group.resource_group.name
}

# output "jumpbox_public_ip" {
#    value = azurerm_public_ip.jumpbox_pip.fqdn
# }

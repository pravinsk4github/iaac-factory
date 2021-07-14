locals {
  vm_name                          = var.vm_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  allocation_method                = var.pip_allocation_method
  private_ip_allocation_method     = var.private_ip_allocation_method
  vm_size                          = var.vm_size
  image_sku                        = var.image_sku
  image_offer                      = var.image_offer
  image_publisher                  = var.image_publisher
  image_version                    = var.image_version
  admin_user                       = var.admin_user
  admin_password                   = var.admin_password
  disable_password_authentication  = var.disable_password_authentication
  keyvault_id                      = var.keyvault_id
  subnet_id                        = var.subnet_id
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination
  boot_diagnostics_storage_account_uri = var.boot_diagnostics_storage_account_uri
  tags = var.tags
}

resource "azurerm_public_ip" "vm_pip" {
  name                = "${local.vm_name}-pip"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = local.allocation_method
  domain_name_label   = "${local.vm_name}-ssh"
  tags                = local.tags
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "${local.vm_name}-nic"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "${local.vm_name}-ipconfig"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = local.private_ip_allocation_method
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }

  tags = local.tags
}

resource "azurerm_virtual_machine" "vm" {
  name                  = local.vm_name
  location              = local.location
  resource_group_name   = local.resource_group_name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  vm_size               = local.vm_size

  delete_os_disk_on_termination    = local.delete_os_disk_on_termination
  delete_data_disks_on_termination = local.delete_data_disks_on_termination

  storage_image_reference {
    publisher = local.image_publisher
    offer     = local.image_offer
    sku       = local.image_sku
    version   = local.image_version
  }

  storage_os_disk {
    name              = "${local.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = local.vm_name
    admin_username = local.admin_user
    admin_password = local.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = local.disable_password_authentication
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = local.boot_diagnostics_storage_account_uri
  }

  tags = local.tags
}

resource "azurerm_key_vault_secret" "kvs_vmpassword" {
  name         = "${local.vm_name}password"
  value        = local.admin_password
  key_vault_id = local.keyvault_id
}


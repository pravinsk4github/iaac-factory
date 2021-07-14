resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}

resource "azurerm_public_ip" "load_balancer_pip" {
  name                = "${var.load_balancer_name}_pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.lbpip_allocation_method
  domain_name_label   = random_string.fqdn.result
}

resource "azurerm_lb" "load_balancer" {
  name                = var.load_balancer_name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "${var.load_balancer_name}_fpip"
    public_ip_address_id = azurerm_public_ip.load_balancer_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_bap" {
  name            = "${var.load_balancer_name}_bap"
  loadbalancer_id = azurerm_lb.load_balancer.id
}

resource "azurerm_lb_probe" "probe" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.load_balancer.id
  name                = "appprobe"
  port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_bap.id
  probe_id                       = azurerm_lb_probe.probe.id
  frontend_ip_configuration_name = "${var.load_balancer_name}_fpip"
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_security_group" "nic_nsg" {
  name                = "nic_nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "nic_ngs_association" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nic_nsg.id
}

resource "azurerm_availability_set" "availability_set" {
  name                         = "avset"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = var.fault_domain_count
  platform_update_domain_count = var.update_domain_count
  managed                      = var.managed_availability_set
}

resource "random_string" "password" {
  length      = 16
  special     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

locals {
  vmpassword = random_string.password.result
}

resource "azurerm_virtual_machine" "virtual_machine" {
  count                 = var.vm_count
  name                  = "${var.vm_name}${count.index}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  availability_set_id   = azurerm_availability_set.availability_set.id
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  vm_size               = var.vm_size

  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination


  storage_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }

  storage_os_disk {
    name              = "vm${count.index}od${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "datadisk_new_${count.index}"
    managed_disk_type = var.data_disk_type
    create_option     = var.data_disk_create_option
    lun               = 0
    disk_size_gb      = var.data_disk_size_gb
  }

  os_profile {
    computer_name  = "vm${count.index}"
    admin_username = "vmadmin"
    admin_password = local.vmpassword // not needed when ssh key is used
  }

  //in reality, we will use ssh key instead
  os_profile_linux_config {
    disable_password_authentication = false
  }

  #   admin_ssh_key {
  #     username   = "vmadmin"
  #     public_key = file("~/.ssh/id_rsa.pub")
  #   }

  boot_diagnostics {
    enabled     = true
    storage_uri = var.boot_diagnostics_storage_account_uri
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "kvs_vmpassword" {
  name         = "vmpassword"
  value        = local.vmpassword
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

locals {
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  vmss_name                            = var.vmss_name
  sku_capacity                         = var.sku_capacity
  sku_name                             = var.sku_name
  sku_tier                             = var.sku_tier
  private_ip_allocation_method         = var.private_ip_allocation_method
  image_publisher                      = var.image_publisher
  image_sku                            = var.image_sku
  image_offer                          = var.image_offer
  image_version                        = var.image_version
  admin_user                           = var.admin_user
  admin_password                       = var.admin_password
  upgrade_policy_mode                  = var.upgrade_policy_mode
  disable_password_authentication      = var.disable_password_authentication
  subnet_id                            = var.subnet_id
  keyvault_id                          = var.keyvault_id
  data_disk_type                       = var.data_disk_type
  data_disk_size_gb                    = var.data_disk_size_gb
  data_disk_create_option              = var.data_disk_create_option
  delete_os_disk_on_termination        = var.delete_os_disk_on_termination
  delete_data_disks_on_termination     = var.delete_data_disks_on_termination
  boot_diagnostics_storage_account_uri = var.boot_diagnostics_storage_account_uri
  application_port                     = var.application_port
  lbpip_allocation_method              = var.lbpip_allocation_method
  domain_name_label                    = var.domain_name_label
  load_balancer_name                   = "${var.vmss_name}-lb"
  tags                                 = var.tags
  application_security_group_ids       = var.application_security_group_ids
}

resource "random_string" "random" {
  length  = 3
  special = false
  upper   = false
}

resource "azurerm_public_ip" "vmss_lb_pip" {
  name                = "${local.load_balancer_name}-pip"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = local.lbpip_allocation_method
  domain_name_label   = "${local.domain_name_label}-${random_string.random.result}"
  tags                = local.tags
}

resource "azurerm_lb" "vmss_lb" {
  name                = local.load_balancer_name
  location            = local.location
  resource_group_name = local.resource_group_name

  frontend_ip_configuration {
    name                 = "${local.load_balancer_name}-fepip"
    public_ip_address_id = azurerm_public_ip.vmss_lb_pip.id
  }

  tags = local.tags
}

resource "azurerm_lb_probe" "vmss_lb_health_probe" {
  resource_group_name = local.resource_group_name
  loadbalancer_id     = azurerm_lb.vmss_lb.id
  name                = "${azurerm_lb.vmss_lb.name}-health-probe"
  port                = local.application_port
}

resource "azurerm_lb_backend_address_pool" "vmss_lb_bpepool" {
  loadbalancer_id = azurerm_lb.vmss_lb.id
  name            = "${azurerm_lb.vmss_lb.name}-bpepool"
}

resource "azurerm_lb_rule" "lb_nat_rule" {
  resource_group_name            = local.resource_group_name
  loadbalancer_id                = azurerm_lb.vmss_lb.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = local.application_port
  backend_port                   = local.application_port
  backend_address_pool_id        = azurerm_lb_backend_address_pool.vmss_lb_bpepool.id
  frontend_ip_configuration_name = azurerm_lb.vmss_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.vmss_lb_health_probe.id
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = local.vmss_name
  location            = local.location
  resource_group_name = local.resource_group_name
  upgrade_policy_mode = local.upgrade_policy_mode

  sku {
    name     = local.sku_name
    tier     = local.sku_tier
    capacity = local.sku_capacity
  }

  storage_profile_image_reference {
    publisher = local.image_publisher
    offer     = local.image_offer
    sku       = local.image_sku
    version   = local.image_version
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun               = 0
    caching           = "ReadWrite"
    create_option     = local.data_disk_create_option
    disk_size_gb      = local.data_disk_size_gb
    managed_disk_type = local.data_disk_type
  }

  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = local.admin_user
    admin_password       = local.admin_password
    custom_data          = file("web.conf")
  }

  os_profile_linux_config {
    disable_password_authentication = local.disable_password_authentication
  }

  network_profile {
    name    = "${local.vmss_name}-netprofile"
    primary = true

    ip_configuration {
      name                                   = "${local.vmss_name}-ipconfig"
      subnet_id                              = local.subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.vmss_lb_bpepool.id]
      primary                                = true
      application_security_group_ids         = local.application_security_group_ids
    }
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = local.boot_diagnostics_storage_account_uri
  }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 20
    pause_time_between_batches              = "PT0S"
  }

  tags = local.tags
}

resource "azurerm_monitor_autoscale_setting" "autoscale_setting" {
  name                = "autoscale-cpu"
  target_resource_id  = azurerm_virtual_machine_scale_set.vmss.id
  location            = local.location
  resource_group_name = local.resource_group_name

  profile {
    name = "autoscale-cpu"

    capacity {
      default = local.sku_capacity
      minimum = 1
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 15
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}

resource "azurerm_key_vault_secret" "kvs_vmpassword" {
  name         = "${local.vmss_name}password"
  value        = local.admin_password
  key_vault_id = local.keyvault_id
}


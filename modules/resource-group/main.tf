locals {
  environment = var.environment
  postfix     = var.postfix
  tags        = var.tags
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.environment}-rg-${var.postfix}"
  location = var.location
  tags     = var.tags
}

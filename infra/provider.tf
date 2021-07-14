terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.55"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

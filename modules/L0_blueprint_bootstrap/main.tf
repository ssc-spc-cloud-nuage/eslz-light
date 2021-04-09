terraform {
  required_providers {
    azurerm = {
      # https://github.com/terraform-providers/terraform-provider-azurerm
      source  = "hashicorp/azurerm"
      version = "~> 2.54.0"
    }
  }
  required_version = ">= 0.14"
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "current" {}
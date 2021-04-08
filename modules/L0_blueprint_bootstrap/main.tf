terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.46.1"
    }
    # azuread = {
    #   source  = "hashicorp/azuread"
    #   version = "~> 1.3.0"
    # }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 2.2.1"
    # }
    # null = {
    #   source  = "hashicorp/null"
    #   version = "~> 2.1.0"
    # }
    # azurecaf = {
    #   source  = "aztfmod/azurecaf"
    #   version = "~>0.4.3"
    # }
  }
  required_version = ">= 0.14"
}


provider "azurerm" {
  features {}
}

data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "current" {}
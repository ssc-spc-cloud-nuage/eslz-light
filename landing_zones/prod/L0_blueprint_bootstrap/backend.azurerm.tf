terraform {
  backend "azurerm" {
    resource_group_name="ScMc-CIO_ESLZ_Light_launchpad-rg"
    storage_account_name="scmclaunchpadd1d2cf21"
    container_name="statefiles"
    key="L0_blueprint_bootstrap/terraform.tfstate"
  }
}

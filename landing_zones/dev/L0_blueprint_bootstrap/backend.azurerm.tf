terraform {
  backend "azurerm" {
    resource_group_name="ScFc-CIO_ESLZ_light_launchpad-rg"
    storage_account_name="scfclaunchpadc3ab4448"
    container_name="statefiles"
    key="L0_blueprint_bootstrap/terraform.tfstate"
  }
}

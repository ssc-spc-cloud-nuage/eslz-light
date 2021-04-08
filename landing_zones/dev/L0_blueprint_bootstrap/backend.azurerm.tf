terraform {
  backend "azurerm" {
    resource_group_name="ScEc-CIO_ESLZ_light_launchpad-rg"
    storage_account_name="sceclaunchpaddb95f510"
    container_name="statefiles"
    key="L0_blueprint_bootstrap/terraform.tfstate"
  }
}

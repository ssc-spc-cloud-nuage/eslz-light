terraform {
  backend "azurerm" {
    resource_group_name="ScLc-CIO_ESLZ_Light_launchpad-rg"
    storage_account_name="sclclaunchpadd736989a"
    container_name="statefiles"
    key="L0_blueprint_bootstrap/terraform.tfstate"
  }
}

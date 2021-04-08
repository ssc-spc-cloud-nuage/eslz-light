module "launchpad_storage_account" {
  source                   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-storage_account?ref=v1.0.3"
  env                      = var.env
  userDefinedString        = "launchpad"
  resource_group           = module.launchpad_resource_group.object
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "GRS"
  allow_blob_public_access = false
  tags = {
    tfstate     = "launchpad"
    environment = var.env
  }
}

resource "null_resource" "launchpad_storage_account_set_versionning" {
  depends_on = [module.launchpad_storage_account]

  provisioner "local-exec" {
    command     = "${path.module}/scripts/set_versionning.sh"
    interpreter = ["/bin/sh"]
    on_failure  = fail

    environment = {
      RESSOURCE_GROUP_NAME = module.launchpad_storage_account.object.resource_group_name
      STORAGEACCOUNT_NAME  = module.launchpad_storage_account.object.name
    }
  }
}

resource "azurerm_storage_container" "launchpad_statefiles_storage_container" {
  name                  = "statefiles"
  storage_account_name  = module.launchpad_storage_account.object.name
  container_access_type = "private"
}

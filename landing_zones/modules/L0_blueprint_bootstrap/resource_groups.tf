module launchpad_resource_group {
  source            = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-resource_groups?ref=v1.1.0"
  userDefinedString = "${var.group}_${var.project}_launchpad"
  env               = var.env
  location          = var.location
  tags              = var.tags
}

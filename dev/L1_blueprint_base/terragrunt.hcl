locals {
  rscfg = yamldecode(file("/tf/caf/dev/dev.yaml"))
}

remote_state {
  # Disabling since it's causing issues as per 	
  # https://github.com/gruntwork-io/terragrunt/pull/1317#issuecomment-682041007	
  disable_dependency_optimization = true

  backend = "azurerm"
  generate = {
    path      = "backend.azurerm.tf"
    if_exists = "overwrite"
  }
  config = {
    tenant_id       = local.rscfg.remote_state.tenant_id
    subscription_id = local.rscfg.remote_state.subscription_id

    # Data from Rover Launchpad
    resource_group_name  = local.rscfg.remote_state.resource_group_name
    storage_account_name = local.rscfg.remote_state.storage_account_name
    container_name       = local.rscfg.remote_state.container_name

    key = "L1_blueprint_base/terraform.tfstate"
  }
}

terraform {
  source = "/tf/caf/modules/L1_blueprint_base"

  extra_arguments "force_subscription" {
    commands = [
      "init",
      "apply",
      "destroy",
      "refresh",
      "import",
      "plan",
      "taint",
      "untaint",
      "output",
      "refresh",
      "show"
    ]
  }
}
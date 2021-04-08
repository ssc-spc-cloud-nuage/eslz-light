locals {
  rscfg  = yamldecode(file("../remote_state.yaml"))
  config = yamldecode(file("../config.yaml"))
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
  source = "../../../modules/L1_blueprint_base"

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
    env_vars = {
      ARM_TENANT_ID = local.rscfg.remote_state.tenant_id
      # ARM_CLIENT_ID     = dependency.credentials.outputs.client_id
      # ARM_CLIENT_SECRET = dependency.credentials.outputs.client_secret
      ARM_SUBSCRIPTION_ID = local.rscfg.remote_state.subscription_id
    }
  }
}

dependencies {
  paths = ["../L0_blueprint_bootstrap"]
}

inputs = {
  env                    = local.config.common.env
  group                  = local.config.common.group
  project                = local.config.common.project
  location               = local.config.common.location
  tags                   = local.config.common.tags
  deployOptionalFeatures = local.config.L1_blueprint_base.deployOptionalFeatures
  optionalFeaturesConfig = local.config.L1_blueprint_base.optionalFeaturesConfig
  network                = local.config.L1_blueprint_base.network
  Landing-Zone-Next-Hop  = local.config.common.Landing-Zone-Next-Hop
  domain                 = local.config.common.domain
  L1_RBAC                = local.config.L1_blueprint_base.L1_RBAC
  windows_VMs            = local.config.L1_blueprint_base.windows_VMs
}
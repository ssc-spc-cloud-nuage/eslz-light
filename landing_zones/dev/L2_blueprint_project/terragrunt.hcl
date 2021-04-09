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

    key = "L2_blueprint_project/terraform.tfstate"
  }
}

dependencies {
  paths = ["../L1_blueprint_base"]
}

dependency "L1_blueprint_base" {
  config_path = "../L1_blueprint_base"

  # Configure mock outputs for the `validate` command when there are no outputs available
  # This can happen if the dependency hasn't been applied yet
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    prod_organizational_unit_id = ""
  }
}

terraform {
  source = "../../../modules/L2_blueprint_project"

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

inputs = {
  # variables for access to L1 state outputs
  # L1_terraform_remote_state_account_name        = local.rscfg.remote_state.storage_account_name
  # L1_terraform_remote_state_container_name      = local.rscfg.remote_state.container_name
  # L1_terraform_remote_state_key                 = "L1_blueprint_base/terraform.tfstate"
  # L1_terraform_remote_state_resource_group_name = local.rscfg.remote_state.resource_group_name
  L1_blueprint_base_outputs = dependency.L1_blueprint_base.outputs
  domain                    = local.config.common.domain
  env                       = local.config.common.env
  group                     = local.config.common.group
  Landing-Zone-Next-Hop     = local.config.common.Landing-Zone-Next-Hop
  location                  = local.config.common.location
  project                   = local.config.common.project
  tags                      = local.config.common.tags
  RDS-Gateways              = local.config.L2_blueprint_project.RDS-Gateways
  L2_RBAC                   = local.config.L2_blueprint_project.L2_RBAC
  windows_VMs               = local.config.L2_blueprint_project.windows_VMs
}
locals {
  config = yamldecode(file("../config.yaml"))
}

terraform {
  source = "../../../modules/L0_blueprint_bootstrap"

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
      ARM_SUBSCRIPTION_ID = local.config.common.subscription_id
    }
  }
}

inputs = {
  env      = local.config.common.env
  group    = local.config.common.group
  project  = local.config.common.project
  location = local.config.common.location
  tags     = local.config.common.tags
}
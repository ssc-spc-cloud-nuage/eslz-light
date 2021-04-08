locals {
  rscfg = yamldecode(file("../config.yaml"))
}

terraform {
  source = "../../modules/L0_blueprint_bootstrap"

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
      # ARM_TENANT_ID     = local.rscfg.remote_state.tenant_id
      # ARM_CLIENT_ID     = dependency.credentials.outputs.client_id
      # ARM_CLIENT_SECRET = dependency.credentials.outputs.client_secret
      ARM_SUBSCRIPTION_ID = local.rscfg.subscription_id
    }
  }
}
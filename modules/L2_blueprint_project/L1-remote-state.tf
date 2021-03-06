# Reading the L1 terraform state
/*
data "terraform_remote_state" "L1" {
  backend = "azurerm"
  config  = var.L1_terraform_remote_state_config
}
*/

# data "terraform_remote_state" "L1" {
#   backend = "azurerm"
#   config = {
#     storage_account_name = var.L1_terraform_remote_state_account_name
#     container_name       = var.L1_terraform_remote_state_container_name
#     key                  = var.L1_terraform_remote_state_key
#     resource_group_name  = var.L1_terraform_remote_state_resource_group_name
#   }
# }

# Mapping needed outputs from L1 statefile to locals for easy access

# locals {
#   resource_groups_L1           = data.terraform_remote_state.L1.outputs.resource_groups_L1
#   subnets                      = data.terraform_remote_state.L1.outputs.subnets
#   Project-law                  = data.terraform_remote_state.L1.outputs.Project-law
#   Project_law-sa               = data.terraform_remote_state.L1.outputs.Project_law-sa
#   Project-kv                   = data.terraform_remote_state.L1.outputs.Project-kv
#   L2_Subscription_Contributors = data.terraform_remote_state.L1.outputs.L2_Subscription_Contributors
#   L2_Subscription_Readers      = data.terraform_remote_state.L1.outputs.L2_Subscription_Readers
# }

# New method to obtain other blueprint outputs usinf terragrunt depandancy
locals {
  resource_groups_L1           = var.L1_blueprint_base_outputs.resource_groups_L1
  subnets                      = var.L1_blueprint_base_outputs.subnets
  Project-law                  = var.L1_blueprint_base_outputs.Project-law
  Project_law-sa               = var.L1_blueprint_base_outputs.Project_law-sa
  Project-kv                   = var.L1_blueprint_base_outputs.Project-kv
  L2_Subscription_Contributors = var.L1_blueprint_base_outputs.L2_Subscription_Contributors
  L2_Subscription_Readers      = var.L1_blueprint_base_outputs.L2_Subscription_Readers
}
variable "tags" {
  type = any
}

variable "env" {}
variable "group" {}
variable "project" {}

variable "location" {}

variable "Landing-Zone-Next-Hop" {
  type = string
}
variable "RDS-Gateways" {
  type = list(string)
}

variable "domain" {
  type = any
}
variable "L2_RBAC" {
  type = any
}

variable "windows_VMs" {
  type = any
}

# Variables for L1 remote state access

# variable "L1_terraform_remote_state_account_name" {}
# variable "L1_terraform_remote_state_container_name" {}
# variable "L1_terraform_remote_state_key" {}
# variable "L1_terraform_remote_state_resource_group_name" {}

# New method using terragrunt depandancy
variable "L1_blueprint_base_outputs" {
  type = any
}

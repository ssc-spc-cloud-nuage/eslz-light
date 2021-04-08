variable "tags" {}

variable "env" {}
variable "group" {}
variable "project" {}

variable "location" {}

variable "Landing-Zone-Next-Hop" {}
variable "RDS-Gateways" {}

variable "domain" {}
variable "L2_RBAC" {}

variable "windows_VMs" {}

# Variables for L1 remote state access

variable "L1_terraform_remote_state_account_name" {}
variable "L1_terraform_remote_state_container_name" {}
variable "L1_terraform_remote_state_key" {}
variable "L1_terraform_remote_state_resource_group_name" {}

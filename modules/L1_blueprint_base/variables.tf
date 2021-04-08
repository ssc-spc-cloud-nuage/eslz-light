variable "tags" {
  type = any
}

variable "env" {
  type = string
}
variable "group" {
  type = string
}
variable "project" {
  type = string
}

variable "location" {
  type = string
}

variable "deployOptionalFeatures" {
  type = any
}

variable "network" {
  type = any
}
variable "Landing-Zone-Next-Hop" {
  type = string
}

variable "domain" {
  type = any
}

variable "L1_RBAC" {
  type = any
}

variable "optionalFeaturesConfig" {
  type = any
}

variable "windows_VMs" {
  type = any
}

#

# variable lowerlevel_storage_account_name {}
# variable lowerlevel_resource_group_name {}
# variable lowerlevel_container_name {}
# variable lowerlevel_key {}
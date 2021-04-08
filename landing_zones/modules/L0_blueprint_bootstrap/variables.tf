variable location {
  type    = string
  default = "canadacentral"
}
variable "env" {
  type    = string
  default = ""
}
variable "group" {
  type    = string
  default = ""
}
variable "project" {
  type    = string
  default = ""
}

# Do not change the default value to be able to upgrade to the standard launchpad
variable tf_name {
  description = "Name of the terraform state in the blob storage (Does not include the extension .tfstate)"
  default     = "launchpad"
}

variable tags {
  type    = map
  default = {}
}
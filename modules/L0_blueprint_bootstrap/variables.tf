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
variable tags {
  type    = map
  default = {}
}
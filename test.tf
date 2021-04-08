locals {
  update_time = "00:00"
  update_date = substr(time_offset.tomorrow.rfc3339, 0, 10)
  datetime = replace("${local.update_date}T${local.update_time}", "/:/", "-")
}

resource "time_offset" "tomorrow" {
  offset_days = 1
}

output "test" {
  value = local.datetime
}
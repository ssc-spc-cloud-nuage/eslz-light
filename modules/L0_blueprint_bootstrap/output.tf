
# output aad_apps {
#   sensitive = true
#   value     = module.L0_Launchpad.aad_apps
# }

# output global_settings {
#   sensitive = true
#   value     = module.L0_Launchpad.global_settings
# }

# output launchpad_resource_group {
#   sensitive = false
#   value     = module.launchpad_resource_group
# }

# output launchpad_storage_account {
#   sensitive = false
#   value     = module.launchpad_storage_account
# }

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}
  
output "subscription_id" {
  value = data.azurerm_subscription.primary.subscription_id
}

output "resource_group_name" {
  value = module.launchpad_resource_group.name
}

output "storage_account_name" {
  value = module.launchpad_storage_account.name
}

output "storage_account_access_key" {
  sensitive = true
  value = module.launchpad_storage_account.object.primary_access_key
}
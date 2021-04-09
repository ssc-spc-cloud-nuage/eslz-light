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
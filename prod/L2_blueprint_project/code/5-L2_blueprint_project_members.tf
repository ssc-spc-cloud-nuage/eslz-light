data "azuread_users" "L2_Subscription_Contributors" {
  user_principal_names = var.L2_RBAC.contributorNames
}

resource "azuread_group_member" "L2_Subscription_Contributors-Members" {
  for_each = toset(data.azuread_users.L2_Subscription_Contributors.object_ids)

  group_object_id  = local.L2_Subscription_Contributors.id
  member_object_id = each.key
}

data "azuread_service_principal" "L2_Subscription_Contributors-SP_by_names" {
  for_each = toset(var.L2_RBAC.contributorSPNames)

  display_name = each.key
}

# Give access to SP (Enterprise App) to be able to manage resources via AAD group membership
resource "azuread_group_member" "L2_Subscription_Contributors_Service_Principal-Members" {
  for_each = data.azuread_service_principal.L2_Subscription_Contributors-SP_by_names

  group_object_id  = local.L2_Subscription_Contributors.id
  member_object_id = each.value.object_id
}

data "azuread_users" "L2_Subscription_Readers" {
  user_principal_names = var.L2_RBAC.readerNames
}

resource "azuread_group_member" "L2_Subscription_Readers-Members" {
  for_each = toset(data.azuread_users.L2_Subscription_Readers.object_ids)

  group_object_id  = local.L2_Subscription_Readers.id
  member_object_id = each.key
}

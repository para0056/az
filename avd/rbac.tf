
resource "azuread_group" "avd_user_group" {
  display_name     = "avd_user_group"
  security_enabled = true
}

resource "azurerm_role_assignment" "avd_users_assignment" {
  scope              = azurerm_virtual_desktop_application_group.dag.id
  role_definition_id = data.azurerm_role_definition.avd_user.id
  principal_id       = azuread_group.avd_user_group.id

  lifecycle {
    ignore_changes = [ role_definition_id ]
  }
}

resource "azuread_group_member" "avd_users" {
  group_object_id  = azuread_group.avd_user_group.id
  member_object_id = data.azuread_user.avd_user.id
}

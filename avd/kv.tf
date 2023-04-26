resource "azurerm_key_vault" "main" {
  name                = "kv-para0056-${var.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  purge_protection_enabled        = false
  soft_delete_retention_days      = var.key_vault_soft_delete_retention

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = ["0.0.0.0/0"]
    virtual_network_subnet_ids = null
  }
}
resource "azurerm_key_vault_secret" "main" {
  name         = "avd-local-admin"
  value        = random_string.AVD_local_password.result
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault_access_policy.main
  ]
}

resource "azurerm_key_vault_access_policy" "main" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
  ]
  secret_permissions = [
    "Get", "Set", "List", "Delete", "Purge"
  ]
}

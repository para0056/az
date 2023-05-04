# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "ws-${var.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  friendly_name       = "${var.prefix} Workspace"
  description         = "${var.prefix} Workspace"

  tags = var.resource_tags
}

# Create AVD host pool
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  name                     = "${var.prefix}-hp"
  friendly_name            = "${var.prefix} Host Pool"
  validate_environment     = true
  custom_rdp_properties    = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1"
  description              = "${var.prefix} Terraform HostPool"
  type                     = "Pooled"
  maximum_sessions_allowed = 1
  load_balancer_type       = "DepthFirst" #[BreadthFirst DepthFirst]
  start_vm_on_connect      = true

  lifecycle {
    ignore_changes = [custom_rdp_properties]
  }
}

# Used to get current date + 29 days
resource "time_rotating" "main" {
  rotation_days = 29
}

# Create Registration Info and set to expire 29 days from current date
resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
  expiration_date = time_rotating.main.rotation_rfc3339
}

# Create AVD Desktop Application Group
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = azurerm_resource_group.main.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  location            = azurerm_resource_group.main.location
  type                = "Desktop"
  name                = "dag-${var.prefix}"
  friendly_name       = "Desktop AppGroup"
  description         = "AVD application group"
  depends_on          = [azurerm_virtual_desktop_host_pool.hostpool, azurerm_virtual_desktop_workspace.workspace]

  tags = var.resource_tags
}

# Associate Workspace and DAG
resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id

}

locals {
  registration_token = azurerm_virtual_desktop_host_pool_registration_info.registrationinfo.token
}

# Generate random password for local admin password
resource "random_string" "AVD_local_password" {
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

# Create NIC and place in AVD subnet
resource "azurerm_network_interface" "avd_vm_nic" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "nicconfig"
    subnet_id                     = data.azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.resource_tags
}

# Create Windows 11 VM
resource "azurerm_windows_virtual_machine" "avd_vm" {
  name                  = "vm-${var.prefix}"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.avd_vm_nic.id]
  provision_vm_agent    = true
  admin_username        = var.local_admin_username
  admin_password        = random_string.AVD_local_password.result
  boot_diagnostics {}
  identity {
    type = "SystemAssigned"
  }
  os_disk {
    name                 = "disk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-22h2-avd"
    version   = "latest"
  }

  tags = var.resource_tags
}

# Add AVD agent and configure to join the host pool
resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  name                       = "${var.prefix}-avd_dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.hostpool.name}",
        "aadJoin": true
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${local.registration_token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_desktop_host_pool.hostpool
  ]

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }
}

# Automatically join VM to Azure AD
resource "azurerm_virtual_machine_extension" "aad-join" {

  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  depends_on = [
    azurerm_virtual_machine_extension.vmext_dsc
  ]
}


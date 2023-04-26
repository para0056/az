data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "main" {
  name     = var.rg_name
  location = var.resource_group_location
}
resource "azurerm_monitor_action_group" "main" {
  name                = "budget-action-group"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "budgetag"
}


resource "azurerm_consumption_budget_subscription" "main" {
  name            = "default-budget"
  subscription_id = data.azurerm_subscription.current.id

  amount     = 75
  time_grain = "Monthly"

  time_period {
    start_date = "2023-04-01T00:00:00Z"
  }

  notification {
    enabled   = true
    threshold = 90.0
    operator  = "EqualTo"

    contact_emails = [
      "nick+az@nparadis.ca",
    ]

    contact_groups = [
      azurerm_monitor_action_group.main.id,
    ]

    contact_roles = [
      "Owner",
    ]
  }

  notification {
    enabled        = false
    threshold      = 100.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"

    contact_emails = [
      "nick+az@nparadis.ca",
    ]
  }
  }
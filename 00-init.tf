terraform {
  required_version                  = ">= 0.11.0"
  backend "azurerm" {}
}

provider "azurerm" {
  version                           = ">=1.24.0"
  subscription_id                   = "${var.subscription_id}"
}

# Additional Providers Required to access to different Subscriptons within HMCTS Account


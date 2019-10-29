terraform {
  required_version                  = ">= 0.11.0"
  backend "azurerm" {}
}

provider "azurerm" {
  version                           = ">=1.24.0"
  subscription_id                   = "${var.subscription_id}"
}

# Additional Providers Required to access to different Subscriptons within HMCTS Account


provider "azurerm" {
  alias                             = "dcd-cftapps-sbox"
  version                           = ">=1.24.0"
  subscription_id                   = "b72ab7b7-723f-4b18-b6f6-03b0f2c6a1bb"
}
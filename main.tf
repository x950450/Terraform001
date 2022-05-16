provider "azurerm" {
  features {}

  subscription_id = "${ secrets.subscription_id }"
  client_id       = "${ secrets.client_id }"
  client_secret   = "${ secrets.client_secret }"
  tenant_id       = "${ secrets.tenant_id }"
}

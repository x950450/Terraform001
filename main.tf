provider "azurerm" {
  features {}

  subscription_id = "${subscription_id}"
  client_id       = "${client_id}"
  client_secret   = "${client_secret}"
  tenant_id       = "${tenant_id}"
}

# Configure the provider
provider "azurerm" {
    version = "=1.34.0"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Create a new resource group
resource "azurerm_resource_group" "rg" {
    name     = "TF-ResourceGroup-${random_integer.ri.result}"
    location = "australiaeast"
}
# Configure the Azure provider
terraform {
  backend "azurerm" {
    resource_group_name   = "tstate"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  version = ">= 2.26"
  features {}
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
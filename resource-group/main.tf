# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
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
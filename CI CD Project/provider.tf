terraform {
  required_providers {
    azuredevops = {
      source = "XenitAB/azuredevops"
      version = "0.3.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "4aff0984-efd7-4b54-9564-652d0338fa3a"
  client_id       = "af4a58c9-56a1-4830-892c-4f0e45b5bf03"
  //client_id = var.client_id
}

module "AKSCluster" {
  source = "../aksmodule"
}



resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.region
  //value="justforfun"
}

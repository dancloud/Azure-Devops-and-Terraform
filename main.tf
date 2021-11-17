terraform {
  required_version = ">= 1.0.9, < 1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.85.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "shared"
    storage_account_name = "sharedsa"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

variable "imagebuild" {
  type = string
  description = "Latest Image Build"
}

resource "azurerm_resource_group" "tf_test" {
  name     = "tfmainrg"
  location = "eastus"
}

resource "azurerm_container_group" "tfcg_test" {
  name                = "weatherapi"
  location            = azurerm_resource_group.tf_test.location
  resource_group_name = azurerm_resource_group.tf_test.name

  ip_address_type = "public"
  dns_name_label  = "dancloudwa"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "dancloud/weatherapi:${var.imagebuild}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

}
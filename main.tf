terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

module "resource-group" {
  source = "git::https://github.com/koala1707/terraform_modules.git//modules/resource-group"
  location = var.location
  name = "${local.prefix}-rg"
}

module "app-service-plan" {
  source = "git::https://github.com/koala1707/terraform_modules.git//modules/app-service"
  azurerm_service_plan = {
    name = "${local.prefix}-asp"
    sku = "F1"
  }
  resource_group_name = module.resource-group.name
  location = var.location
}

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
  source = "git::https://github.com/koala1707/terraform_modules.git//modules/app-service-plan"
  name = "${local.prefix}-asp"
  resource_group_name = module.resource-group.name
  sku = "F1"
  location = var.location
}

module "web-app" {
  source = "git::https://github.com/koala1707/terraform_modules.git//modules/web-app"
  webapp_name = "${local.prefix}-webApp"
  resource_group_name = module.resource-group.name
  asp_location = module.app-service-plan.location
  asp_id = module.app-service-plan.id
  env = var.env
  project_name = local.prefix
}

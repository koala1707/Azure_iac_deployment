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

module "resource_group" {
  source = "git::https://github.com/koala1707/terraform_modules.git//modules/resource_group"
  location = var.location
  name = "${local.prefix}-rg-${var.env}"
}

module "app_service_plan" {
  source = "git::https://github.com/koala1707/terraform_modules.git//modules/app_service_plan"
  name = "${local.prefix}-asp-${var.env}"
  resource_group_name = module.resource_group.name
  sku = "F1"
  location = var.location
}

module "web_app" {
  source = "git::https://github.com/koala1707/terraform_modules.git//modules/web_app"
  webapp_name = "${local.prefix}-webapp-${var.env}"
  resource_group_name = module.resource_group.name
  asp_location = module.app_service_plan.location
  asp_id = module.app_service_plan.id
  env = var.env
  project_name = local.prefix
}

module "storage_account" {
  source = "git::https://github.com/koala1707/terraform_modules.git//modules/storage_account?ref=feature/storage-account-module"
  storage_account_name = "${local.prefix}st"
  resource_group_name = module.resource_group.name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  env = "dev"
  min_tls_version = "TLS1_2"
}

module "storage_container" {
  source =  "git::https://github.com/koala1707/terraform_modules.git//modules/storage_container?ref=feature/storage-account-module"
  storage_account_name = module.storage_account.storage_account_name
  name = "${local.prefix}"
  storage_account_id = module.storage_account.storage_account_id

}
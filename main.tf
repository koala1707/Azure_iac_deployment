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

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "primary" {}

module "resource_group" {
  source = "git::https://github.com/koala1707/terraform_modules.git//resource_group?ref=feature/diagnostic-setting-module"
  location = var.location
  name = "rg-${local.workload}-${var.env}-${var.region}"
}

module "app_service_plan" {
  source = "git::https://github.com/koala1707/terraform_modules.git//app_service_plan?ref=feature/diagnostic-setting-module"
  name = "asp-${local.workload}-${var.env}-${var.region}"
  resource_group_name = module.resource_group.name
  sku = "F1"
  location = var.location
}

module "web_app" {
  source = "git::https://github.com/koala1707/terraform_modules.git//web_app?ref=feature/diagnostic-setting-module"
  webapp_name = "webapp-${local.workload}-${var.env}-${var.region}"
  resource_group_name = module.resource_group.name
  asp_location = module.app_service_plan.location
  asp_id = module.app_service_plan.id
  env = var.env
  project_name = local.workload
}

module "storage_account" {
  source = "git::https://github.com/koala1707/terraform_modules.git//storage_account?ref=feature/diagnostic-setting-module"
  storage_account_name = "st${local.workload}${var.env}${var.region}"
  resource_group_name = module.resource_group.name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  env = "dev"
  min_tls_version = "TLS1_2"
}

module "storage_container" {
  source =  "git::https://github.com/koala1707/terraform_modules.git//storage_container?ref=feature/diagnostic-setting-module"
  storage_account_name = module.storage_account.storage_account_name
  name = local.workload
  storage_account_id = module.storage_account.storage_account_id
}

module "diagnostic_webapp" {
  source = "git::https://github.com/koala1707/terraform_modules.git//diagnostic_setting"
  name = "diag-${local.workload}-${var.env}-${var.region}"
  target_resource_id = module.web_app.webapp_id
  storage_account_id = module.storage_account.storage_account_id
  log_categories = local.app_service_log_categories
}

module "key_vault" {
  source = "git::https://github.com/koala1707/terraform_modules.git//key_vault?ref=feature/key-vault-module"
  name = "kv-${local.workload}-${var.env}-${var.region}"
  location = var.location
  resource_group_name = module.resource_group.name
  tenant_id = var.tenant_id
  object_id = module.web_app.webapp_id
}

module "terraform_rbac" {
  source = "git::https://github.com/koala1707/terraform_modules.git//role_assignment?ref=feature/key-vault-module"
  scope = data.azurerm_subscription.primary.id
  role_definition = "Contributor"
  principal_id = data.azurerm_client_config.current.object_id
}

module "webapp_rbac" {
  source = "git::https://github.com/koala1707/terraform_modules.git//role_assignment?ref=feature/key-vault-module"
  scope = module.key_vault.id
  role_definition = "Key Vault Secrets User"
  principal_id = module.web_app.identity.principal_id
}
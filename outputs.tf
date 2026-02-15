output "web_app_url" {
  description = "URL to access the deployed web application"
  value       = "https://${module.web_app.default_hostname}"
}

output "web_app_name" {
  description = "Name of the Web App"
  value       = module.web_app.webapp_name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.name
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault (use in app configuration)"
  value       = module.key_vault.vault_uri
}

output "storage_account_name" {
  description = "Name of the Storage Account (stores diagnostic logs)"
  value       = module.storage_account.storage_account_name
}

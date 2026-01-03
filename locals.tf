locals {
  prefix = var.project_name

  app_service_log_categories = [
    "AppServiceHTTPLogs",
    "AppServiceConsoleLogs",
    "AppServiceAppLogs",
    "AppServiceAuditLogs",
    "AppServicePlatformLogs",
    "AppServiceAuthenticationLogs"
  ]
}
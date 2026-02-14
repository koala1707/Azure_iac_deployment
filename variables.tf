variable "env" {
  type = string
  description = "environment of the stage of the service"
}

variable "location" {
  type = string
  description = "location of the service"
}

variable "project_name" {
  type = string
  default = "iacdeployment"
  description = "name of the project"
}

variable "tenant_id" {
  type = string
  description = "id of the tenant"
}

variable "region" {
  type = string
  description = "region of the resource"
  default = "aue"
}
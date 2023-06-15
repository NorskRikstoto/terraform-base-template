variable "environment" {
    type = string
}

variable "service_name" {
    type = string
    default = "${{ values.shortname }}"
}

variable "location" {
    type = string
    default = "Norway East"
}

output "service_principal_client_id" {
  description = "value"
  value = azuread_application.azuread_application.application_id
}
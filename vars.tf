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

output "service_principal_client_secret" {
  description = "Obfuscate this password with Rikstoto.Obfuscator, and add as client secret in the application configuration in Octopus deploy"
  value = azuread_application_password.app_password.value
  sensitive = true
}

output "service_principal_client_id" {
  description = "value"
  value = azuread_application.azuread_application.application_id
}
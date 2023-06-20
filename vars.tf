variable "environment" {
    type = string
}

variable "service_name" {
    type = string
    default = "${{ shortname }}"
}

variable "location" {
    type = string
    default = "Norway East"
}

output "service_principal_client_secret" {
  description = "Obfuscate this password with Rikstoto.Obfuscator, and add as client secret in the application configuration in Octopus deploy. This is used by dom setupazure"
  value = azuread_application_password.app_password.value
  sensitive = true
}

output "service_principal_client_id" {
  description = "This is used by dom setupazure"
  value = azuread_application.azuread_application.application_id
}
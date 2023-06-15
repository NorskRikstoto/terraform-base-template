terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.47.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "=2.36.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}

data "azurerm_client_config" "current" {
}

locals {
  name_prefix = "nr${var.environment}${var.service_name}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}rg"
  location = var.location
}

resource "azuread_application" "azuread_application" {
  display_name = "${local.name_prefix}service"
}

resource "azuread_service_principal" "service_principal" {
  application_id = azuread_application.azuread_application.application_id
  tags           = ["${{ shortname }}"]
}

resource "azuread_application_password" "app_password" {
  application_object_id = azuread_application.azuread_application.object_id
  end_date              = "2099-01-01T01:02:03Z"
}

resource "azurerm_key_vault" "service_keyvault" {
  name                = "${local.name_prefix}kv"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "service_principal_keyvault_access_policy" {
  key_vault_id = azurerm_key_vault.service_keyvault.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azuread_service_principal.service_principal.id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey",
    "Sign",
    "Verify",
    "List",
    "GetRotationPolicy",
		"SetRotationPolicy"
  ]

  secret_permissions = [
    "Get",
    "Backup",
    "Delete",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]
}

resource "azurerm_key_vault_access_policy" "terraform_user_keyvault_access_policy" {
  key_vault_id = azurerm_key_vault.service_keyvault.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
    "Create",
    "Delete",
    "GetRotationPolicy",
		"SetRotationPolicy"
  ]

  secret_permissions = [
    "Get",
    "Set",
    "Delete"
  ]
}
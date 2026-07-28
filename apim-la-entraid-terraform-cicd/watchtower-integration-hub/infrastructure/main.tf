terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "watchtower" {
  name     = "rg-watchtower-${random_string.suffix.result}"
  location = var.location
  tags = {
    Project   = "Watchtower Integration Hub"
    Theme     = "DC Comics Justice League"
  }
}

# ===== 1. MICROSOFT ENTRA ID =====
# Create App Registration for API Management
resource "azuread_application" "watchtower_api" {
  display_name = "Watchtower-API-Gateway-${random_string.suffix.result}"
  
  api {
    oauth2_permission_scope {
      admin_consent_description  = "Allow access to Watchtower APIs"
      admin_consent_display_name = "Watchtower API Access"
      enabled                    = true
      id                         = "00000000-0000-0000-0000-000000000001"
      type                       = "User"
      user_consent_description   = "Access Watchtower APIs"
      user_consent_display_name  = "Watchtower API Access"
      value                      = "api_access"
    }
  }
  
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }
}

resource "azuread_application_password" "watchtower_api" {
  application_id = azuread_application.watchtower_api.id
}

# ===== 2. AZURE API MANAGEMENT =====
resource "azurerm_api_management" "watchtower" {
  name                = "apim-watchtower-${random_string.suffix.result}"
  location            = azurerm_resource_group.watchtower.location
  resource_group_name = azurerm_resource_group.watchtower.name
  publisher_name      = "Justice League Watchtower"
  publisher_email     = "admin@watchtower.justiceleague"
  
  sku_name = "Developer_1"
  
  identity {
    type = "SystemAssigned"
  }
}

# ===== 3. LOGIC APPS (Consumption Plan) =====
resource "azurerm_storage_account" "logicapps" {
  name                     = "stwatchtower${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.watchtower.name
  location                 = azurerm_resource_group.watchtower.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Gotham City Police Integration
resource "azurerm_logic_app_workflow" "gotham_patrol" {
  name                = "logic-gotham-patrol-${random_string.suffix.result}"
  location            = azurerm_resource_group.watchtower.location
  resource_group_name = azurerm_resource_group.watchtower.name
  
  # This would contain the actual workflow definition
}

# ===== 4. AZURE KEY VAULT =====
resource "azurerm_key_vault" "watchtower" {
  name                = "kv-watchtower-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.watchtower.name
  location            = azurerm_resource_group.watchtower.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

# ===== OUTPUTS =====
output "api_management_url" {
  value = "https://${azurerm_api_management.watchtower.name}.azure-api.net"
}

output "key_vault_id" {
  value = azurerm_key_vault.watchtower.id
}
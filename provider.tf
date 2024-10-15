terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.7"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "2.0.0-preview3"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.14.0"
    }
  }
  # only being used for testing purposes. delete when ready to be used in the Enterprise environment.
  backend "azurerm" {

  }
}



provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azuread" {
  tenant_id = data.azurerm_client_config.current.tenant_id
}

provider "azapi" {
  tenant_id = data.azurerm_client_config.current.tenant_id
  use_msi   = false
  use_cli   = true
}

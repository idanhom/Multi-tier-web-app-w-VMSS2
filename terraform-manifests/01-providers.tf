# Terraform Block
terraform {

  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
  features {}
}

resource "random_string" "random_string" {
  length  = 4
  special = false
  upper   = false
}
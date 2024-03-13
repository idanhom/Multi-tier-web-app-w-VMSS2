variable "business_unit" {
  description = "Business Unit Name"
  type        = string
  default     = "hr"
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  default     = "myrg"
  description = "Resource Group Name"
}

variable "resource_group_location" {
  type        = string
  default     = "northeurope"
  description = "Resource Group Location"
}

variable "virtual_network_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "myvnet"
}


variable "vnet_address_space" {
  description = "Virtual Network address_space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

#add into code
variable "web_subnet_address" {
  description = "Virtual Network Web Subnet Address Spaces"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# App Subnet Address Space
variable "backend_subnet_address" {
  description = "Virtual Network App Subnet Address Spaces"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

# Database Subnet Address Space
variable "bastion_subnet_address" {
  description = "Virtual Network Database Subnet Address Spaces"
  type        = list(string)
  default     = ["10.0.100.0/24"]
}

variable "ag_subnet_address" {
  description = "Virtual Network Application Gateway Subnet Address Spaces"
  type        = list(string)
  default     = ["10.0.51.0/24"]
}
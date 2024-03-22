locals {
  rg_name   = "${var.business_unit}-${var.environment}-${var.resource_group_name}"
  websubnet_name = "${var.business_unit}-${var.environment}-${var.resource_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  resource_name_prefix = "${var.business_unit}-${var.environment}"
}

# Mapping of inbound ports for web tier - maps external ports to internal service ports
locals {
  web_inbound_ports_map = {
    "100" : "80"   # HTTP
    "110" : "443"  # HTTPS
    "120" : "22"   # SSH
  }
}

# Mapping of inbound ports for application tier - maps external ports to internal application ports
locals {
  app_inbound_ports_map = {
    "100" : "80",   # HTTP
    "110" : "443",  # HTTPS
    "120" : "8080", # Alternative HTTP
    "130" : "22"    # SSH
  } 
}

# Mapping of inbound ports for database tier - maps external ports to internal database ports
locals {
  db_inbound_ports_map = {
    "100" : "3306", # MySQL
    "110" : "1433", # MS SQL
    "120" : "5432"  # PostgreSQL
  } 
}
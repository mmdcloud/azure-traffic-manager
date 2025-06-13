resource "azurerm_traffic_manager_profile" "profile" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  traffic_routing_method = var.traffic_routing_method

  dns_config {
    relative_name = var.dns_relative_name
    ttl           = var.dns_ttl
  }

  monitor_config {
    protocol                     = var.monitor_config_protocol
    port                         = var.monitor_config_port
    path                         = var.monitor_config_path
    interval_in_seconds          = var.monitor_config_interval_in_seconds
    timeout_in_seconds           = var.monitor_config_timeout_in_seconds
    tolerated_number_of_failures = var.monitor_config_tolerated_number_of_failures
  }
}

# Add endpoints to Traffic Manager
resource "azurerm_traffic_manager_azure_endpoint" "eastus" {
  count              = length(var.endpoints)
  name               = var.endpoints[count.index].name
  profile_id         = azurerm_traffic_manager_profile.profile.id
  target_resource_id = var.endpoints[count.index].target_resource_id
  weight             = var.endpoints[count.index].weight
}

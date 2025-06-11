# Output the Traffic Manager FQDN
output "traffic_manager_fqdn" {
  value = azurerm_traffic_manager_profile.example.fqdn
}

output "eastus_web_ip" {
  value = azurerm_public_ip.eastus.ip_address
}

output "westeurope_web_ip" {
  value = azurerm_public_ip.westeurope.ip_address
}

output "southeastasia_web_ip" {
  value = azurerm_public_ip.southeastasia.ip_address
}
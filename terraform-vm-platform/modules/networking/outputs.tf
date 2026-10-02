output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}

output "subnet_id" {
  value = data.azurerm_subnet.subnet.id
}

output "vnet_id" {
  value = data.azurerm_virtual_network.vnet.id
}
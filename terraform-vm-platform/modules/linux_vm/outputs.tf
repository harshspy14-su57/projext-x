output "vm_id" {
  value = azurerm_linux_virtual_machine.linux_vm.id
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.linux_vm.name
}

output "nic_id" {
  value = azurerm_network_interface.nic.id
}
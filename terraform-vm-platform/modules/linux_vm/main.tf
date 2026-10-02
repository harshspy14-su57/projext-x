# Modules should expose outputs and consume inputs, not directly reference other modules.


resource "azurerm_network_interface" "nic" {
    name = var.nic_name
    location = var.location
    resource_group_name = var.rg_name
    ip_configuration {
        name = var.nic_name
        subnet_id = var.subnet_id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
    name = var.vm_name
    resource_group_name = var.rg_name
    location = var.location
    size = var.vm_size
    admin_username = var.admin_username
    network_interface_ids = [azurerm_network_interface.nic.id,]
    
    admin_ssh_key {
        username   = var.admin_username
        public_key = file(var.public_key)
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = var.publisher
        offer = var.offer
        sku = var.sku
        version = var.image_version
    }
}

# NOTE:
# Terraform modules should remain independent and reusable.
# Child modules should not directly reference other modules.
# Instead, modules expose required values through outputs and
# consume values through input variables.
#
# Example:
# Networking Module -> output "subnet_id"
# Root Module       -> subnet_id = module.networking.subnet_id
# VM Module         -> variable "subnet_id"
#
# This keeps modules loosely coupled and allows them to be reused
# in different environments without modification.
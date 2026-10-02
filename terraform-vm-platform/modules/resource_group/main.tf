# resource initilization will be like [resource <RESOURCE TYPE> <Local_NAME> {...}]

resource "azurerm_resource_group" "RG"{
    name = var.rg_name
    location = var.location
}
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rg_name
}

#resource "azurerm_virtual_network" "vnet" {
#    name = var.vnet_name
#    location = var.location
#    resource_group_name = var.rg_name
#    address_space = var.address_space
#}

data "azurerm_virtual_network" "vnet" {
    name = var.vnet_name
    resource_group_name = var.vnet_rg_name
}

data "azurerm_subnet" "subnet" {
    name = var.subnet_name
    virtual_network_name = data.azurerm_virtual_network.vnet.name
    resource_group_name = var.vnet_rg_name
}

# NOTE:
# VNET and Subnet are not created by this module.
# In our environment, network resources are typically provisioned and managed
# separately by the networking team. During VM deployment, an existing VNET
# and Subnet are referenced using Terraform data sources.
#
# Use 'resource' blocks only when a new network needs to be provisioned.
# Use 'data' blocks when consuming an existing VNET/Subnet, which is the
# standard workflow for most VM deployments.
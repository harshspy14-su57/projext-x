terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 3.0"
        }
    }
}

provider "azurerm" {
    features{}
}

module "resource_group" {
    source = "../../modules/resource_group"
    rg_name = "HPG-RG-000001"
    location = "Central India"
}

module "network_creation" {
    source = "../../modules/networking"
    nsg_name = "HPG-NSG-00001"
# Taking Location and Resource Group Name from previous module
    rg_name = module.resource_group.resource_group_name
    location = module.resource_group.resource_group_location
    vnet_name = "HPG-VNET-00001"
    vnet_rg_name = "rg-networking-shared"
    subnet_name  = "HPG-SUBNET-00001"
}

module "linux_vm_creation" {
    source = "../../modules/linux_vm"
    nic_name = "HPG-NIC-00001"
    location = module.resource_group.resource_group_location
    rg_name = module.resource_group.resource_group_name
    vm_name = "HPG0000000001"
    vm_size = "Standard_B2ats_v2"
    admin_username = "LAHPG0000000001"
    public_key = file("${path.module}/../../ssh-keys/terraform-vm-platforssh-keys.pub")
    publisher = "microsoftazurelinux"
    offer = "azurelinux-4"
    sku = "4"
    subnet_id = module.network_creation.subnet_id
}


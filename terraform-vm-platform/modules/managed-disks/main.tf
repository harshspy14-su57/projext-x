resource "azurerm_managed_disk" "disk" {

    for_each = {
        for idx, disk in var.data_disks :
        idx => disk
    }

    name                 = "${var.vm_name}-datadisk-${each.key}"
    location             = var.location
    resource_group_name  = var.rg_name

    storage_account_type = each.value.storage_account_type
    create_option        = "Empty"
    disk_size_gb         = each.value.size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "attachment" {
    for_each = {
        for idx, disk in var.data_disks :
        idx => disk
    }
    managed_disk_id    = azurerm_managed_disk.disk[each.key].id
    virtual_machine_id = var.vm_id
    lun     = each.value.lun
    caching = "ReadWrite"
}

# NOTE:
# This module supports zero or more managed data disks using for_each.
# If data_disks is empty, no disks are created.
# Additional disks can be added by extending the data_disks variable
# without modifying the module code.
#
# Rule of Thumb
# Need multiple nested blocks inside one resource? → dynamic
# Need an optional resource? → count or for_each
# Need 0 to N data disks? → for_each is the cleanest solution
# Need multiple resources? → for_each
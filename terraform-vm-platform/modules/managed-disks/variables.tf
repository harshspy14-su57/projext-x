variable "data_disks" {
  description = "Additional data disks to attach to the VM"

  type = list(object({
    size_gb              = number
    storage_account_type = string
    lun                  = number
  }))

  default = []
}

variable "vm_name" {
    type = string
}
variable "location" {
    type = string
}
variable "rg_name" {
    type = string
}
variable "storage_account_type" {
    type = string
}
variable "disk_size" {
    type = number
}
variable "vm_id" {
    type = string
}
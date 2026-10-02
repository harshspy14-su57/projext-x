variable "nic_name" {
    type = string
}
variable "location" {
    type = string
}
variable "vm_name" {
    type = string
}
variable "rg_name" {
    type = string
}
variable "vm_size" {
    type = string
    default = "standard_b2ats_v2"
}
variable "admin_username" {
    type = string
}
variable "public_key" {
    type = string
}
variable "publisher" {
    type = string
}
variable "offer" {
    type = string
}
variable "sku" {
    type = string
}
variable "image_version" {
    type = string
    default = "latest"
}
variable "subnet_id" {
    type = string
}
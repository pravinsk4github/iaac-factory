variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "Location/region"
}

variable "pip_allocation_method" {
  type        = string
  default     = "Static"
  description = "IP allotation method"
}

variable "private_ip_allocation_method" {
  type        = string
  default     = "dynamic"
  description = "IP allotation method"
}

variable "vm_name" {
  type        = string
  default     = "vm"
  description = "Name for the virtual machine"
}

variable "vm_size" {
  type        = string
  default     = "Standard_F2"
  description = "Size of the virtual machine"
}

variable "delete_os_disk_on_termination" {
  type        = bool
  default     = true
  description = "Wheather to delete os disk on deteting vm"
}

variable "delete_data_disks_on_termination" {
  type        = bool
  default     = false
  description = "Wheather to delete data disk on deteting vm"
}

variable "disable_password_authentication" {
  type        = bool
  default     = true
  description = "Wheather to disable password authentication"
}

variable "data_disk_create_option" {
  type        = string
  default     = "Empty"
  description = "Data disk creation option"
}

variable "data_disk_size_gb" {
  type        = string
  default     = "1023"
  description = "Data disk size"
}

variable "data_disk_type" {
  type        = string
  default     = "Standard_LRS"
  description = "Data disk type"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for resources"
}

variable "admin_user" {
  type        = string
  description = "Virtual machine admin user name"
}

variable "admin_password" {
  type        = string
  description = "Virtual machine admin user password"
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for vm"
}

variable "image_publisher" {
  type        = string
  description = "Virtual machine publisher"
}

variable "image_offer" {
  type        = string
  description = "Virtual machine offer"
}

variable "image_sku" {
  type        = string
  default     = "18.04-LTS"
  description = "Virtual machine sku"
}

variable "image_version" {
  type        = string
  description = "Virtual machine os version"
  default     = "latest"
}

variable "boot_diagnostics_storage_account_uri" {
  type        = string
  description = "Storage account primary blob endpoint for boot diagnostics"
}

variable "keyvault_id" {
  type        = string
  default     = "vm"
  description = "Id for the key vault"
}

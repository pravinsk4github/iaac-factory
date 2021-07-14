variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "Location/region"
}

variable "load_balancer_name" {
  type        = string
  default     = "lb"
  description = "Name of the load balancer"
}

variable "lbpip_allocation_method" {
  type        = string
  default     = "Static"
  description = "IP allotation method"
}

variable "vm_count" {
  type        = number
  default     = 2
  description = "Number of virtual machines in the cluster"
}

variable "fault_domain_count" {
  type        = number
  default     = 2
  description = "Number of fault domains"
}

variable "update_domain_count" {
  type        = number
  default     = 2
  description = "Number of update domains"
}

variable "managed_availability_set" {
  type        = bool
  default     = true
  description = "Wheather availability set is managed or not"
}

variable "vm_name" {
  type        = string
  default     = "vm"
  description = "Name for the virtual machine"
}

variable "vm_size" {
  type        = string
  default     = "Standard_DS1_v2"
  description = "Size of the virtual machine"
}

variable "delete_os_disk_on_termination" {
  type        = bool
  default     = false
  description = "Wheather to delete os disk on deteting vm"
}

variable "delete_data_disks_on_termination" {
  type        = bool
  default     = false
  description = "Wheather to delete data disk on deteting vm"
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

variable "subnet_id" {
  type        = string
  description = "Subnet id for vm"
}

variable "vm_publisher" {
  type        = string
  description = "Virtual machine publisher"
}

variable "vm_offer" {
  type        = string
  description = "Virtual machine offer"
}

variable "vm_sku" {
  type        = string
  default     = "20.04-LTS"
  description = "Virtual machine sku"
}

variable "vm_version" {
  type        = string
  description = "Virtual machine os version"
  default     = "latest"
}

variable "boot_diagnostics_storage_account_uri" {
  type        = string
  description = "Storage account primary blob endpoint for boot diagnostics"
}

variable "application_port" {
  type        = number
  default     = 80
  description = "Port of the hosted application"
}

variable "keyvault_id" {
  type        = string
  default     = "vm"
  description = "Id for the key vault"
}

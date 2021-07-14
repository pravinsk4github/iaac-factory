variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "Location/region"
}

variable "vmss_name" {
  type        = string
  default     = "vm"
  description = "Name for the virtual machine scale set"
}

variable "sku_capacity" {
  type        = number
  default     = 2
  description = "Number of virtual machines in the scale set"
}

variable "sku_name" {
  type        = string
  default     = "Standard_DS1_v2"
  description = "Sku name of virtual machine scale set"
}

variable "sku_tier" {
  type        = string
  default     = "Standard"
  description = "Sku tier of the virtual machine scale set"
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

variable "upgrade_policy_mode" {
  type        = string
  default     = "Manual"
  description = "Upgrade policy for vm"
}

variable "admin_user" {
  type        = string
  description = "Virtual machine admin user name"
}

variable "admin_password" {
  type        = string
  description = "Virtual machine admin user password"
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
  default     = "20.04-LTS"
  description = "Virtual machine sku"
}

variable "image_version" {
  type        = string
  description = "Virtual machine image os version"
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

variable "domain_name_label" {
  type        = string
  description = "Domain name label for load balancer"
}

variable "lbpip_allocation_method" {
  type        = string
  default     = "Static"
  description = "Public IP allotation method for load balancer"
}

variable "private_ip_allocation_method" {
  type        = string
  default     = "dynamic"
  description = "Private IP allocation method for load balancer"
}

variable "keyvault_id" {
  type        = string
  default     = "vm"
  description = "Id for the key vault"
}

variable "disable_password_authentication" {
  type        = bool
  default     = true
  description = "Wheather to disable password authentication"
}

variable "application_security_group_ids" {
  type = list(any)
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
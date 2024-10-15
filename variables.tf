variable "int_slug" {
  type        = string
  description = "(optional) The unique integer at the end of each resource in the workload unit. This should match the same value from the enterprise spoke deployment."
}

variable "environment" {
  type        = string
  description = "(Required) The short name of the environment you are deploying to."
  default     = "dev"

}

variable "resource_group_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "application_name" {
  type        = string
  description = "The application short name for the workload."
}
variable "virtual_network_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "subnet_name" {
  type        = string
  description = "the name of the subnet the virtual machines will be connected to. This should already exist from the Spoke deployment plan. "
}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault resource from the lvl0 enterprise spoke deployment"
}

variable "assigned_identity_name" {
  description = "The name of the assigned identity"
  type        = string
}


variable "vm_configurations" {
  description = "Map of VM configurations"
  type = map(object({
    size           = string
    os_type        = string
    name           = string
    admin_username = string
    nic_count      = number
  }))
}

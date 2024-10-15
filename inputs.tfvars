application_name       = "blustar"
assigned_identity_name = "blustar"
resource_group_name    = "rg-blustar-dev-691"   #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
virtual_network_name   = "vnet-blustar-dev-691" #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
key_vault_name         = "kv-blustar-dev-691"   #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
subnet_name            = "webappsubnet"
int_slug               = "691" # Pull from the outputs.tf from the github enterprise spoke pattern workflow
environment            = "dev"
vm_configurations = {
  vm1 = {
    size           = "Standard_D4as_v5"
    os_type        = "Windows"
    name           = "VM1"
    admin_username = "iamroot"
    nic_count      = 2
  }
  vm2 = {
    size           = "Standard_D4as_v5"
    os_type        = "Windows"
    name           = "VM2"
    admin_username = "iamroot"
    nic_count      = 2
  }
}

tags = {
  Environment       = "dev"
  Description       = "Blue Star Enterprise Resource Manager"
  Department        = "Shared Services"
  "Cost Center"     = "13-12-110x"
  "Technical Owner" = "Bob Gilmore"
  "Business Owner"  = "Digital Apps"
}

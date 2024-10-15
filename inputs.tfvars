application_name       = "POC"
assigned_identity_name = "this"
resource_group_name    = "rg-hl-dev-691"   #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
virtual_network_name   = "vnet-hl-dev-691" #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
key_vault_name         = "kv-hl-dev-691"   #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
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

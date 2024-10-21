application_name       = "stream"
assigned_identity_name = "stream"
resource_group_name    = "rg-stream-dev-148"   #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
virtual_network_name   = "vnet-stream-dev-148" #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
key_vault_name         = "kv-stream-dev-148"   #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
subnet_name            = "webappsubnet"
int_slug               = "148" # Pull from the outputs.tf from the github enterprise spoke pattern workflow
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
  Description       = "Stream EHR tool"
  Department        = "Shared Services"
  "Cost Center"     = "13-12-110x"
  "Technical Owner" = "Bob Gilmore"
  "Business Owner"  = "Digital Apps"
}

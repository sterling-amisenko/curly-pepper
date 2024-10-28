application_name       = "flyers"
assigned_identity_name = "flyers"
resource_group_name    = "rg-flyers-dev-995"   #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
virtual_network_name   = "vnet-flyers-dev-995" #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
key_vault_name         = "kv-flyers-dev-995"   #  Pull from the outputs.tf from the github enterprise spoke pattern workflow
subnet_name            = "webappsubnet"
int_slug               = "995" # Pull from the outputs.tf from the github enterprise spoke pattern workflow
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
  Description       = "flyers EHR tool"
  Department        = "Shared Services"
  "Cost Center"     = "13-12-110x"
  "Technical Owner" = "Bob Gilmore"
  "Business Owner"  = "Digital Apps"
}

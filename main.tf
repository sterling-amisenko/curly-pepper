module "regions" {
  source  = "Azure/regions/azurerm"
  version = "=0.8.1"
}

resource "random_integer" "zone_index" {
  max = length(module.regions.regions_by_name[module.regions.regions[random_integer.region_index.result].name].zones)
  min = 1
}

resource "random_integer" "region_index" {
  max = length(module.regions.regions_by_name) - 1
  min = 0
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "spoke_resource_group" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "spoke_vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.spoke_resource_group.name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.spoke_resource_group.name
  virtual_network_name = data.azurerm_virtual_network.spoke_vnet.name
}

data "azurerm_key_vault" "spoke_key_vault" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.spoke_resource_group.name
}

module "naming" {
  source = "Azure/naming/azurerm"
  suffix = ["${local.application_name}"]
}

resource "azurecaf_name" "availability_set_name" {
  name          = local.application_name
  resource_type = "azurerm_availability_set"
  suffixes      = ["${var.environment}, ${var.int_slug}"]
}

# resource "azurerm_network_interface" "nic" {
#   for_each            = var.vm_configurations
#   name                = "${module.naming.network_interface}-nic"
#   location            = data.azurerm_resource_group.spoke_resource_group.location
#   resource_group_name = data.azurerm_resource_group.spoke_resource_group.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = data.azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# } 

resource "azurerm_availability_set" "availability_set" {
  name                = azurecaf_name.availability_set_name.result
  location            = data.azurerm_resource_group.spoke_resource_group.location
  resource_group_name = data.azurerm_resource_group.spoke_resource_group.name
}

module "avm_virtual_machine" {
  source   = "Azure/avm-res-compute-virtualmachine/azurerm"
  version  = "0.15.1"
  for_each = local.vm_configurations_with_index

  name                = upper(each.value.indexed_name)
  location            = data.azurerm_resource_group.spoke_resource_group.location
  resource_group_name = local.resource_group_name
  os_type             = each.value.os_type
  sku_size            = each.value.size

  # if(var.vm_configurations.keys.count < 3 ? a-zones : a-sets)
  zone                         = null # random_integer.zone_index.result 
  availability_set_resource_id = azurerm_availability_set.availability_set.id


  admin_username = each.value.admin_username

  generated_secrets_key_vault_secret_config = {
    key_vault_resource_id = data.azurerm_key_vault.spoke_key_vault.id #/subscriptions/060f9b29-b2a6-42b9-abde-0b8a387d4dee/resourceGroups/rg-kawfee-dev-354/providers/Microsoft.KeyVault/vaults/kv-kawfee-dev-354
    name                  = "${each.value.name}-${each.key}-admin-password"
  }
  os_disk = {
    caching                   = "None"
    storage_account_type      = "StandardSSD_LRS"
    disk_size_gb              = 127
    write_accelerator_enabled = false
  }

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
  network_interfaces = {
    for idx in range(each.value.nic_count) : "nic_${idx + 1}" => {
      name = upper("${each.value.name}_NIC${format("%02d", idx + 1)}")
      ip_configurations = {
        ip_configuration = {
          name                          = lower("${each.value.name}-ipconfig-${format("%02d", idx + 1)}")
          private_ip_subnet_resource_id = data.azurerm_subnet.subnet.id
        }
      }
    }
  }
  managed_identities = {
    system_assigned            = true
    user_assigned_resource_ids = [azurerm_user_assigned_identity.spoke_vm_user_assigned_identity.id]
  }

  role_assignments_system_managed_identity = {
    role_assignment_1 = {
      scope_resource_id          = data.azurerm_key_vault.spoke_key_vault.id
      role_definition_id_or_name = "Key Vault Secrets Officer"
      description                = "Assign the Key Vault Secrets Officer role to the virtual machine's system managed identity"
      principal_type             = "ServicePrincipal"
    }
  }

  role_assignments = {
    role_assignment_2 = {
      principal_id               = data.azurerm_client_config.current.client_id
      role_definition_id_or_name = "Virtual Machine Contributor"
      description                = "Assign the Virtual Machine Contributor role to the deployment user on this virtual machine resource scope."
      principal_type             = "ServicePrincipal"
    }
  }

  #Create a new empty disk and attach it as lun 0
  data_disk_managed_disks = {
    disk1 = {
      name                 = "${each.value.name}_DD"
      storage_account_type = "StandardSSD_LRS"
      lun                  = 0
      caching              = "ReadWrite"
      disk_size_gb         = 32
    }
  }

}

resource "azurerm_user_assigned_identity" "spoke_vm_user_assigned_identity" {
  location            = data.azurerm_resource_group.spoke_resource_group.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = data.azurerm_resource_group.spoke_resource_group.name
}

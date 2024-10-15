locals {
  application_name    = var.application_name
  resource_group_name = var.resource_group_name
  vm_keys             = keys(var.vm_configurations)
  vm_configurations_with_index = {
    for idx, key in local.vm_keys : key => merge(var.vm_configurations[key], {
      indexed_name = "${var.vm_configurations[key].name}${format("%02d", idx + 1)}"
    })
  }

  tags = {
    tier = "test"
  }
}

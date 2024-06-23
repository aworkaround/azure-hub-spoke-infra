provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "virtual_machines" {
  for_each           = var.environments
  source             = "/mnt/c/Users/KAMAL/Downloads/terraform-azurerm-azure-linux-vm" # "aworkaround/azure-linux-vm/azurerm"
  vnet_address_space = each.value.vnet_address_space
  location           = each.value.location
  label              = each.value.label
}

# module "hub_vm_2" {
#   source                 = "/mnt/c/Users/KAMAL/Downloads/terraform-azurerm-azure-linux-vm"
#   location               = var.environments.hub.location
#   vm_name                = "HUB-2-TEST-VM"
#   label                  = var.environments.hub.label
#   create_resource_group  = false
#   resource_group_name    = module.virtual_machines["hub"].resource_group_name
#   create_vnet_and_subnet = false
#   subnet_id              = module.virtual_machines["hub"].subnet_id
# }

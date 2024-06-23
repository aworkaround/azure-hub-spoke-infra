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

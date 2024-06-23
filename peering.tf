resource "azurerm_virtual_network_peering" "hub_to_spoke1_peering" {
  name                      = "HUB-To-SPOKE1-Peering"
  resource_group_name       = module.virtual_machines["hub"].resource_group_name
  virtual_network_name      = module.virtual_machines["hub"].virtual_network_name
  remote_virtual_network_id = module.virtual_machines["spoke1"].virtual_network_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "hub_to_spoke2_peering" {
  name                      = "HUB-To-SPOKE2-Peering"
  resource_group_name       = module.virtual_machines["hub"].resource_group_name
  virtual_network_name      = module.virtual_machines["hub"].virtual_network_name
  remote_virtual_network_id = module.virtual_machines["spoke2"].virtual_network_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "spoke1_to_hub_peering" {
  name                      = "SPOKE1-To-HUB-Peering"
  resource_group_name       = module.virtual_machines["spoke1"].resource_group_name
  virtual_network_name      = module.virtual_machines["spoke1"].virtual_network_name
  remote_virtual_network_id = module.virtual_machines["hub"].virtual_network_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "spoke2_to_hub_peering" {
  name                      = "SPOKE2-To-HUB-Peering"
  resource_group_name       = module.virtual_machines["spoke2"].resource_group_name
  virtual_network_name      = module.virtual_machines["spoke2"].virtual_network_name
  remote_virtual_network_id = module.virtual_machines["hub"].virtual_network_id
  allow_forwarded_traffic   = true
}

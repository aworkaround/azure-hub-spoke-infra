resource "azurerm_route_table" "spoke1_rt" {
  name                = "SPOKE1-RT"
  resource_group_name = module.virtual_machines["spoke1"].resource_group_name
  location            = var.environments.spoke1.location
}

resource "azurerm_route" "spoke1_route" {
  name                   = "SPOKE1-Route"
  resource_group_name    = module.virtual_machines["spoke1"].resource_group_name
  route_table_name       = azurerm_route_table.spoke1_rt.name
  address_prefix         = var.environments.spoke2.vnet_address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

resource "azurerm_route_table" "spoke2_rt" {
  name                = "SPOKE2-RT"
  resource_group_name = module.virtual_machines["spoke2"].resource_group_name
  location            = var.environments.spoke2.location
}

resource "azurerm_route" "spoke2_route" {
  name                   = "SPOKE2-Route"
  resource_group_name    = module.virtual_machines["spoke2"].resource_group_name
  route_table_name       = azurerm_route_table.spoke2_rt.name
  address_prefix         = var.environments.spoke1.vnet_address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "spoke1_rt_association" {
  subnet_id      = module.virtual_machines["spoke1"].subnet_id
  route_table_id = azurerm_route_table.spoke1_rt.id
}

resource "azurerm_subnet_route_table_association" "spoke2_rt_association" {
  subnet_id      = module.virtual_machines["spoke2"].subnet_id
  route_table_id = azurerm_route_table.spoke2_rt.id
}
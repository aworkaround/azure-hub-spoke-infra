resource "azurerm_subnet" "fw_snet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = module.virtual_machines["hub"].resource_group_name
  virtual_network_name = module.virtual_machines["hub"].virtual_network_name
  address_prefixes     = [cidrsubnet(var.environments.hub.vnet_address_space[0], 8, 100)]
}

resource "azurerm_public_ip" "fw_pip" {
  name                = "hub-fw-pip"
  location            = var.environments.hub.location
  resource_group_name = module.virtual_machines["hub"].resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  vnet_hub_name    = module.virtual_machines["hub"].virtual_network_name
  vnet_spoke1_name = module.virtual_machines["spoke1"].virtual_network_name
  vnet_spoke2_name = module.virtual_machines["spoke2"].virtual_network_name
}

resource "azurerm_firewall_network_rule_collection" "name" {
  azure_firewall_name = azurerm_firewall.fw.name
  action              = "Allow"
  name                = "hub-fw-main-rule"
  priority            = 400
  resource_group_name = module.virtual_machines["hub"].resource_group_name

  rule {
    name                  = "Allow-SPOKE1-Traffic-To-SPOKE2"
    description           = "Allow SPOKE1 VNET:${local.vnet_spoke1_name} traffic to SPOKE2 VNET:${local.vnet_spoke2_name}"
    source_addresses      = var.environments.spoke1.vnet_address_space
    destination_addresses = var.environments.spoke2.vnet_address_space
    protocols             = ["Any"]
    destination_ports     = ["*"]
  }

  rule {
    name                  = "Allow-SPOKE2-Traffic-To-SPOKE1"
    description           = "Allow SPOKE2 VNET:${local.vnet_spoke2_name} traffic to SPOKE1 VNET:${local.vnet_spoke1_name}"
    source_addresses      = var.environments.spoke2.vnet_address_space
    destination_addresses = var.environments.spoke1.vnet_address_space
    protocols             = ["Any"]
    destination_ports     = ["*"]
  }
}

resource "azurerm_firewall" "fw" {
  name                = "hub-firewall"
  location            = var.environments.hub.location
  resource_group_name = module.virtual_machines["hub"].resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.fw_snet.id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
}

resource "azurerm_log_analytics_workspace" "fw_law" {
  name                = "hub-firewall-law"
  resource_group_name = azurerm_firewall.fw.resource_group_name
  location            = azurerm_firewall.fw.location
}

resource "azurerm_monitor_diagnostic_setting" "fw_diag" {
  name                           = "hub-firewall-diag-setting"
  target_resource_id             = azurerm_firewall.fw.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.fw_law.id
  log_analytics_destination_type = "AzureDiagnostics"

  metric {
    category = "AllMetrics"
    enabled  = true
  }

  enabled_log {
    category_group = "AllLogs"
  }
}

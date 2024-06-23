variable "environments" {
  default = {
    hub = {
      location           = "centralindia"
      label              = "HUB"
      vnet_address_space = ["10.0.0.0/16"]
    },
    spoke1 = {
      location           = "eastus"
      label              = "SPOKE1"
      vnet_address_space = ["10.10.0.0/16"]
    },
    spoke2 = {
      location           = "japaneast"
      label              = "SPOKE2"
      vnet_address_space = ["10.20.0.0/16"]
    }
  }
}

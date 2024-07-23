variable "environments" {
  default = {
    hub = {
      location           = "centralindia"
      label              = "hub"
      vnet_address_space = ["10.0.0.0/16"]
    },
    spoke1 = {
      location           = "eastus"
      label              = "spoke1"
      vnet_address_space = ["10.10.0.0/16"]
    },
    spoke2 = {
      location           = "japaneast"
      label              = "spoke2"
      vnet_address_space = ["10.20.0.0/16"]
    }
  }
}

output "ssh_command" {
  value       = [for vm in module.virtual_machines : vm.ssh_command]
  description = "SSH commands to be used for accessing VMs"
}

output "ip_addresses" {
  value = {
    vms      = { for vm in module.virtual_machines : vm.label => [vm.private_ip_address, vm.ssh_hostname] }
    firewall = azurerm_firewall.fw.ip_configuration[0].private_ip_address
  }
}

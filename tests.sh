#!/bin/bash

# Installs for Local machine
sudo apt update &&\
  sudo apt upgrade -y &&\
  sudo apt install jq -y

# Commands for all VMs
sudo apt update &&\
  sudo apt upgrade -y &&\
  sudo apt install inetutils-traceroute -y

# Run on Host machine and run the output on VMs
echo "export FW_IP=$(cat ./terraform.tfstate | jq '.outputs.ip_addresses.value.firewall')"
echo "export HUB_IP=$(cat ./terraform.tfstate | jq '.outputs.ip_addresses.value.vms.HUB[0]')"
echo "export HUB_SSH=$(cat ./terraform.tfstate | jq '.outputs.ip_addresses.value.vms.HUB[1]')"
echo "export SPOKE1_IP=$(cat ./terraform.tfstate | jq '.outputs.ip_addresses.value.vms.SPOKE1[0]')"
echo "export SPOKE1_SSH=$(cat ./terraform.tfstate | jq '.outputs.ip_addresses.value.vms.SPOKE1[1]')"
echo "export SPOKE2_IP=$(cat ./terraform.tfstate | jq '.outputs.ip_addresses.value.vms.SPOKE2[0]')"
echo "export SPOKE2_SSH=$(cat ./terraform.tfstate | jq '.outputs.ip_addresses.value.vms.SPOKE2[1]')"

if (ping -c 4 $FW_IP 2> /dev/null) ; then
    echo "Firewall connectivity is OK!"
else
    echo "Firewall connection failed!"
fi
if (ping -c 4 $HUB_IP 2> /dev/null) ; then
    echo "HUB connectivity is OK!"
else
    echo "HUB connection failed!"
fi
if (ping -c 4 $SPOKE1_IP 2> /dev/null) ; then
    echo "SPOKE1 connectivity is OK!"
else
    echo "SPOKE1 connection failed!"
fi
if (ping -c 4 $SPOKE2_IP 2> /dev/null) ; then
    echo "SPOKE2 connectivity is OK!"
else
    echo "SPOKE2 connection failed!"
fi

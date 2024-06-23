#!/bin/bash

ResourceGroups=$(az group list --output tsv --query '[].name')

for rg in $ResourceGroups; do
  az group delete --name "$rg" --yes --no-wait
done

rm terraform.tfstate* .terraform .terraform.lock* -rf
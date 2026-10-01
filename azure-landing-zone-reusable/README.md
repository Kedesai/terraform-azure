# Azure Landing Zone Reusable Terraform Modules

Initial reusable Azure landing-zone foundation containing:

- Management groups
- Existing subscription placement
- Management-group Azure Policy assignments
- Foundation composition module

This starter intentionally does not recreate workload modules such as VNet, NSG, AKS, ACR, Key Vault, Storage, VM, Azure SQL, or Private Endpoint modules. Those remain separate reusable service modules and can later consume landing-zone/foundation outputs.

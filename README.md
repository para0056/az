# az - Azure Automation

Primarily used for deployment and testing of Azure Virtual Desktop.

## Resources Deployed

- `budget`:
  - Resource Group
  - Action Group
  - Monthly Budget

- `network`:
  - Resource Group
  - VNet
  - Subnet
  - Network Security Group(s)

- `bastion`:
  - Resource Group
  - Subnet (dedicated to Azure Bastion)
  - Network Security Group
  - Azure Bastion Instance

- `avd`:
  - Resource Group
  - Azure Virtual Desktop Workspace
  - Azure Virtual Desktop Host Pool
  - Azure Virtual Desktop Application Group
  - Azure Virtual Machine (Windows 11 22H2)
  - Virtual Machine Extensions
    - Join Azure Virtual Desktop Host Pool
    - Join to Azure Active Directory
  - Key Vault + Secret (Local Admin Password)
  - Azure Active Directory Group
    - Grant "Desktop Virtualization User" role to the group 
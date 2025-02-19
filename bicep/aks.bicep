targetScope = 'subscription'

param location string = 'eastus'


param rgName string = 'rgmin001'


param acrSku string = 'Basic'
param acrAdminUserEnabled bool = false
param aksName string = 'csmin001'
param aksCount int = 3
param aksNodeSize string = 'Standard_B2ms'
param acrName string = 'crmin001'



resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module aks 'br/public:avm/res/container-service/managed-cluster:0.8.1' = {
  dependsOn: [
    acr
  ]
  scope: rg
  name: 'managedClusterDeployment'
  params: {
    // Required parameters
    name: 'csmin001'
    primaryAgentPoolProfiles: [
      {
        count: 2
        mode: 'System'
        name: 'systempool'
        vmSize: aksNodeSize
      }
    ]
    // Non-required parameters
    aadProfile: {
      aadProfileEnableAzureRBAC: true
      aadProfileManaged: true
    }
    managedIdentities: {
      systemAssigned: true
    }
  }
}

module acr 'br/public:avm/res/container-registry/registry:0.8.5' = {
  scope: rg
  name: 'containerRegistryDeployment'
  params: {
    // Required parameters
    name: 'crmin001'
    acrSku: 'Basic'
    // Non-required parameters

    acrAdminUserEnabled: false
  }
}

param resourceName string
param location string = resourceGroup().location

@allowed([
  'Dynamic'
  'Static'
])
param privateIPAllocationMethod string = 'Dynamic'

param virtualNetworkResourceGroupName string
param virtualNetworkName string
param subnetName string

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: resourceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: resourceName
        properties: {
          primary: true
          privateIPAllocationMethod: privateIPAllocationMethod
          subnet: {
            id: resourceId(virtualNetworkResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
          }
        }
      }
    ]
  }
}

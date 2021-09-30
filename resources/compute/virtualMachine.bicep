param resourceName string
param location string = resourceGroup().location
param networkInterfaceName string
param networkInterfaceResourceGroupName string

param adminUsername string
@secure()
param adminPassword string

param osDiskName string = '${resourceName}-osdisk'
param osDiskSizeGB int = 128

param vmSize string
param imagePublisher string
param imageOffer string
param imageSku string

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: resourceName
  location: location
  properties:{
    hardwareProfile: {
      vmSize:	vmSize
    }
    osProfile: {
      adminUsername: adminUsername
      adminPassword: adminPassword
      computerName: resourceName
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        name: osDiskName
        diskSizeGB: osDiskSizeGB

      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: resourceId(networkInterfaceResourceGroupName, 'Microsoft.Network/networkInterfaces', networkInterfaceName)
        }
      ]
    }
  }
}

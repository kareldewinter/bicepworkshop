// Set the deployment scope
targetScope = 'subscription'


// Parameter declaration
param deploymentNamePrefix string = 'BicepWorkshop'
param location string = 'westeurope'
param resourceGroupName string = 'rg-bicep-dev-01'

param virtualNetworkObject object = {
  Name: 'vnet-bicep-vdc-dev-01'
  addressList: [
    '10.0.0.0/16'
  ]
  subnetObjectList: [
    {
      name: 'sn-bicep-vdc-dev-01'
      subnetAddress: '10.0.16.0/21'
    }
  ]
}

param networkInterfaceName string = 'mytestvm01-nic'


// Workshop parameters

@secure()
param adminPassword string


param virtualMachineObject object = {
  virtualMachineName: 'VMLAB01' 

  adminUsername: 'azureuser'
  adminPassword: adminPassword

  vmSize: 'Standard_DS2_v2'
  imagePublisher: 'MicrosoftWindowsServer'
  imageOffer: 'WindowsServer'
  imageSku: '2022-datacenter-g2'

  diskObjectList: [
    {
      osDiskName: 'VMLAB01-osdisk'
      osDiskSizeGB: 256
    }
  ]
}


// Resource declaration
resource resourceGroup_resource 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module virtualNetwork 'resources/network/virtualNetwork.bicep' = {
  scope: resourceGroup_resource
  // scope: resourceGroup(resourceGroupName) # This is also a valid approach
  name: '${deploymentNamePrefix}-VirtualNetwork-${virtualNetworkObject.name}'
  params: {
    resourceName: virtualNetworkObject.name
    location: location
    subnetObjectList: virtualNetworkObject.subnetObjectList
    vNetAddressList: virtualNetworkObject.addressList
    dnsServerIPAddressList: (contains(virtualNetworkObject, 'DnsServerIPAddressList')) ? virtualNetworkObject.DnsServerIPAddressList : []
  }
}

module networkInterface 'resources/network/networkInterface.bicep' = {
  scope: resourceGroup_resource
  name: '${deploymentNamePrefix}-NIC-${networkInterfaceName}'
  dependsOn: [
    virtualNetwork
  ]
  params: {
    resourceName: networkInterfaceName
    virtualNetworkName: virtualNetworkObject.name
    virtualNetworkResourceGroupName: resourceGroup_resource.name
    subnetName: virtualNetworkObject.subnetObjectList[0].name
  }
}

// Workshop resources
module virtualMachine 'resources/compute/virtualMachine.bicep' = {
  scope: resourceGroup_resource
  name: '${deploymentNamePrefix}-VM-${networkInterfaceName}'
  dependsOn: [
    networkInterface
  ]
  params: {
    resourceName: virtualMachineObject.virtualMachineName
    
    location: location
    networkInterfaceName: networkInterfaceName
    networkInterfaceResourceGroupName: resourceGroup_resource.name

    adminUsername: virtualMachineObject.adminUsername
    adminPassword: virtualMachineObject.adminPassword
    osDiskName: virtualMachineObject.diskObjectList[0].osDiskName
    osDiskSizeGB: virtualMachineObject.diskObjectList[0].osDiskSizeGB
    vmSize: virtualMachineObject.vmSize
    imagePublisher: virtualMachineObject.imagePublisher
    imageOffer: virtualMachineObject.imageOffer
    imageSku: virtualMachineObject.imageSku
  }
}

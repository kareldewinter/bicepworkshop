targetScope = 'subscription'

param rg1Name string = 'd-rgr-bicep-01'
param rg1Location string = 'westeurope'
param rg2Name string = 'd-rgr-bicep-02'
param rg2Location string = 'westeurope'
param vnet1Name string = 'd-vne-bicep-01'
param vnet2Name string = 'd-vne-bicep-02'

resource rg1 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${rg1Name}'
  location: '${rg1Location}'
} 

resource rg2 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${rg2Name}'
  location: '${rg2Location}'
} 


module vnet1 '../101-resourcelibrary/virtualNetwork2Subnets.bicep' = {
  name: 'vnet1'
  scope: resourceGroup(rg1.name)
  params:{
    vnetName: vnet1Name
    addressPrefixes:[
    '10.0.0.0/8'
    ]
    subnet1Name:'d-sne${vnet1Name}-01'
    subnet2Name:'d-sne${vnet1Name}-02'
    subnet1AddressPrefix: '10.1.1.0/24'
    subnet2AddressPrefix: '10.1.2.0/24'
  }
}

module vne2 '../101-resourcelibrary/virtualNetwork2Subnets.bicep' = {
  name: 'vnet2'
  scope: resourceGroup(rg2.name)
  params:{
    vnetName: vnet2Name
    addressPrefixes: [
      '172.16.0.0/16'
    ]
    subnet1Name:'d-sne${vnet2Name}-01'
    subnet2Name:'d-sne${vnet2Name}-02'
    subnet1AddressPrefix: '172.16.1.0/24'
    subnet2AddressPrefix: '172.16.2.0/24'
  }
}

module peering1 '../101-resourcelibrary/vnetPeering.bicep' = {
  name: 'peering1'
  scope: resourceGroup(rg1.name)
  dependsOn:[
    vnet1
    vne2
  ]
  params:{
    localVnetName:vnet1Name
    remoteVnetName: vnet2Name
    remoteVnetRg: rg2Name
  }
}

module peering2 '../101-resourcelibrary/vnetPeering.bicep' = {
  name: 'peering2'
  scope: resourceGroup(rg2.name)
  dependsOn: [
    vne2
    vnet1
  ]
  params:{
    localVnetName:vnet2Name
    remoteVnetName: vnet1Name
    remoteVnetRg: rg1Name
  }
}




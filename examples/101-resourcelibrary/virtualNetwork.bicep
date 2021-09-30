param vnetName string
param addressPrefixes array
param location string = '${resourceGroup().location}'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  location: location
  name: vnetName
  properties:{
    addressSpace:{
      addressPrefixes:addressPrefixes 
    }    
  }
}


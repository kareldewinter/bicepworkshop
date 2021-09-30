param vnetName string
param addressPrefixes array
param subnet1Name string
param subnet2Name string
param subnet1AddressPrefix string
param subnet2AddressPrefix string
param location string = '${resourceGroup().location}'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  location: location
  name: vnetName
  properties:{
    addressSpace:{
      addressPrefixes:addressPrefixes 
    }
    subnets:[
      {
        name:subnet1Name
        properties:{
          addressPrefix: subnet1AddressPrefix          
        }
      }
      {
        name:subnet2Name
        properties:{
          addressPrefix: subnet2AddressPrefix          
        }
      }
    ]    
  }
}


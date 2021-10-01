resource dnsZone 'Microsoft.Network/dnszones@2018-05-01' = {
  name: 'myZone'
  location: 'global'
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'exampleResource'
  properties: {
    dhcpOptions: {
      dnsServers: [
        dnsZone.name // creates implicit dependency
      ]
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'myStorAcc'
  kind: 'StorageV2'
  location: 'westeurope'
  sku: {
    name: 'Premium_LRS'
  }
  resource blobService 'blobServices' = {
    name: 'default'
    resource blobContainer 'containers' = {
      name: 'mycontainer'
    }
  }
}

param namePrefix string = ''
param location string = ''

resource sto 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: '${namePrefix}${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'StorageV2'
  sku:{
    name: 'Standard_GRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
  }
}
output blobEndpoint string = sto.properties.primaryEndpoints.blob
// Parameters
param location string = 'westeurope'
param accessTier string = 'Hot'
param storageAccountName string

// Resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: accessTier
  }
}

output storageAccount string = storageAccount.name

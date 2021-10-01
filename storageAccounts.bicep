// Set the deployment scope
targetScope = 'subscription'

// Parameter declaration
param deploymentNamePrefix string = 'BicepWorkshop'
param location string = 'westeurope'
param resourceGroupName string = 'rg-bicep-dev-01'

// Workshop parameters
param storageAccountObjectList array = [
  {
    name: 'sa${uniqueString('kareldewinter')}01'
    sku: 'Standard_LRS'
    accessTier: 'Hot'
    kind: 'StorageV2'
    containerName: 'mycontainer'
  }
  {
    name: 'sa${uniqueString('kareldewinter')}02'
    sku: 'Standard_LRS'
    accessTier: 'Cool'
    kind: 'BlobStorage'
    containerName: 'mycontainer'
  }
  {
    name: 'sa${uniqueString('kareldewinter')}03'
    sku: 'Standard_LRS'
    accessTier: 'Cool'
    kind: 'StorageV2'
  }
]

// Workshop parameters


// Resource declaration
resource resourceGroup_resource 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}


// Workshop resources

module storageAccount 'resources/storage/storageAccount.bicep' = [for storageAccountObject in storageAccountObjectList: {
  scope: resourceGroup_resource
  name: '${deploymentNamePrefix}-StorageAccount-${storageAccountObject.name}'
  params: {
    accessTier: storageAccountObject.accessTier
    location: location
    storageAccountName: storageAccountObject.name
  }
}]

module storageAccount_blobContainer 'resources/storage/storageAccount_blobContainer.bicep' = [for storageAccountObject in storageAccountObjectList: if (contains(storageAccountObject, 'containerName')) {
  dependsOn: [
    storageAccount
  ]
  scope: resourceGroup_resource
  name: '${deploymentNamePrefix}-BlobContainer-${storageAccountObject.name}'
  params: {
    resourceName: storageAccountObject.containerName
    storageAccountName: storageAccountObject.name
  }
} ]


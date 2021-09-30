// Set the deployment scope
targetScope = 'subscription'

// Parameter declaration
param deploymentNamePrefix string = 'BicepWorkshop'
param location string = 'westeurope'
param resourceGroupName string = 'rg-bicep-dev-01'

// Workshop parameters
param storageAccountObjectList array = [
  {
    name: 'sa${uniqueString('YourName')}01'
    sku: 'Standard_LRS'
    accessTier: 'Hot'
    kind: 'StorageV2'
    containerName: 'mycontainer'
  }
  {
    name: 'sa${uniqueString('YourName')}02'
    sku: 'Standard_LRS'
    accessTier: 'Cool'
    kind: 'BlobStorage'
    containerName: 'mycontainer'
  }
  {
    name: 'sa${uniqueString('YourName')}03'
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

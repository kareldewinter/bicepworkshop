targetScope = 'subscription'

param rg1 string
param rg1Location string = 'westeurope'
param storageAccountNamePrefix string

resource rgTest 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${rg1}'
  location: '${rg1Location}'
} 

module stoMod '../101-resourcelibrary/storageAccount.bicep' = {
  name: 'storageDeploy' // name for nested deployment
  scope: resourceGroup(rgTest.name)
  params:{
    location: '${rg1Location}'
    namePrefix: '${storageAccountNamePrefix}'
  }
}


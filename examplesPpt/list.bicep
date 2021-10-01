targetScope = 'subscription'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  scope: resourceGroup('cloud-shell-storage-westeurope')
  name: 'csb10037ffeaed16367'
}

resource functionApp 'Microsoft.Web/sites@2021-01-15' existing = {
  scope: resourceGroup('funcappdev012')
  name: 'func-app-dev-01'
}

resource function 'Microsoft.Web/sites/functions@2021-01-15' existing = {
  parent: functionApp
  name: 'CosmosDBUpload'
}

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-06-15' existing = {
  scope: resourceGroup('rg-app-dev-01')
  name: 'cosmos-app-dev-01'
}

// https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-resource#list
output storageAccountKey string = storageAccount.listKeys().keys[0].value
output appKey string = function.listkeys().default
output cosmosDbConnectionString string = cosmosDbAccount.listConnectionStrings().connectionStrings[0].connectionString

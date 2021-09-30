param location string
@minLength(5)
@maxLength(20)
param resourceGroupName string
param appServicePlanObject object
param appServiceObject object
param tagObject object = {}
param arrayExample array = []

var myDemoStringVariable = 'DemoString'
var myDemoArrayVariable = [
  'item1'
  'Item2'
]
var myDemoObjectVariable = {
  name: 'DemoObjectName'
  location: 'DexMach HQ'
}
var resourceGroupNameWithLocation = '${resourceGroupName}-${location}'

//Show intellisense of resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 
  location: 
  sku: {
    name: 
  }
  kind: 
}

//Show intellisense of module
module virtualMachine '../resources/compute/virtualMachine.bicep' = {
  name: 
  params: {
    adminPassword: 
    adminUsername: 
    imageOffer: 
    imagePublisher: 
    imageSku: 
    networkInterfaceName: 
    networkInterfaceResourceGroupName: 
    resourceName: 
    vmSize: 
  }
}

module azureFirewallRuleCollectionGroup '../resources/network/azureFirewallRuleCollectionGroups.bicep' = [for ruleCollectionGroupObject in azureFirewallComponentObject.azureFirewallPolicyObject.ruleCollectionGroupObjectList: if(!(azureFirewallComponentObject.firstDeployment)){
  scope: resourceGroup(hubVnetComponentObject.resourceGroupName)
  name: ruleCollectionGroupObject.ruleCollectionGroupName
  dependsOn: [
    azureFirewallPolicy
  ]
  params: {
    azureFirewallPolicyName: azureFirewallComponentObject.azureFirewallPolicyObject.name
    priority: ruleCollectionGroupObject.ruleCollectionGroupPriority
    resourceName: ruleCollectionGroupObject.ruleCollectionGroupName
    ruleCollectionsObjectList: union(array('${ruleCollectionGroupObject.natRuleCollectionsObjectAllow}'),array('${ruleCollectionGroupObject.networkRuleCollectionsObjectAllow}'), array('${ruleCollectionGroupObject.networkRuleCollectionsObjectDeny}'),array('${ruleCollectionGroupObject.applicationRuleCollectionsObjectAllow}'),array('${ruleCollectionGroupObject.applicationRuleCollectionsObjectDeny}'))
    
  }
}]

resource VirtualNetwork 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: resourceName
  location: resourceGroup().location
  properties: {
    dhcpOptions: (empty(dnsServerIPAddressList) ? json('null') : dhcpOptionsObject)
    addressSpace: {
      addressPrefixes: vNetAddressList
    }
    subnets: [for (subnetObject, j) in subnetObjectList: {
      name: subnetObject.name
      properties: {
        addressPrefix: subnetObject.subnetAddress
        privateEndpointNetworkPolicies: (contains(subnetObject, 'PrivateEndpointNetworkPolicySetting') ? subnetObject.privateEndpointNetworkPolicySetting : json('null'))
        networkSecurityGroup: ((nsgSubnetObjectExtension[j].id == 'NoNsg') ? json('null') : nsgSubnetObjectExtension[j])
        routeTable: ((routeTableSubnetObjectExtension[j].id == 'NoRouteTable') ? json('null') : routeTableSubnetObjectExtension[j])
        serviceEndpoints: (empty(serviceEndpointListExtension[j]) ? json('null') : serviceEndpointListExtension[j])
        delegations: (empty(delegationListExtension[j].name) ? json('null') : delegationListExtension[j])
      }
    }]
  }
}

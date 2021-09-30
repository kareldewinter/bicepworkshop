param resourceName string
param location string
param vNetAddressList array

@description('This subnet object list enables idempotency scenario\'s for virtual network resources with multiple subnets. Make sure that this list is in the required format. Each object requires the \'Name\' and \'SubnetAddress\' property. Optionally the properties \'NetworkSecurityGroupName\', \'routeTableName\', \'PrivateEndpointNetworkPolicySetting\' (possible values: Enabled or Disabled) or \'ServiceEndpointObjectList\' (service and locations properties required) can be provided. These properties have the capabilities to link the subnet to a desired linked resource.')
param subnetObjectList array

@description('Optional value for the resource group of any optional route table names that were passed in the subnet object list.')
param routeTableResourceGroupName string = ''

@description('List of dns server ip addresses in case custom dns is required.')
param dnsServerIPAddressList array = []

var dhcpOptionsObject = {
  dnsServers: dnsServerIPAddressList
}
var nsgSubnetObjectExtension = [for subnetObject in subnetObjectList: {
  id: (contains(subnetObject, 'NetworkSecurityGroupName') ? (empty(subnetObject.NetworkSecurityGroupName) ? 'NoNsg' : resourceId('Microsoft.Network/networkSecurityGroups', subnetObject.NetworkSecurityGroupName)) : 'NoNsg')
}]
var routeTableSubnetObjectExtension = [for subnetObject in subnetObjectList: {
  id: (contains(subnetObject, 'routeTableName') ? (empty(subnetObject.routeTableName) ? 'NoRouteTable' : (empty(routeTableResourceGroupName) ? resourceId('Microsoft.Network/routeTables', subnetObject.routeTableName) : resourceId(routeTableResourceGroupName, 'Microsoft.Network/routeTables', subnetObject.routeTableName))) : 'NoRouteTable')
}]
var serviceEndpointListExtension = [for subnetObject in subnetObjectList: (contains(subnetObject, 'ServiceEndpointObjectList') ? (empty(subnetObject.ServiceEndpointObjectList) ? [] : subnetObject.ServiceEndpointObjectList) : [])]
var delegationListExtension = [for subnetObject in subnetObjectList: (contains(subnetObject, 'delegationObjectList') ? (empty(subnetObject.delegationObjectList) ? [] : subnetObject.delegationObjectList) : [])]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: resourceName
  location: location
  properties: {
    dhcpOptions: (empty(dnsServerIPAddressList) ? null : dhcpOptionsObject)
    addressSpace: {
      addressPrefixes: vNetAddressList
    }
    subnets: [for (subnetObject, index) in subnetObjectList: {
      name: subnetObject.Name
      properties: {
        addressPrefix: subnetObject.SubnetAddress
        privateEndpointNetworkPolicies: (contains(subnetObject, 'PrivateEndpointNetworkPolicySetting') ? subnetObject.PrivateEndpointNetworkPolicySetting : null)
        networkSecurityGroup: ((nsgSubnetObjectExtension[index].id == 'NoNsg') ? null : nsgSubnetObjectExtension[index])
        routeTable: ((routeTableSubnetObjectExtension[index].id == 'NoRouteTable') ? null : routeTableSubnetObjectExtension[index])
        serviceEndpoints: (empty(serviceEndpointListExtension[index]) ? null : serviceEndpointListExtension[index])
        delegations: (empty(delegationListExtension[index]) ? null : delegationListExtension[index])
      }
    }]
  }
}

output resourceName string = resourceName

param location string {
  default: resourceGroup().location
  metadata: {
    description: 'Specifies the Azure location where the key vault should be created.'
  }
}

param firewallName string {
  metadata: {
    description: 'Specifies the name of the Firewall'
  }
}

param publicIpName string {
  metadata: {
    description: 'Specifies the name of the firewall public IP'
  }
}

param subnetId string {
}


param firewallsubnetprefix string {
  default: '10.1.254.0/26'
  metadata: {
    description: 'Specifies the address prefix to use for the AzureFirewallSubnet'
  }
}



resource publicip 'Microsoft.Network/publicIPAddresses@2020-05-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2020-05-01' = {
  name: firewallName
  location: location
  properties: {
    threatIntelMode: 'Deny'
    ipConfigurations: [
      {
        name: '${firewallName}-vnetIpconf'
        properties: {
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: publicip.id
          }
        }
      }
    ]
  }
}

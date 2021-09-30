param subnet1Name string
param subnet1AddressSpace string

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  name: '${subnet1Name}'
  properties:{
     addressPrefix: '${subnet1AddressSpace}'     
  }
}
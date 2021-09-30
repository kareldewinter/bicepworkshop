# Workshop - Azure Bicep

## Setup

[Installing Bicep tools](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install):

* [Install VS Code](https://code.visualstudio.com/download)
* [Install Bicep extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
* [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)
* [Install Azure PowerShell](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-6.4.0)
* [Install Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually) (Required for using Bicep with Azure PowerShell)

## Goal 1 - Extend the [VirtualDataCenter.bicep](VirtualDataCenter.bicep) file to include a VM

The [VirtualDataCenter.bicep](VirtualDataCenter.bicep) file deploys the following resources currently:

* Azure resource group
* Virtual network
* Network interface

Extend this template to include a virtual machine. A Bicep module for creating a virtual machine is available under [resources/compute/virtualMachine.bicep](resources/compute/virtualMachine.bicep). Use this module in the VirtualDataCenter.Bicep template to create a VM with the following properties:

* OS disk with 256GB storage
* VM size 'Standard_DS2_v2'
* Use the marketplace image for Windows Server DataCenter 2022:
  * Publisher: MicrosoftWindowsServer
  * Offer: WindowsServer
  * Sku: 2022-datacenter-g2
* Use the @secure() decorator to set the adminPassword for the virtual machine as a secure string

Deploy all resources in the resource group that is already defined in the Main.bicep file.

It's OK if you hardcode the property values in the template, but bonus points if you separate them out as parameters (and bonus bonus points if you work with objects).

## Goal 2 - Deploy your solution to Azure

### Using Azure CLI

Make sure you are logged in first:

```bash
az login
```

Set your authentication context to your own subscription:

```bash
az account set --subscription 'your-subscription-id'
```

Deploy the template:

```bash
az deployment sub create --location 'azure-location' --template-file 'Main.bicep' --verbose
```

### Using Azure PowerShell

Make sure you are logged in first:

```powershell
Connect-AzAccount
```

Set your authentication context to your own subscription:

```powershell
Set-AzContext -SubscriptionId 'your-subscription-id'
```

Deploy the template:

```powershell
New-AzSubscriptionDeployment -Name 'my-deployment-name' -Location 'azure-location' -TemplateFile 'Main.bicep' -Verbose
```

## Goal 3 - Deploy 3 storage accounts, using loops

Complete the module [resources/storage/storageAccount.bicep](resources/storage/storageAccount.bicep) to include a template to deploy a storage account.

A file [StorageAccounts.bicep](StorageAccounts.bicep) already exists in the root of the repository. Extend this template by referencing the module you created to deploy 3 storage accounts. **Make sure to use loops for this**. Use the following properties for the storage accounts:

* Storage account 1:
  * kind: StorageV2
  * accessTier: Hot
* Storage account 2:
  * kind: BlobStorage
  * accessTier: Cool
* Storage account 3:
  * kind: StorageV2
  * accessTier: Cool

All storage accounts should have the 'Standard_LRS' sku.

> TIP: Storage account names are globally unique within Azure. You can use the uniqueString() bicep function to generate a unique string based on a provided input. For example, uniqueString('MyName').

### Bonus points

* For storage account 1 and 2, create a blob container called 'mycontainer' within it (using loops and conditionals).

## Debugging deployments

### File could not be found error

This is usually related to a failed bicep build in the background. Azure CLI/PowerShell compiles your Bicep template to an ARM template in the background.

Try manually building the Bicep file for more detailed error logging:

```bash
bicep build Main.bicep
```

### Errors during deployment

If you get the message 'Template is valid', this means your template is accepted by the Azure API but this does not mean that it will deploy your resources without any issues.

If you encounter any errors, get in touch with one of the people leading the workshop and they will help you troubleshoot the issues you encounter.

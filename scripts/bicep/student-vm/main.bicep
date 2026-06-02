// student-vm/main.bicep
// Deploys a single VM (Windows or Ubuntu) for student lab use.

@description('Student NSCC ID (e.g. W0123456) — used in resource names.')
param studentId string

@description('VM size. B2s is recommended for cost efficiency.')
param vmSize string = 'Standard_B2s'

@description('OS image. Choose windows or ubuntu.')
@allowed(['windows', 'ubuntu'])
param osType string = 'ubuntu'

@description('Admin username for the VM.')
param adminUsername string

@description('Admin password for the VM.')
@secure()
param adminPassword string

@description('Azure region.')
param location string = resourceGroup().location

// ── Derived names ──────────────────────────────────────────────────────────
var prefix = 'vm-${toLower(studentId)}'
var vnetName = '${prefix}-vnet'
var subnetName = 'default'
var nsgName = '${prefix}-nsg'
var pipName = '${prefix}-pip'
var nicName = '${prefix}-nic'
var vmName = prefix

// ── NSG ────────────────────────────────────────────────────────────────────
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: osType == 'windows' ? 'allow-rdp' : 'allow-ssh'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: osType == 'windows' ? '3389' : '22'
        }
      }
    ]
  }
}

// ── VNet + Subnet ──────────────────────────────────────────────────────────
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.0.0.0/16'] }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: { id: nsg.id }
        }
      }
    ]
  }
}

// ── Public IP ──────────────────────────────────────────────────────────────
resource pip 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: pipName
  location: location
  sku: { name: 'Basic' }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: { domainNameLabel: toLower('${prefix}-${uniqueString(resourceGroup().id)}') }
  }
}

// ── NIC ────────────────────────────────────────────────────────────────────
resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { id: '${vnet.id}/subnets/${subnetName}' }
          publicIPAddress: { id: pip.id }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// ── VM ─────────────────────────────────────────────────────────────────────
resource vm 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: { vmSize: vmSize }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: osType == 'windows' ? {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      } : {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: { storageAccountType: 'StandardSSD_LRS' }
        deleteOption: 'Delete'
      }
    }
    networkProfile: {
      networkInterfaces: [{ id: nic.id, properties: { deleteOption: 'Delete' } }]
    }
  }
}

// ── Outputs ────────────────────────────────────────────────────────────────
output vmName string = vm.name
output publicFqdn string = pip.properties.dnsSettings.fqdn
output privateIp string = nic.properties.ipConfigurations[0].properties.privateIPAddress

// student-vm/main.bicep
// Deploys a single VM (Windows or Ubuntu) for student lab use.
//
// Linux VMs use SSH public key auth by default (matches Lab 01).
// Windows VMs use password auth (RDP).

@description('Student NSCC ID (e.g. W0123456) — used in resource names.')
param studentId string

@description('VM size. B2s is recommended for cost efficiency.')
param vmSize string = 'Standard_B2s'

@description('OS image. Choose windows or ubuntu.')
@allowed(['windows', 'ubuntu'])
param osType string = 'ubuntu'

@description('Admin username for the VM.')
param adminUsername string

@description('SSH public key for Linux VMs (required when osType = ubuntu). Paste the contents of your id_rsa.pub or id_ed25519.pub.')
param sshPublicKey string = ''

@description('Admin password for Windows VMs (required when osType = windows). Pass via --parameters or a Key Vault reference — do NOT commit.')
@secure()
param adminPassword string = ''

@description('Optional: restrict inbound SSH/RDP to this CIDR. Defaults to * (any). For student labs, prefer your own public IP, e.g. "203.0.113.42/32".')
param allowedSourceCidr string = '*'

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
var isLinux = osType == 'ubuntu'

// ── NSG ────────────────────────────────────────────────────────────────────
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: isLinux ? 'allow-ssh' : 'allow-rdp'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: allowedSourceCidr
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: isLinux ? '22' : '3389'
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
// NOTE: Basic SKU public IPs were retired Sept 30, 2025.
// Standard SKU is now required and must use Static allocation.
resource pip 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: pipName
  location: location
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
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
    osProfile: isLinux ? {
      computerName: vmName
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    } : {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: isLinux ? {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      } : {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
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
output publicIp string = pip.properties.ipAddress
output privateIp string = nic.properties.ipConfigurations[0].properties.privateIPAddress

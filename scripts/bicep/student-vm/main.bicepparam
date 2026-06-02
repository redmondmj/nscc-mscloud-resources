// main.bicepparam — fill in your values before deploying.
//
// For Linux (default): provide sshPublicKey. Leave adminPassword blank.
// For Windows: set osType = 'windows', leave sshPublicKey blank, and pass
//              adminPassword at deploy time via:
//   az deployment group create ... --parameters adminPassword='<value>'
// Never commit a real password to this file.
using './main.bicep'

param studentId = 'W0000000'       // Replace with your NSCC student ID
param osType = 'ubuntu'            // 'ubuntu' or 'windows'
param adminUsername = 'nsccadmin'

// Paste the contents of your public key file (e.g., ~/.ssh/id_ed25519.pub).
// Required for ubuntu; ignored for windows.
param sshPublicKey = ''

// Leave blank here. For windows VMs, pass at deploy time via --parameters.
param adminPassword = ''

// Optional: lock SSH/RDP to your own IP, e.g. '203.0.113.42/32'. Default '*' = any.
param allowedSourceCidr = '*'

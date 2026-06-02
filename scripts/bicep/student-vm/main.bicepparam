// main.bicepparam — fill in your values before deploying
using './main.bicep'

param studentId = 'W0000000'       // Replace with your NSCC student ID
param osType = 'ubuntu'            // 'ubuntu' or 'windows'
param adminUsername = 'nsccadmin'
param adminPassword = ''           // Set via --parameters or az keyvault reference — do NOT commit passwords

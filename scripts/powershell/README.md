# PowerShell Scripts

Reusable Azure PowerShell scripts for common tasks in the NSCC pilot.

## Prerequisites

```powershell
# Install the Az module (first time only)
Install-Module -Name Az -Scope CurrentUser -Force

# Sign in
Connect-AzAccount
```

## Scripts

| Script | Description |
|--------|-------------|
| [New-StudentResourceGroup.ps1](New-StudentResourceGroup.ps1) | Create a tagged resource group for a student project |
| [Remove-StaleResources.ps1](Remove-StaleResources.ps1) | List and optionally delete resource groups older than N days |
| [Get-CreditUsage.ps1](Get-CreditUsage.ps1) | Report current month's Azure cost vs. credit balance |

#Requires -Modules Az.Resources, Az.Accounts
<#
.SYNOPSIS
    Removes Azure resources created during a lab session to reclaim credits.

.DESCRIPTION
    Deletes one or more resource groups (and all resources within them) after
    prompting for confirmation. Supports a naming-prefix filter so instructors
    can bulk-remove all student resource groups from a session in one pass.

    Two operation modes:
      -ResourceGroupName   : Remove a specific named resource group.
      -PrefixFilter        : Remove all resource groups whose names start
                             with the given prefix (e.g. "rg-lab-").

.PARAMETER SubscriptionId
    The Azure subscription ID to operate against.

.PARAMETER ResourceGroupName
    Name of a single resource group to remove.

.PARAMETER PrefixFilter
    Remove all resource groups whose names begin with this string.
    Use with caution — always review the confirmation prompt before proceeding.

.PARAMETER Force
    Skip the per-group confirmation prompt. Use in automated pipelines only.

.EXAMPLE
    # Remove a single student resource group
    .\Remove-LabResources.ps1 `
        -SubscriptionId "<your-subscription-id>" `
        -ResourceGroupName "rg-lab-jsmith"

.EXAMPLE
    # Remove all resource groups created for Lab 3 (prefix-based)
    .\Remove-LabResources.ps1 `
        -SubscriptionId "<your-subscription-id>" `
        -PrefixFilter "rg-lab3-"

.EXAMPLE
    # Dry run — list what would be removed without deleting anything
    .\Remove-LabResources.ps1 `
        -SubscriptionId "<your-subscription-id>" `
        -PrefixFilter "rg-lab-" `
        -WhatIf

.NOTES
    Resource group deletion is IRREVERSIBLE. All child resources (VMs, disks,
    NICs, public IPs, etc.) are permanently removed.

    Requires the Az.Resources module.
    Run: Install-Module -Name Az -Scope CurrentUser
#>
[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "ByName")]
param(
    [Parameter(Mandatory)]
    [string]$SubscriptionId,

    [Parameter(Mandatory, ParameterSetName = "ByName")]
    [string]$ResourceGroupName,

    [Parameter(Mandatory, ParameterSetName = "ByPrefix")]
    [string]$PrefixFilter,

    [Parameter()]
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Connect / set context ---------------------------------------------------

Write-Host "Setting subscription context..." -ForegroundColor Cyan
$context = Set-AzContext -SubscriptionId $SubscriptionId
Write-Host "  Subscription : $($context.Subscription.Name)" -ForegroundColor Gray

# --- Resolve target resource groups ------------------------------------------

if ($PSCmdlet.ParameterSetName -eq "ByName") {
    $targets = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction Stop
} else {
    $targets = Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -like "$PrefixFilter*" }

    if ($targets.Count -eq 0) {
        Write-Warning "No resource groups found matching prefix '$PrefixFilter'."
        exit 0
    }
}

# --- Preview targets ---------------------------------------------------------

Write-Host "`nResource groups to be deleted:" -ForegroundColor Yellow
foreach ($rg in $targets) {
    $resourceCount = (Get-AzResource -ResourceGroupName $rg.ResourceGroupName).Count
    Write-Host ("  {0,-45} ({1} resources)  [{2}]" -f `
        $rg.ResourceGroupName, $resourceCount, $rg.Location) -ForegroundColor Gray
}

Write-Host ""

# --- Confirm and delete ------------------------------------------------------

$deleted  = 0
$skipped  = 0
$failed   = 0

foreach ($rg in $targets) {
    $rgName = $rg.ResourceGroupName

    if (-not $Force) {
        $confirm = Read-Host "Delete '$rgName' and all its resources? [y/N]"
        if ($confirm -notmatch '^[Yy]') {
            Write-Host "  Skipped: $rgName" -ForegroundColor DarkGray
            $skipped++
            continue
        }
    }

    if ($PSCmdlet.ShouldProcess($rgName, "Delete resource group")) {
        try {
            Write-Host "  Deleting $rgName..." -ForegroundColor Cyan -NoNewline
            Remove-AzResourceGroup -Name $rgName -Force | Out-Null
            Write-Host " done." -ForegroundColor Green
            $deleted++
        } catch {
            Write-Host " FAILED." -ForegroundColor Red
            Write-Warning "  Error: $_"
            $failed++
        }
    }
}

# --- Summary -----------------------------------------------------------------

Write-Host "`n--- Summary ---" -ForegroundColor Cyan
Write-Host "  Deleted : $deleted" -ForegroundColor $(if ($deleted -gt 0) { "Green" } else { "Gray" })
Write-Host "  Skipped : $skipped" -ForegroundColor Gray
if ($failed -gt 0) {
    Write-Host "  Failed  : $failed" -ForegroundColor Red
}

if ($deleted -gt 0) {
    Write-Host "`nCredits freed. Verify remaining spend in Cost Management + Billing." -ForegroundColor Green
}

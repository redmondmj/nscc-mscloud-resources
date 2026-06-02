<#
.SYNOPSIS
    Lists (and optionally deletes) resource groups older than a specified number of days.

.DESCRIPTION
    Searches for resource groups tagged with 'nscc-pilot = vs-enterprise' and a
    'created-date' tag. Any group older than -DaysOld will be listed, and
    deleted if -Force is specified.

.PARAMETER DaysOld
    Age threshold in days. Defaults to 30.

.PARAMETER Force
    If specified, deletes matching resource groups. Without this flag the
    script only lists what would be deleted.

.EXAMPLE
    # Dry run — show stale groups without deleting
    .\Remove-StaleResources.ps1 -DaysOld 14

.EXAMPLE
    # Delete resource groups older than 30 days
    .\Remove-StaleResources.ps1 -DaysOld 30 -Force
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [int]$DaysOld = 30,
    [switch]$Force
)

$cutoff = (Get-Date).AddDays(-$DaysOld)

$groups = Get-AzResourceGroup | Where-Object {
    $_.Tags["nscc-pilot"] -eq "vs-enterprise" -and
    $_.Tags["created-date"] -and
    [datetime]::ParseExact($_.Tags["created-date"], "yyyy-MM-dd", $null) -lt $cutoff
}

if (-not $groups) {
    Write-Host "No stale resource groups found (older than $DaysOld days)." -ForegroundColor Green
    return
}

Write-Host "Found $($groups.Count) stale resource group(s):" -ForegroundColor Yellow
$groups | Select-Object ResourceGroupName, Location, @{N="CreatedDate";E={$_.Tags["created-date"]}} |
    Format-Table -AutoSize

if ($Force) {
    foreach ($rg in $groups) {
        if ($PSCmdlet.ShouldProcess($rg.ResourceGroupName, "Delete resource group")) {
            Write-Host "Deleting $($rg.ResourceGroupName)..." -ForegroundColor Red
            Remove-AzResourceGroup -Name $rg.ResourceGroupName -Force -AsJob | Out-Null
        }
    }
    Write-Host "Deletion jobs submitted. Run Get-Job to check progress." -ForegroundColor Cyan
} else {
    Write-Host "`nRe-run with -Force to delete these resource groups." -ForegroundColor Cyan
}

<#
.SYNOPSIS
    Creates a tagged Azure resource group for a student project.

.DESCRIPTION
    Creates a resource group in the specified region and applies standard tags
    used by the NSCC VS Enterprise pilot for cost tracking and cleanup.

.PARAMETER StudentId
    The student's NSCC ID (e.g., W0123456).

.PARAMETER ProjectName
    A short name for the project (no spaces).

.PARAMETER Location
    Azure region. Defaults to canadaeast.

.EXAMPLE
    .\New-StudentResourceGroup.ps1 -StudentId W0123456 -ProjectName MyWebApp

.EXAMPLE
    .\New-StudentResourceGroup.ps1 -StudentId W0123456 -ProjectName Lab01 -Location canadacentral
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory)]
    [string]$StudentId,

    [Parameter(Mandatory)]
    [string]$ProjectName,

    [string]$Location = "canadaeast"
)

$rgName = "rg-$($StudentId.ToLower())-$($ProjectName.ToLower())"

$tags = @{
    "nscc-pilot"   = "vs-enterprise"
    "student-id"   = $StudentId
    "project"      = $ProjectName
    "created-date" = (Get-Date -Format "yyyy-MM-dd")
}

if ($PSCmdlet.ShouldProcess($rgName, "Create resource group")) {
    $rg = New-AzResourceGroup -Name $rgName -Location $Location -Tag $tags
    Write-Host "Created resource group: $($rg.ResourceGroupName)" -ForegroundColor Green
    Write-Host "Location : $($rg.Location)"
    Write-Host "Tags     : $($tags | ConvertTo-Json -Compress)"
}

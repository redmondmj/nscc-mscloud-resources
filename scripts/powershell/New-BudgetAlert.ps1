#Requires -Modules Az.Billing, Az.Accounts
<#
.SYNOPSIS
    Creates an Azure Cost Management budget with email alert notifications.

.DESCRIPTION
    Creates a monthly budget scoped to a subscription or resource group,
    with configurable alert thresholds that send email notifications when
    spending approaches or exceeds the limit.

.PARAMETER SubscriptionId
    The Azure subscription ID to scope the budget to.

.PARAMETER ResourceGroupName
    Optional. If specified, the budget is scoped to this resource group
    rather than the full subscription.

.PARAMETER BudgetName
    Name for the budget. Defaults to "monthly-lab-budget".

.PARAMETER AmountCAD
    Monthly budget amount in Canadian dollars. Defaults to 150
    (conservative threshold below the ~CA$200 credit limit).

.PARAMETER AlertEmails
    One or more email addresses to notify when thresholds are hit.

.PARAMETER AlertThresholds
    Percentage thresholds at which to send alerts. Defaults to 80 and 100.

.EXAMPLE
    .\New-BudgetAlert.ps1 `
        -SubscriptionId "<your-subscription-id>" `
        -AlertEmails "instructor@nscc.ca" `
        -AmountCAD 150

.EXAMPLE
    .\New-BudgetAlert.ps1 `
        -SubscriptionId "<your-subscription-id>" `
        -ResourceGroupName "rg-lab-jsmith" `
        -BudgetName "jsmith-lab-budget" `
        -AmountCAD 50 `
        -AlertEmails "jsmith@nscc.ca", "instructor@nscc.ca"

.NOTES
    Requires the Az.Billing module (part of the Az module).
    Run: Install-Module -Name Az -Scope CurrentUser
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$SubscriptionId,

    [Parameter()]
    [string]$ResourceGroupName,

    [Parameter()]
    [string]$BudgetName = "monthly-lab-budget",

    [Parameter()]
    [decimal]$AmountCAD = 150,

    [Parameter(Mandatory)]
    [string[]]$AlertEmails,

    [Parameter()]
    [int[]]$AlertThresholds = @(80, 100)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Connect / set context ---------------------------------------------------

Write-Host "Setting subscription context..." -ForegroundColor Cyan
$context = Set-AzContext -SubscriptionId $SubscriptionId

Write-Host "  Subscription : $($context.Subscription.Name)" -ForegroundColor Gray
Write-Host "  Account      : $($context.Account.Id)" -ForegroundColor Gray

# --- Determine scope ---------------------------------------------------------

if ($ResourceGroupName) {
    $scope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName"
    Write-Host "  Scope        : Resource Group — $ResourceGroupName" -ForegroundColor Gray
} else {
    $scope = "/subscriptions/$SubscriptionId"
    Write-Host "  Scope        : Subscription" -ForegroundColor Gray
}

# --- Build notification list -------------------------------------------------

$notifications = @{}
foreach ($threshold in $AlertThresholds) {
    $key = "Alert_${threshold}pct"
    $notifications[$key] = New-AzConsumptionBudgetNotification `
        -NotificationKey         $key `
        -Threshold               $threshold `
        -ContactEmail            $AlertEmails `
        -Enabled                 $true `
        -NotificationThresholdType Actual `
        -Operator                GreaterThan
}

# --- Set budget window -------------------------------------------------------

# Budget runs from the 1st of the current month, recurring monthly.
$startDate = Get-Date -Day 1 -Hour 0 -Minute 0 -Second 0

# AzConsumptionBudget end date must be in the future; set 3 years out.
$endDate = $startDate.AddYears(3)

# --- Create budget -----------------------------------------------------------

Write-Host "`nCreating budget '$BudgetName'..." -ForegroundColor Cyan
Write-Host "  Amount       : CA`$$AmountCAD / month" -ForegroundColor Gray
Write-Host "  Thresholds   : $($AlertThresholds -join '%, ')%" -ForegroundColor Gray
Write-Host "  Recipients   : $($AlertEmails -join ', ')" -ForegroundColor Gray

if ($PSCmdlet.ShouldProcess($scope, "Create budget '$BudgetName'")) {
    $budget = New-AzConsumptionBudget `
        -Name          $BudgetName `
        -Amount        $AmountCAD `
        -Category      Cost `
        -TimeGrain     Monthly `
        -StartDate     $startDate `
        -EndDate       $endDate `
        -Notification  $notifications

    Write-Host "`n✓ Budget created successfully." -ForegroundColor Green
    Write-Host "  Budget ID : $($budget.Id)" -ForegroundColor Gray
    Write-Host "`nVerify in the Azure portal:" -ForegroundColor Cyan
    Write-Host "  Cost Management + Billing → Monitoring → Budgets" -ForegroundColor Gray
}

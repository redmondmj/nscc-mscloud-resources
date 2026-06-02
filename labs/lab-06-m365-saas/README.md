# Lab 06 — M365 Administration (SaaS-yness)

**Difficulty:** Intermediate  
**Estimated time:** 90–120 minutes  
**M365 services used:** Microsoft Entra ID, Exchange Online, Microsoft Defender XDR, SharePoint Online, Microsoft Teams

---

## Prerequisites and Rules of Engagement

You have been granted **Global Administrator** access to the shared sandbox M365 tenant. Because you are sharing this environment with your peers, follow these rules strictly:

**Naming convention:** Every user, group, mailbox, site, or policy you create **must** begin with your initials and a hyphen.

> Example: If your name is Jane Doe, your test user must be named `JD-TestUser` and your SharePoint site `JD-ProjectAlpha`.

**Do not touch others' resources.** If a resource is prefixed with someone else's initials, leave it alone.

---

## Environment Setup — PowerShell

Open PowerShell as Administrator and run the following before starting the lab tasks.

### Step 1 — Allow scripts to run

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Step 2 — Install required modules

Press `Y` or `A` if prompted to trust PSGallery.

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Install-Module ExchangeOnlineManagement -Scope CurrentUser
Install-Module Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser
Install-Module MicrosoftTeams -Scope CurrentUser
```

### Step 3 — Connect to the services

Authenticate with your assigned Global Admin credentials. You can run each connection command as you reach the relevant lab part.

```powershell
# Entra ID
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "RoleManagement.ReadWrite.Directory"

# Exchange Online
Connect-ExchangeOnline

# SharePoint Online — replace <tenant-prefix> with your tenant's prefix
Connect-SPOService -Url "https://<tenant-prefix>-admin.sharepoint.com"

# Microsoft Teams
Connect-MicrosoftTeams
```

---

## Part 1 — Microsoft Entra ID (Identity and Access)

**Scenario:** Your organization is expanding. Provision a new employee, assign them to a department group, and grant them helpdesk admin privileges.

### Task 1.1 — Create a new user

**Web GUI:**
1. Navigate to the [Microsoft Entra admin center](https://entra.microsoft.com) → Users → All users.
   > Links to all admin centers are available at the bottom-right of [admin.microsoft365.com](https://admin.microsoft365.com).
2. Click **New user → Create new user**.
3. Display Name: `[Initials]-HelpdeskUser`  
   UPN: `[Initials]-HelpdeskUser@<tenant-domain>`  
   Set a password you can remember.

**PowerShell:**
```powershell
Connect-MgGraph -Scopes "User.ReadWrite.All"

New-MgUser `
  -DisplayName "[Initials]-HelpdeskUser" `
  -UserPrincipalName "[Initials]-HelpdeskUser@<tenant-domain>" `
  -AccountEnabled `
  -PasswordProfile @{Password="ComplexP@ssw0rd!"; ForceChangePasswordNextSignIn=$false} `
  -MailNickname "[Initials]-HelpdeskUser"
```

Reference: [Add or delete users in Entra](https://learn.microsoft.com/en-us/entra/fundamentals/how-to-manage-users)

---

### Task 1.2 — Create a security group and add members

**Web GUI:**
1. Go to **Groups → All groups → New group**.
2. Group type: **Security**. Group name: `[Initials]-ITSupport`.
3. Under Members, search for your `[Initials]-HelpdeskUser` and add them.

**PowerShell:**
```powershell
Connect-MgGraph -Scopes "Group.ReadWrite.All", "Directory.ReadWrite.All"

# Create the group and capture its ID
$group = New-MgGroup `
  -DisplayName "[Initials]-ITSupportPS" `
  -MailEnabled:$false `
  -SecurityEnabled:$true `
  -MailNickname "[Initials]-ITSupportPS"

# Get your user's ID
$user = Get-MgUser -UserId "[Initials]-HelpdeskUserPS@<tenant-domain>"

# Add user to group
New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $user.Id
```

Reference: [Manage Entra groups and members](https://learn.microsoft.com/en-us/entra/fundamentals/how-to-manage-groups)

---

### Task 1.3 — Assign Role-Based Access Control (RBAC)

Grant your test user the **Helpdesk Administrator** role so they can reset passwords for non-admins.

**Web GUI:**
1. Go to **Roles and administrators → Roles and admins**.
2. Search for and select **Helpdesk Administrator**.
3. Click **Add assignments**, search for your `[Initials]-HelpdeskUser`, and click **Add**.

---

### Task 1.4 — Manage Multi-Factor Authentication (MFA)

Simulate supporting a user who has lost access to their authenticator device.

1. **Initial setup:** Open a private/incognito window and sign in to [portal.microsoft.com](https://portal.microsoft.com) as `[Initials]-HelpdeskUser`. Complete the MFA registration prompts, then sign out and close the private window.
2. **Force re-registration:** Back in your Global Admin session, go to Entra admin center → Users → All users → select your `[Initials]-HelpdeskUser`.
3. Under **Manage**, select **Authentication methods**.
4. Click **Require re-register MFA**. This invalidates their current MFA methods.
5. **Verify:** Open a new private window, sign in as `[Initials]-HelpdeskUser` — you should be prompted to set up MFA from scratch.

Reference: [Assign Microsoft Entra roles](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/manage-roles-portal)

---

## Part 2 — Exchange Admin Center (Mail Flow and Delegation)

**Scenario:** The customer success team needs a shared inbox for client inquiries.

### Task 2.1 — Create a shared mailbox

**Web GUI:**
1. Navigate to the [Exchange admin center](https://admin.exchange.microsoft.com) → Recipients → Mailboxes.
2. Click **Add a shared mailbox**.
3. Display Name: `[Initials]-CustomerSuccess`  
   Email: `[Initials]-CS@<tenant-domain>`

**PowerShell:**
```powershell
Connect-ExchangeOnline

New-Mailbox `
  -Shared `
  -Name "[Initials]-CustomerSuccessPS" `
  -DisplayName "[Initials] Customer Success PS" `
  -PrimarySmtpAddress "[Initials]-CSPS@<tenant-domain>"
```

> **Troubleshooting — "Method not found: WithBroker..."**  
> This error means your PowerShell session has a module conflict between the Graph and Exchange modules. Fix: close your PowerShell window completely, open a **new** Administrator PowerShell window, and run `Connect-ExchangeOnline` before anything else.

Reference: [Create a shared mailbox](https://learn.microsoft.com/en-us/microsoft-365/admin/email/create-a-shared-mailbox)

---

### Task 2.2 — Delegate mailbox access

Grant your own Global Admin account **Full Access** and **Send As** permissions.

**Web GUI:**
1. In the EAC, select your `[Initials]-CustomerSuccess` mailbox.
2. Under the **Delegation** tab, click **Edit** under **Read and manage (Full Access)**. Add your admin account.
3. Repeat for **Send as**.

**PowerShell:**
```powershell
# Grant Full Access
Add-MailboxPermission `
  -Identity "[Initials]-CustomerSuccessPS" `
  -User "YourAdminEmail@<tenant-domain>" `
  -AccessRights FullAccess `
  -InheritanceType All

# Grant Send As
Add-RecipientPermission `
  -Identity "[Initials]-CustomerSuccessPS" `
  -Trustee "YourAdminEmail@<tenant-domain>" `
  -AccessRights SendAs
```

Reference: [Manage mailbox permissions](https://learn.microsoft.com/en-us/exchange/recipients-in-exchange-online/manage-permissions-for-recipients)

---

## Part 3 — Microsoft Defender XDR (Security Posture and Operations)

**Scenario:** Assess tenant security health, explore the incident dashboard, and run a phishing simulation.

### Task 3.1 — Assess Microsoft Secure Score

1. Navigate to the [Microsoft Defender portal](https://security.microsoft.com) → **Secure Score**.
2. Click the **Recommended actions** tab.
3. Identify the **top 3 recommended actions** with the highest impact score. Document what they are and briefly explain how implementing each would improve security.

Reference: [Microsoft Secure Score](https://learn.microsoft.com/en-us/defender-xdr/microsoft-secure-score)

---

### Task 3.2 — Investigate incidents and alerts

1. In the Defender portal, go to **Incidents & alerts → Incidents**.
2. Review any active incidents. If the queue is empty, check **Alerts** for individual flagged events.
3. Click an alert to review its incident graph, affected assets, and evidence in the side panel.

Reference: [Investigate incidents in Microsoft Defender XDR](https://learn.microsoft.com/en-us/defender-xdr/investigate-incidents)

---

### Task 3.3 — Launch a phishing simulation

1. In the Defender portal, go to **Email & collaboration → Attack simulation training**.
2. Click **Simulations → Launch a simulation**.
3. Choose a payload (e.g., **Credential Harvest**).
4. Name your simulation: `[Initials]-PhishingTest`.
5. Target only your `[Initials]-HelpdeskUser` — do not target all employees.
6. Complete the wizard and launch.

Reference: [Simulate a phishing attack](https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/attack-simulation-training-simulations)

---

## Part 4 — SharePoint Admin Center (Content and Intranet)

**Scenario:** Provision a secure collaborative space for a new project.

### Task 4.1 — Create a SharePoint site

**Web GUI:**
1. Navigate to the [SharePoint admin center](https://admin.microsoft.com/sharepoint) → Sites → Active sites.
2. Click **Create → Team site**.
3. Site name: `[Initials]-ProjectAlpha`. Add yourself as Primary admin.

**PowerShell:**
```powershell
Connect-SPOService -Url "https://<tenant-prefix>-admin.sharepoint.com"

New-SPOSite `
  -Url "https://<tenant-prefix>.sharepoint.com/sites/[Initials]-ProjectAlphaPS" `
  -Owner "YourAdminEmail@<tenant-domain>" `
  -StorageQuota 1024 `
  -Title "[Initials] Project Alpha PS"
```

Reference: [Create a site collection](https://learn.microsoft.com/en-us/sharepoint/create-site-collection)

---

### Task 4.2 — Manage site storage limits

**Web GUI:**
1. In Active sites, click your `[Initials]-ProjectAlpha` site.
2. In the properties panel, go to the **Settings** tab.
3. Edit the **Storage limit** to **5 GB (5120 MB)**.

**PowerShell:**
```powershell
Set-SPOSite `
  -Identity "https://<tenant-prefix>.sharepoint.com/sites/[Initials]-ProjectAlphaPS" `
  -StorageQuota 5120
```

Reference: [Manage site storage limits](https://learn.microsoft.com/en-us/sharepoint/manage-site-collection-storage-limits)

---

### Task 4.3 — Configure network location access control

> **Coordinate with your instructor before applying tenant-wide IP restrictions — an incorrect IP range can lock everyone out of the tenant.**

**Web GUI:**
1. In the SharePoint admin center, go to **Policies → Access control**.
2. Click **Network location**. Toggle "Allow access only from specific IP address locations" to **On**.
3. Enter a test IP range (e.g., `192.168.1.1/24`).

**PowerShell:**
```powershell
Set-SPOTenant -IPAddressEnforcement $true -IPAddressAllowList "192.168.1.1/24"
```

Reference: [Control access based on network location](https://learn.microsoft.com/en-us/sharepoint/control-access-based-on-network-location)

---

## Part 5 — Microsoft Teams Admin Center (Communication)

**Scenario:** Stand up a cross-departmental task force team and restrict helpdesk users from creating unauthorized channels.

### Task 5.1 — Create and manage a team

**Web GUI:**
1. Navigate to the [Teams admin center](https://admin.teams.microsoft.com) → Teams → Manage teams.
2. Click **Add**. Name: `[Initials]-TaskForce`. Add yourself as owner.
3. Once created, select the team → **Add members** → add your `[Initials]-HelpdeskUser`.

**PowerShell:**
```powershell
Connect-MicrosoftTeams

$team = New-Team -DisplayName "[Initials]-TaskForcePS" -Visibility Private

Add-TeamUser -GroupId $team.GroupId -User "[Initials]-HelpdeskUser@<tenant-domain>"
```

Reference: [Manage teams in the admin center](https://learn.microsoft.com/en-us/microsoftteams/manage-teams-in-modern-portal)

---

### Task 5.2 — Create a Teams channel management policy

Restrict helpdesk users from creating private or shared channels.

**Web GUI:**
1. In the Teams admin center, go to **Teams → Teams policies → Add**.
2. Name the policy `[Initials]-RestrictChannels`.
3. Toggle **Create private channels** and **Create shared channels** to **Off**. Click **Save**.
4. Select the policy → **Manage users** → assign to your `[Initials]-HelpdeskUser`.

**PowerShell:**
```powershell
New-CsTeamsChannelsPolicy `
  -Identity "[Initials]-RestrictChannelsPS" `
  -AllowPrivateChannelCreation $false

Grant-CsTeamsChannelsPolicy `
  -Identity "[Initials]-HelpdeskUser@<tenant-domain>" `
  -PolicyName "[Initials]-RestrictChannelsPS"
```

Reference: [Manage teams policies](https://learn.microsoft.com/en-us/microsoftteams/teams-policies)

---

## Submission and Verification

No separate submission required — completion is verified by the instructor.

Run the audit script below before wrapping up. **You must complete the three TODO sections** before the script will run correctly.

```powershell
<#
.SYNOPSIS
    Student audit script for NETW3500 Lab 6 — M365 SaaS-yness.
.DESCRIPTION
    Verifies users, groups, mailboxes, SharePoint sites, and Teams
    created during the lab based on your initials.

    Complete the three TODO sections before running.
#>

# ==============================================================================
# TODO 1 — Fill in your lab variables
# ==============================================================================
$Initials     = "FILL_THIS_IN"   # e.g. "JD"
$AdminEmail   = "FILL_THIS_IN"   # e.g. "admin@<tenant-domain>"
$TenantPrefix = "FILL_THIS_IN"   # the part before .onmicrosoft.com

# ==============================================================================
# TODO 2 — Customize output colors (must differ from the defaults below)
# Valid: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta,
#        DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White
# ==============================================================================
$SuccessColor = "Green"   # change this
$FailColor    = "Red"     # change this

$Domain     = "$TenantPrefix.onmicrosoft.com"
$SpoAdminUrl = "https://$TenantPrefix-admin.sharepoint.com"

function Write-Result {
    param([string]$Task, [bool]$Passed, [string]$Details = "")
    if ($Passed) {
        Write-Host "[ PASS ] " -ForegroundColor $SuccessColor -NoNewline
        Write-Host $Task
        if ($Details) { Write-Host "         > $Details" -ForegroundColor DarkGray }
    } else {
        Write-Host "[ FAIL ] " -ForegroundColor $FailColor -NoNewline
        Write-Host $Task
        if ($Details) { Write-Host "         > $Details" -ForegroundColor DarkGray }
    }
}

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  NETW3500 Lab 6 Audit — Initials: $Initials"       -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# --- Connections ---
Write-Host "Verifying connections..." -ForegroundColor Yellow

# Connect Exchange first to avoid MSAL assembly conflict with Graph
if (-not (Get-Command Get-Mailbox -ErrorAction SilentlyContinue)) {
    Write-Host "Connecting to Exchange Online..."
    try {
        Connect-ExchangeOnline -UserPrincipalName $AdminEmail -ShowProgress $false
    } catch {
        if ($_.Exception.Message -match "WithBroker") {
            Write-Host "`n[!] MODULE CONFLICT [!]" -ForegroundColor Red
            Write-Host "Close this PowerShell window, open a new one, and run the script again." -ForegroundColor Yellow
            exit
        } else { throw $_ }
    }
}

try { $null = Get-MgUser -Top 1 -ErrorAction Stop }
catch {
    Write-Host "Connecting to Microsoft Graph..."
    Connect-MgGraph -Scopes "User.Read.All","Group.Read.All","RoleManagement.Read.Directory" -NoWelcome
}

if (-not (Get-SPOSite -Limit 1 -ErrorAction SilentlyContinue)) {
    Write-Host "Connecting to SharePoint Online..."
    Connect-SPOService -Url $SpoAdminUrl
}

if (-not (Get-Team -ErrorAction SilentlyContinue)) {
    Write-Host "Connecting to Microsoft Teams..."
    Connect-MicrosoftTeams
}

Write-Host "`nStarting audit...`n" -ForegroundColor Yellow

# --- Part 1: Entra ID ---
Write-Host "--- Part 1: Entra ID ---" -ForegroundColor Cyan

$helpdeskUsers = Get-MgUser -Filter "startswith(UserPrincipalName,'$Initials-HelpdeskUser')" -ErrorAction SilentlyContinue
Write-Result "Task 1.1: Create Helpdesk User" ($null -ne $helpdeskUsers) "Found $($helpdeskUsers.Count) matching user(s)"

$itGroups = Get-MgGroup -Filter "startswith(DisplayName,'$Initials-ITSupport')" -ErrorAction SilentlyContinue
Write-Result "Task 1.2: Create IT Support Group" ($null -ne $itGroups) "Found $($itGroups.Count) matching group(s)"

if ($itGroups -and $helpdeskUsers) {
    $members = Get-MgGroupMember -GroupId $itGroups[0].Id -ErrorAction SilentlyContinue
    $isMember = $members | Where-Object { $_.Id -eq $helpdeskUsers[0].Id }
    Write-Result "Task 1.2b: Add User to Group" ($null -ne $isMember)
} else {
    Write-Result "Task 1.2b: Add User to Group" $false "Group or user not found"
}

try {
    $role = Get-MgDirectoryRole -Filter "DisplayName eq 'Helpdesk Administrator'" -ErrorAction SilentlyContinue
    if ($role -and $helpdeskUsers) {
        $roleMembers = Get-MgDirectoryRoleMember -DirectoryRoleId $role.Id -ErrorAction SilentlyContinue
        $hasRole = $roleMembers | Where-Object { $_.Id -eq $helpdeskUsers[0].Id }
        Write-Result "Task 1.3: Assign Helpdesk Admin Role" ($null -ne $hasRole)
    } else {
        Write-Result "Task 1.3: Assign Helpdesk Admin Role" $false "Role or user not found"
    }
} catch {
    Write-Result "Task 1.3: Assign Helpdesk Admin Role" $false "Insufficient Graph permissions to read roles"
}

Write-Host ""

# --- Part 2: Exchange Online ---
Write-Host "--- Part 2: Exchange Online ---" -ForegroundColor Cyan

$mailboxes = Get-Mailbox -Filter "Name -like '$Initials-CustomerSuccess*'" -ErrorAction SilentlyContinue
Write-Result "Task 2.1: Create Shared Mailbox" ($null -ne $mailboxes) "Found: $($mailboxes[0].PrimarySmtpAddress)"

if ($mailboxes) {
    $fullAccess = Get-MailboxPermission -Identity $mailboxes[0].Identity -User $AdminEmail -ErrorAction SilentlyContinue |
        Where-Object { $_.AccessRights -contains "FullAccess" -and $_.IsInherited -eq $false }
    Write-Result "Task 2.2a: Grant Full Access" ($null -ne $fullAccess)

    $sendAs = Get-RecipientPermission -Identity $mailboxes[0].Identity -Trustee $AdminEmail -ErrorAction SilentlyContinue |
        Where-Object { $_.AccessRights -contains "SendAs" }
    Write-Result "Task 2.2b: Grant Send As" ($null -ne $sendAs)
} else {
    Write-Result "Task 2.2a: Grant Full Access" $false "Mailbox not found"
    Write-Result "Task 2.2b: Grant Send As"    $false "Mailbox not found"
}

Write-Host ""

# --- Part 4: SharePoint Online ---
Write-Host "--- Part 4: SharePoint Online ---" -ForegroundColor Cyan

$spoSites = Get-SPOSite -Limit All | Where-Object { $_.Url -match "$Initials-ProjectAlpha" }
Write-Result "Task 4.1: Create SharePoint Site" ($null -ne $spoSites) "Found: $($spoSites[0].Url)"

if ($spoSites) {
    $quotaMB = $spoSites[0].StorageQuota
    Write-Result "Task 4.2: Storage Limit = 5 GB" ($quotaMB -eq 5120) "Quota is $quotaMB MB (expected 5120)"
} else {
    Write-Result "Task 4.2: Storage Limit = 5 GB" $false "Site not found"
}

Write-Host ""

# --- Part 5: Microsoft Teams ---
Write-Host "--- Part 5: Microsoft Teams ---" -ForegroundColor Cyan

$teams = Get-Team -DisplayName "$Initials-TaskForce*" -ErrorAction SilentlyContinue
Write-Result "Task 5.1: Create Team" ($null -ne $teams) "Found: $($teams[0].DisplayName)"

$teamPolicies = Get-CsTeamsChannelsPolicy -Filter "$Initials-RestrictChannels*" -ErrorAction SilentlyContinue
Write-Result "Task 5.2: Create Teams Policy" ($null -ne $teamPolicies) "Found: $($teamPolicies.Identity)"

Write-Host ""
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host " Audit complete!" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

# ==============================================================================
# TODO 3 — Add a personalized completion message containing your full name
# ==============================================================================
Write-Host "FILL_THIS_IN" -ForegroundColor Cyan
```

---

## Checkpoint questions

1. What is the difference between a **Security group** and a **Microsoft 365 group** in Entra ID?
2. Why does `Connect-ExchangeOnline` need to be run in a fresh PowerShell session when the Graph module is already loaded?
3. What does the "Helpdesk Administrator" role allow that the default user account cannot do?

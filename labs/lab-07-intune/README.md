# Lab 07 — Advanced Endpoint Management with Microsoft Intune

**Difficulty:** Intermediate  
**Estimated time:** 75–90 minutes  
**Services used:** Microsoft Intune, Microsoft Entra ID, Microsoft Defender for Endpoint

---

## Objective

Expand on basic device connectivity by actively managing a Windows 11 endpoint. You will join a fresh VM to Entra ID, enforce configuration profiles, deploy Microsoft 365 Apps, apply a Defender antivirus policy, run a background PowerShell script via Intune, and validate the results on the device.

---

## Prerequisites

- A fresh Windows 11 Virtual Machine (e.g., CLIENT3 or CLIENT4).
- Access to the [Microsoft Intune admin center](https://intune.microsoft.com) with your assigned administrative credentials.

---

## Part 0 — Entra ID Join and Intune Enrollment

Before Intune can manage the device, the VM must be joined to Microsoft Entra ID.

1. Log in to your Windows 11 VM using the **local administrator** account.
2. Open **Start → Settings → Accounts → Access work or school**.
3. Click **Connect**.
4. **Critical:** On the "Set up a work or school account" screen, do **not** enter your email immediately.

   > Look at the bottom of the window under **Alternate actions** and click **"Join this device to Microsoft Entra ID"** (also shown as "Join this device to Azure Active Directory"). Enter your credentials only after clicking that link — otherwise the device will not domain-join correctly.

5. Enter your assigned lab email address and password. Review the organization details and click **Join**, then **Done**.
6. Open **Command Prompt** and run:
   ```
   dsregcmd /status
   ```
   Scroll to the top and confirm that `AzureAdJoined` shows `YES`.

7. Sign out of the local administrator account. On the lock screen, select **Other user** (bottom-left) and sign in with your lab email address.

---

## Part 1 — Device Configuration (Settings Catalog Profile)

Lock down the taskbar by removing the Task View button using an Intune configuration profile.

1. In the Intune admin center, navigate to **Devices → Manage Devices → Configuration → + Create policy**.
2. Select:
   - Platform: **Windows 10 and later**
   - Profile type: **Settings catalog**
   - Click **Create**.
3. Name the profile `Taskbar Restrictions - [Your Initials]` and click **Next**.
4. In **Configuration settings**, click **+ Add settings**. In the search box, type `Task View` and click **Search**.
5. Enable the **Hide Task View Button** setting.

   > **If the setting does not appear in the catalog**, use a Custom profile instead (Templates → Custom) with the following OMA-URI:
   > - OMA-URI: `./Device/Vendor/MSFT/Policy/Config/Start/HideTaskViewButton`
   > - Data type: Integer
   > - Value: `1`
   > - Applicability rule: OS edition = Windows 10 and later

6. On the **Assignments** step, assign the profile to your designated lab group.
7. Click **Review + create → Create**.

---

## Part 2 — App Deployment (Microsoft 365 Apps)

Push the Office suite directly to your enrolled VM.

1. Navigate to **Apps → All apps → + Add**.
2. Under **App type**, select **Microsoft 365 Apps → Windows 10 and later**. Click **Select**.
3. Change the app suite name to `App Install - [Your Initials]` and click **Next**.
4. On **Configure app suite**, set the following:
   - Apps to include: **Excel, OneNote, Outlook, PowerPoint, Word**
   - Default file format: **Office Open XML**
   - Update channel: **Monthly Enterprise Channel**
   - Accept the Microsoft Software License Terms on behalf of users: **Yes**
5. Assign to your lab group and click **Create**.

---

## Part 3 — Security (Windows Defender Antivirus Policy)

Enforce specific Defender settings via an Endpoint Security antivirus profile.

1. Navigate to **Endpoint Security → Antivirus**.
2. Click **+ Create policy**.
3. Choose **Windows → Microsoft Defender Antivirus**.
4. Name the profile `WDAV Demo - [Your Initials]` and configure the following settings:

   | Setting | Value |
   |---------|-------|
   | Real-time monitoring | Enable |
   | Behavior monitoring | Allowed |
   | Scan all downloaded files and attachments | Allowed |
   | Cloud-delivered protection | Allowed |

5. Assign to your lab group and click **Create**.

---

## Part 4 — PowerShell Script Deployment

Use the Intune Management Extension to silently run a script on the VM as the SYSTEM account.

1. On your **host machine**, open Notepad and paste the following. Save it as `LabSetup.ps1`.

```powershell
New-Item -Path "C:\Lab-Success" -ItemType Directory
Out-File -FilePath "C:\Lab-Success\IntuneScriptRan.txt" -InputObject "Script successfully executed via Intune!"
```

2. In the Intune admin center, navigate to **Devices → Scripts and remediations → Platform scripts → + Add → Windows 10 and later**.
3. Name the script `Create Lab Folder - [Your Initials]` and click **Next**.
4. Configure the script settings:
   - Upload your `LabSetup.ps1` file.
   - Run this script using the logged on credentials: **No** (runs as SYSTEM)
   - Enforce script signature check: **No**
   - Run script in 64-bit PowerShell host: **Yes**
5. Assign to your lab group and click **Add**.

---

## Part 5 — Validation on the Endpoint

Log into the VM and force a policy sync to apply all configurations without waiting for the default check-in cycle.

1. On your Windows 11 VM, go to **Settings → Accounts → Access work or school**.
2. Select your work/school connection → click **Info** → scroll down and click **Sync**. This triggers an immediate Intune check-in.

   > App deployments and scripts may still take 10–15 minutes to fully process after sync.

3. **Verify Part 1 (Taskbar):** The Task View button (overlapping squares) should be absent from the taskbar. In **Settings → Personalization → Taskbar**, the toggle for Task View will show "managed by your organization".

   > **Troubleshooting:** If the policy hasn't applied, check **Devices → Manage Devices → Configuration → [your profile]** for success/failure status. Confirm your user or device is a member of the assigned group (**Groups → All Groups → [your group] → Members**). If you added your user to the group after enrollment, sign into the machine with that user account.

4. **Verify Part 2 (Apps):** Open the Start Menu and confirm Word and Excel are installed.

5. **Verify Part 4 (Script):** Open File Explorer, navigate to `C:\`, and confirm the `Lab-Success` folder and `IntuneScriptRan.txt` file exist.

   > If the folder is missing, force the management extension to re-check:
   > ```powershell
   > Restart-Service -Name IntuneManagementExtension
   > ```
   > Then sign out and sign back in as your cloud (Entra ID) user.

---

## Deliverables

Submit a single document containing the following screenshots:

| # | Screenshot |
|---|-----------|
| 1 | **Access work or school → Info** screen showing successful MDM enrollment |
| 2 | Windows 11 desktop showing the taskbar (Task View button absent) **and** Settings → Personalization → Taskbar showing the setting is managed |
| 3 | Start Menu showing installed Microsoft Word and Excel |
| 4 | File Explorer open to `C:\Lab-Success` showing the `IntuneScriptRan.txt` file |

---

## Checkpoint questions

1. What is the difference between **Entra ID Join** and **Entra ID Registered**? When would you use each?
2. Why is it important to set "Run this script using the logged on credentials" to **No** for the `LabSetup.ps1` script?
3. An Intune configuration profile shows "Pending" after 30 minutes. What are three things you would check to troubleshoot the delay?

# Lab 01 — Deploy a Linux VM and Connect via SSH

**Difficulty:** Beginner  
**Estimated time:** 30–45 minutes  
**Azure services used:** Virtual Machines, Virtual Networks, Network Security Groups

---

## Objectives

By the end of this lab you will be able to:

1. Create a resource group in the Azure Portal.
2. Deploy an Ubuntu 22.04 LTS virtual machine.
3. Connect to the VM over SSH from your local machine.
4. Deallocate the VM when finished to stop billing.

---

## Prerequisites

- An activated Azure subscription (see [Getting Started](../../docs/getting-started.md)).
- A terminal with SSH support (macOS/Linux Terminal, Windows Terminal, or Git Bash).

---

## Part 1 — Create a resource group

1. Sign in to [portal.azure.com](https://portal.azure.com).
2. In the search bar, type **Resource groups** and select it.
3. Click **+ Create**.
4. Fill in the fields:
   - **Subscription:** your VS Enterprise subscription
   - **Resource group:** `rg-<your-student-id>-lab01` (e.g., `rg-w0123456-lab01`)
   - **Region:** Canada East
5. Click **Review + create**, then **Create**.

---

## Part 2 — Deploy an Ubuntu VM

1. In the Azure Portal, search for **Virtual machines** and click **+ Create → Azure virtual machine**.
2. **Basics tab:**
   - Resource group: select the one you just created.
   - VM name: `vm-lab01`
   - Region: Canada East
   - Image: **Ubuntu Server 22.04 LTS - x64 Gen2**
   - Size: **Standard_B2s** (click *See all sizes* if needed)
   - Authentication type: **SSH public key**
   - Username: `nsccadmin`
   - SSH public key source: **Generate new key pair** (save the `.pem` file when prompted)
3. **Disks tab:** leave defaults (Standard SSD).
4. **Networking tab:** leave defaults — Azure will create a VNet, subnet, and NSG with port 22 open.
5. Click **Review + create**, then **Create**.
6. When prompted, download the private key (`.pem` file) and save it somewhere safe.

Wait 2–3 minutes for the deployment to complete.

---

## Part 3 — Connect via SSH

### On macOS / Linux

```bash
# Fix permissions on the key file
chmod 400 ~/Downloads/vm-lab01_key.pem

# Connect (replace <public-ip> with the IP shown in the portal)
ssh -i ~/Downloads/vm-lab01_key.pem nsccadmin@<public-ip>
```

### On Windows (PowerShell or Windows Terminal)

```powershell
# Fix permissions on the key file (run once)
icacls "$env:USERPROFILE\Downloads\vm-lab01_key.pem" /inheritance:r /grant:r "$($env:USERNAME):R"

# Connect
ssh -i "$env:USERPROFILE\Downloads\vm-lab01_key.pem" nsccadmin@<public-ip>
```

You should see an Ubuntu shell prompt. Run a few commands to verify:

```bash
uname -a
df -h
free -m
```

---

## Part 4 — Clean up

**Important:** Always deallocate VMs when not in use to stop compute charges.

In the Portal:
1. Navigate to **Virtual machines → vm-lab01**.
2. Click **Stop** and confirm. Wait for the status to show **Stopped (deallocated)**.

Or with Azure CLI:
```bash
az vm deallocate --resource-group rg-<your-id>-lab01 --name vm-lab01
```

To permanently delete all lab resources, delete the resource group:
```bash
az group delete --name rg-<your-id>-lab01 --yes --no-wait
```

---

## Checkpoint questions

1. What is the difference between *Stopped* and *Stopped (deallocated)* in Azure?
2. What NSG rule was automatically created to allow SSH access?
3. How would you attach a second data disk to this VM?

---

## Next steps

- Try deploying the same VM using the Bicep template in [`scripts/bicep/student-vm/`](../../scripts/bicep/student-vm/).
- Explore Lab 02 (coming soon): Deploy a web app to Azure App Service.

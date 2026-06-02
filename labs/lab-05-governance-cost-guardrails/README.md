# Lab 05 — Azure Governance, Cost, and Guardrails

**Difficulty:** Intermediate  
**Estimated time:** 60–75 minutes  
**Azure services used:** Azure Policy, Cost Management, Resource Locks, Azure Pricing Calculator

---

## Scenario

You are a Cloud Architect at a startup. Developers are accidentally deploying expensive virtual machines and forgetting to tag them, making the bill impossible to track. Your job is to implement **guardrails** to prevent overspending and ensure accountability.

---

## Prerequisites

- An activated Azure subscription with your resource group already created (see [Getting Started](../../docs/getting-started.md)).
- **Owner** role on your resource group. If you have not been elevated to Owner yet, message your instructor before starting.
- Azure CLI installed and logged in (`az login`).

---

## Part 1 — Setting the Guardrails (Azure Policy)

Enforce a rule that only allows cheap, student-budget VM sizes within your resource group.

1. In the Azure Portal, navigate to **Policy → Definitions**.
2. Search for the built-in policy: **"Allowed virtual machine size SKUs"**.
3. Click the policy → **Assign**.
4. Set the **Scope** to your resource group.
5. On the **Parameters** tab, uncheck **"Only show parameters that need input"** and select **only** `Standard_B1s` and `Standard_B2s`.
6. Click **Review + create** → **Create**.

### CLI Challenge — Try to bypass the policy

Attempt to deploy a VM that violates the policy:

```bash
az vm create \
  --resource-group <your-rg> \
  --name "IllegalVM" \
  --image Win2022Datacenter \
  --size Standard_D2s_v3
```

**Expected result:** The deployment fails with a `RequestDisallowedByPolicy` error.

> **Deliverable:** Take a screenshot of this error message in your terminal.

---

## Part 2 — Accountability and Success (Tags and a Compliant VM)

Deploy a compliant resource with billing metadata attached.

```bash
az vm create \
  --resource-group <your-rg> \
  --name "LegalVM" \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --tags Owner=<your-name> Dept=IT_Class
```

**Verification:** In the Portal, navigate to **LegalVM → Overview** and confirm the `Owner` and `Dept` tags are visible in the **Tags** section.

---

## Part 3 — The Safety Pin (Resource Locks)

Prevent accidental deletion of your resource group with a lock.

```bash
az lock create \
  --name "ProtectTheLab" \
  --lock-type CanNotDelete \
  --resource-group <your-rg>
```

### Test the lock

1. In the Portal, navigate to your resource group.
2. Click **Delete resource group** and attempt to confirm.

**Expected result:** The delete operation fails because the `ProtectTheLab` lock is active.

> **Deliverable:** Take a screenshot of the Resource Lock settings showing the `ProtectTheLab` lock.

---

## Part 4 — Financial Visibility (Cost Analysis)

Use tags to see who is generating costs.

1. In the Portal, navigate to **Cost Management + Billing → Cost Analysis**.
2. Change the view to **Daily costs** or **Resources**.
3. Click the **Group by** dropdown and select **Tag → Owner**.
4. Observe how the chart splits costs by resource owner.

> **Deliverable:** Take a screenshot of the Cost Analysis dashboard grouped by the `Owner` tag.

---

## Part 5 — Automated Alerts (Budgets and Action Groups)

Set up a tripwire that notifies you if lab spend climbs too high.

1. In **Cost Management**, go to **Budgets → + Add**.
2. Set a monthly budget of **$10.00**.
3. On the **Set alerts** step, add an alert at **50% of budget (Actual)**.
4. Under **Action Group**, click **Create new**:
   - Name: `NotifyInstructor`
   - Notification type: **Email/SMS/Push/Voice**
   - Add your email address as the recipient.
5. Complete the wizard and save.

---

## Part 6 — The "Small Business Migration" Estimate

### Scenario

A local medical clinic in Nova Scotia is moving their on-premises server to Azure. They have a limited budget and need a 12-month cost projection.

### Build the estimate

Open the [Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/) and configure the following, all in **Canada Central**:

| Component | Specification |
|-----------|--------------|
| Windows Server VM | D2s v3 — scheduling software |
| Ubuntu Linux VM | B2s — web server |
| Managed Disks | 500 GB Standard SSD |
| Blob Storage | 1 TB, Cool tier — patient record backups |
| Outbound data transfer | 100 GB/month egress |

Record your initial **Pay-As-You-Go monthly total**.

### The Optimization Pitch

Find two ways to reduce the bill:

1. **The Licensing Lever** — Enable **Azure Hybrid Benefit** for the Windows VM. How much does the monthly total drop?
2. **The Commitment Lever** — Switch the Windows VM pricing model from Pay-As-You-Go to a **1-Year Reserved Instance**. What is the new monthly cost?
3. **Bandwidth question** — The clinic plans to upload 5 TB of data *into* Azure. Why doesn't the inbound transfer cost change the estimate?

> **Deliverable:** Export your final optimized estimate as a PDF (Pricing Calculator → **Export**) and include a 3-sentence Executive Summary answering:
> - What was the total monthly cost for the original Pay-As-You-Go setup?
> - What was the final optimized monthly cost?
> - Which change — Hybrid Benefit or Reserved Instance — provided the biggest single saving?

---

## Lab Deliverables Summary

| # | Deliverable |
|---|-------------|
| 1 | Screenshot — CLI `RequestDisallowedByPolicy` error for `IllegalVM` |
| 2 | Screenshot — Cost Analysis dashboard grouped by `Owner` tag |
| 3 | Screenshot — Resource Lock settings showing `ProtectTheLab` |
| 4 | PDF export of the Pricing Calculator estimate |
| 5 | 3-sentence Executive Summary (see Part 6) |

---

## Cleanup

> Remove the resource lock before deleting resources, or the deletion will fail.

```bash
# Remove the lock first
az lock delete --name "ProtectTheLab" --resource-group <your-rg>

# Then delete the resource group
az group delete --name <your-rg> --yes --no-wait
```

---

## Checkpoint questions

1. What is the difference between a `CanNotDelete` lock and a `ReadOnly` lock?
2. If a developer has the Contributor role but a `CanNotDelete` lock is active, can they delete the resource? Why or why not?
3. Azure Policy assignment can be scoped to a Management Group, Subscription, or Resource Group. What are the tradeoffs of each level for a student pilot?

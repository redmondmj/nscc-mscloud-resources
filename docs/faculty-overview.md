# Faculty Overview — NSCC Visual Studio Enterprise Pilot

A reference for IT faculty planning to use the VS Enterprise pilot subscription in coursework. Covers what is included, what is **not** included, and the practical implications of each.

> **Companion infographic:** `Faculty-Overview.pdf` (one-page summary suitable for printing and posting in faculty offices).

> **Audience:** Technical (IT) faculty who will deploy resources, manage student access, and design lab exercises. Assumes baseline Azure / Microsoft 365 literacy.

---

## What's included

### Infrastructure as a Service (IaaS)

Full IaaS access against the monthly Azure credit. Faculty can deploy any of the following in the sandbox tenant without raising a ticket:

- **Virtual Machines** — Windows Server and Linux distributions. B-series sizes are cost-appropriate for labs; D/E/F series should be deallocated immediately after use.
- **Virtual Networks** — VNets, subnets, NSGs, route tables, peering. VNet creation itself is free; gateways and peering egress are billed.
- **Storage accounts** — Blob, Files (SMB/NFS), Queues, Tables, managed disks. Standard SSD is the cost/performance sweet spot for lab disks.
- **Container hosting** — Azure Container Instances (single-container, per-second billing), AKS (small clusters only — `--node-count 1`).
- **Public IPs, load balancers, DNS** — Standard SKU required (Basic SKU public IPs retired Sept 30, 2025).

### Platform as a Service (PaaS)

Managed runtimes and data services suitable for application coursework:

- **Compute** — App Service (F1/B1 tiers cover most labs), Container Apps, Azure Functions (consumption plan is effectively free at lab scale).
- **Databases** — Azure SQL Database (serverless tier auto-pauses), PostgreSQL Flexible Server (stoppable), Cosmos DB (free tier includes 1000 RU/s + 25 GB per subscription).
- **Messaging & events** — Service Bus, Event Grid, Event Hubs (basic tiers).
- **AI services** — Azure AI Services (Vision, Language, Speech, Document Intelligence, Content Safety), Azure OpenAI, Azure Machine Learning, Azure AI Foundry. Most have an F0 free tier; Azure OpenAI requires an approved application for some models.
- **API Management** — Consumption tier suits demos; higher tiers consume credit quickly.

### SaaS and subscription benefits

These are entitlements that come with the VS Enterprise subscription itself, independent of the Azure credit:

- **Visual Studio 2022 Enterprise IDE** — full version, all workloads.
- **Microsoft 365 E5 Developer Tenant** — Exchange Online, Teams, SharePoint, OneDrive, Intune, Entra ID P2, Power BI Pro, full Office desktop apps. **Capped at 25 user licenses.** Renewable, see "Hard ceilings" below.
- **Microsoft Foundry** — unified model catalog and evaluation portal. Serverless API deployments for many models (pay-per-token, against Azure credit).
- **Microsoft Learn training credit** — confirm current allotment on the benefits page; entitlement has shifted over recent program updates.
- **Windows 10 / 11 Enterprise dev/test keys** — for use on subscriber-owned hardware or non-Azure VMs.
- **Windows Server dev/test keys** — same scope.
- **SQL Server dev/test keys** — Developer Edition is free; the entitlement here covers Enterprise and other paid SKUs in dev/test contexts.
- **GitHub Enterprise** — *verify entitlement.* Since 2023 the standard SKU is "Visual Studio Enterprise with GitHub Enterprise." If NSCC's subscription is the bundled SKU, GitHub Enterprise seats are included; if it's a legacy plain-VS-Enterprise SKU, they are not. Check the benefits page for a GitHub Enterprise tile.

### Licensing model

- **Per-seat, named subscriber.** One subscription = one person. Credentials are not shareable.
- **Educational, development, and test use only.** No production workloads, no commercial use, no real customer or student PII.
- **Program window:** valid through **August 2028**. Renewable within the window.
- **Credit renewal cadence:** each subscriber's Azure credit renews on the anniversary of their activation date, not calendar month-start.

### Self-administration

Faculty operate as full administrators of their sandbox tenant. No central IT ticket is required for routine operations:

- Global Administrator on the sandbox Entra tenant.
- Create, modify, and delete resource groups, IAM assignments, networks, identities.
- Invite guest users (students) and scope their access to specific resource groups.
- Configure budgets, alerts, tags, naming conventions.
- Deploy infrastructure via the included Bicep templates (`scripts/bicep/student-vm/`) and clean up via the PowerShell scripts (`scripts/powershell/`).

This independence is the headline benefit of the pilot architecture (see `docs/tenant-setup-and-iam.md` for how the sandbox tenant was established).

### Region pinning (Canada East)

Pilot guidance fixes all deployments to **Canada East**. This is a real advantage over trial subscriptions:

- Trial subscriptions randomly assign students to regions (Brazil South, Korea Central, etc.), which silently changes which SKUs and services are available and complicates lab instructions.
- Canada East has full service coverage for the workloads in scope and meets Canadian data-residency expectations for educational content.
- Lab materials can assume consistent SKU naming, pricing, and latency.

---

## What's *not* included

### Governance gaps

The sandbox tenant is intentionally outside NSCC's central IT estate. The implications:

- **Not enrolled in NSCC Intune, Defender, DLP, or central log forwarding.** Devices, identities, and data inside the sandbox are invisible to the institutional security team.
- **No federation with NSCC SSO.** Students sign in with sandbox-tenant guest accounts, not their NSCC credentials. There is no SCIM/Just-in-Time provisioning from the institutional directory.
- **No backup or retention beyond what you configure** per resource. There is no estate-wide backup vault or retention policy. If you delete a resource group, it is gone.
- **No audit trail to NSCC IT.** Activity logs live inside the sandbox tenant only. Incident response is the faculty admin's responsibility.
- **No transferred compliance posture.** FOIPOP, PHIA, PCI, or other institutional compliance certifications do not extend to the sandbox. Treat all data inside the tenant as non-sensitive demonstration data.

### Missing licenses

Even with the M365 E5 Dev tenant, the following are **not** included and would need a separate purchase or workaround:

- **Microsoft Defender for Cloud — paid plans.** Defender for Servers, SQL, Containers, Storage, Key Vault, App Service, Databases. Only the free Cloud Security Posture Management (CSPM) tier is available. This is the largest single licensing gap for security coursework.
- **Microsoft Sentinel.** No SIEM/SOAR capability. Cannot be demonstrated end-to-end on this subscription.
- **Microsoft Defender for Endpoint** beyond the 25-seat M365 dev tenant. Cannot be extended to NSCC-managed devices.
- **Microsoft 365 Copilot.** Not included in E5 Dev; separate paid add-on. The most common user-expectation gap currently — students and faculty often assume this is bundled with E5.
- **GitHub Copilot Business / Enterprise.** Likely not in your SKU. Students can self-serve a free seat via the GitHub Student Developer Pack.
- **GitHub Advanced Security.** Secret scanning, code scanning, dependency review at enterprise scope. Relevant for any secure-development course.
- **Microsoft Entra ID Governance.** Entitlement management, access reviews as a product surface, lifecycle workflows. Separate add-on *beyond* the Entra P2 already included with E5. Affects IAM courses going past PIM and Conditional Access.
- **Teams Premium.** Meeting templates, intelligent recap, sensitivity labels for meetings, advanced webinar features. Not part of E5 standard.
- **Microsoft Purview Data Governance (Azure-side).** The M365-side Purview (sensitivity labels, DLP, basic eDiscovery) *is* included within the sandbox and supports concept demonstrations. The Azure-side Purview Data Map / Data Catalog is a separate paid Azure resource — technically deployable against the credit, but the minimum capacity unit consumes most of the monthly budget even idle. Premium tiers of the unified Purview Data Governance suite are not included.
- **Azure ExpressRoute, dedicated hosts, reserved instances, savings plans.** Reserved-capacity discounts cannot be applied effectively against the monthly credit.
- **Most paid Marketplace offerings.** Third-party software billed through Marketplace is generally excluded from credit coverage; check each offering's terms.
- **Azure DevOps beyond the per-subscriber basic plan.** Larger team plans, hosted parallel jobs at scale, Test Plans add-on — all separate.
- **Power Platform premium connectors and Dataverse capacity.** Standard connectors work; premium (SQL, custom HTTP) require per-user/per-app premium licenses. Dataverse capacity inside the sandbox is the E5-default allocation.

### Paid services that exist but consume credit quickly

Distinct from "missing licenses." These services *are* available, but their pricing model is incompatible with the monthly credit ceiling at any realistic scale. Use them only for short demos, not as standing infrastructure:

- **Azure Firewall** — ~CA$1.40/hour base, plus data processing. Running a single firewall for a week consumes a large fraction of the monthly credit.
- **Azure Bastion** — ~CA$0.19/hour per host. Acceptable for an evening lab; expensive if left running.
- **Azure DDoS Protection Standard** — ~CA$4,000/month. Effectively unusable on the pilot budget.
- **Azure Front Door Premium / WAF Premium** — hourly base plus per-rule charges.
- **DNS Private Resolver, Private Endpoints** — small per-hour charges plus egress; add up across multiple student deployments.
- **Cosmos DB provisioned throughput at scale, Azure SQL Hyperscale, dedicated Cosmos clusters.**

### Hard ceilings

- **~CA$200/month Azure credit per subscriber.** Hard cap. Spend above the credit charges the payment method on file unless a budget action stops resources (see `docs/tenant-setup-and-iam.md` — note that budget alerts warn but do not stop resources).
- **25-user cap on the M365 E5 Dev tenant.** Larger cohorts require either multiple sandbox tenants or selective use of the M365 surface.
- **M365 Dev tenant auto-renews *with activity*, not unconditionally.** Sign-ins, mailbox use, Teams messages, and admin actions all count. A dormant tenant — typical between semesters or after a single-term course ends — is at risk of deactivation roughly between days 90 and 120 of inactivity. Schedule periodic touchpoints if the tenant is not in continuous use.
- **No production traffic, no real student PII, no business-critical data.** This is a terms-of-service constraint, not a technical one.

### Administrative burden

A point that does not appear elsewhere but matters for course planning:

Faculty using the pilot are simultaneously the **tenant administrator**, **billing watcher**, **IAM operator**, **incident responder**, and **cleanup enforcer**. There is no central handoff path inside NSCC IT for issues that arise inside the sandbox. Account for this time in course design — the cleanup discipline in particular has to be both taught to students *and* enforced through the cleanup scripts at the end of each lab session.

---

## Practical guidance

A short list of patterns that have worked in the pilot so far:

1. **Use Canada East for everything.** It removes a class of "it doesn't work for me" student tickets.
2. **Scope student access to a single Resource Group**, never at subscription level. See the IAM section of `docs/tenant-setup-and-iam.md`.
3. **Set a budget alert** at 50% and 90% of monthly credit on the student RG, with email to your NSCC address. Alerts are informational only — combine with the cleanup script.
4. **Delete the Resource Group** at the end of each session — not just "stop" individual resources. Container Instances and idle Public IPs accrue charges silently.
5. **Use the included Bicep template** (`scripts/bicep/student-vm/`) for VM labs. The SSH-key path matches the Lab 01 instructions; the password path is for Windows VMs only.
6. **Tag everything** with `student-id` and `created-date`. The cleanup PowerShell script (`Remove-StaleResources.ps1`) relies on these tags to find stale RGs.
7. **Keep the M365 sandbox tenant active** with periodic admin logins or scripted activity, particularly across semester breaks.

---

## References

- `docs/getting-started.md` — student / first-time activation.
- `docs/tenant-setup-and-iam.md` — how the sandbox tenant was established and how student access is scoped.
- `docs/resources/` — per-service overview docs (compute, storage, networking, databases, AI/ML).
- `labs/lab-01-vm-deployment/` — first lab, deploys a Linux VM via SSH.
- `scripts/bicep/student-vm/` — IaC template paired with Lab 01.
- `scripts/powershell/` — resource group creation and stale-resource cleanup.
- [my.visualstudio.com/benefits](https://my.visualstudio.com/benefits) — authoritative source for current entitlement list. Always check here before assuming a benefit is present.

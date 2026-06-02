# M365 E5 Developer Sandbox — Service Entitlements

The NSCC sandbox tenant is licensed under **Microsoft 365 E5 Developer (without Windows and Audio Conferencing)**. The table below organizes all included services by category so you can quickly find what's available when designing or taking a lab.

> **Retired / Do Not Use** entries are listed for completeness but should not be used in new lab work — Microsoft has deprecated them and they may be removed from the tenant at any time.

---

## Identity and Access Management

| Service | Notes |
|---------|-------|
| Microsoft Entra ID P1 | Conditional Access, group-based licensing, self-service password reset |
| Microsoft Entra ID P2 | Adds Privileged Identity Management (PIM), Identity Protection, access reviews |
| Microsoft Azure Multi-Factor Authentication | Per-user and Conditional Access-driven MFA |
| Azure Rights Management | Encryption and policy-based protection for documents and email |
| Azure Information Protection Premium P1 | Sensitivity labels, classification, AIP scanner |
| Azure Information Protection Premium P2 | Adds automatic classification and Bring Your Own Key (BYOK) |

---

## Security

| Service | Notes |
|---------|-------|
| Microsoft 365 Defender | Unified XDR portal (`security.microsoft.com`) covering identity, endpoint, email, and cloud apps |
| Microsoft Defender for Office 365 (Plan 1) | Safe Links, Safe Attachments, anti-phishing for Exchange and Teams |
| Microsoft Defender for Office 365 (Plan 2) | Adds Attack Simulator, Threat Trackers, automated investigation |
| Microsoft Defender for Cloud Apps | CASB — shadow IT discovery, session controls, cloud app governance |
| Microsoft Defender for Identity | Detects lateral movement and identity-based attacks using AD signals |
| Office 365 Cloud App Security | Subset of Defender for Cloud Apps scoped to O365 workloads |
| Defender Platform for Office 365 | Underlying platform services for O365 Defender features |

---

## Compliance, Governance, and eDiscovery

| Service | Notes |
|---------|-------|
| Microsoft Purview (portal) | Unified compliance portal — covers most services below |
| Purview Discovery | Content discovery across M365 for eDiscovery and compliance |
| Microsoft 365 Advanced Auditing | Extended audit log retention (up to 1 year), mailbox audit events |
| Microsoft 365 Audit Platform | Underlying audit infrastructure |
| Office 365 Advanced eDiscovery | Legal hold, custodian management, review sets |
| Microsoft Information Governance | Retention policies and labels, records management baseline |
| Microsoft Records Management | Disposition reviews, file plan, regulatory records |
| Data Classification in Microsoft 365 | Trainable classifiers, sensitive info types, content explorer |
| Information Protection for Office 365 — Standard | Core sensitivity labels and manual classification |
| Information Protection for Office 365 — Premium | Automatic labelling, exact data match, document fingerprinting |
| Information Protection and Governance Analytics — Premium | Analytics dashboard across labelling and classification activity |
| Microsoft Insider Risk Management | Detects risky user behaviour (data leaks, policy violations) |
| Microsoft Insider Risk Management — Exchange | Exchange signal source for Insider Risk |
| Microsoft Communications DLP | DLP policies for Teams chat and channel messages |
| Microsoft 365 Communication Compliance | Policy-based review of communications for regulatory compliance |
| Microsoft Customer Key | Bring Your Own Key encryption for Exchange, SharePoint, Teams |
| Customer Lockbox | Requires explicit approval before Microsoft support engineers access tenant data |
| Customer Lockbox (A) | Same capability, alternate licence unit |
| Office 365 Privileged Access Management | Just-in-time approval for privileged Exchange tasks |
| Graph Connectors Search with Index | Index external content into Microsoft Search via Graph connectors |
| Microsoft ML-Based Classification | Machine learning classifiers for sensitive content |
| ~~Retired — Microsoft Data Investigations~~ | *(Retired — do not use)* |
| ~~RETIRED — Microsoft Communications Compliance~~ | *(Retired — superseded by M365 Communication Compliance above)* |

---

## Productivity and Collaboration

| Service | Notes |
|---------|-------|
| The latest desktop version of Office | Word, Excel, PowerPoint, Outlook, etc. — installable via M365 Apps |
| Office for the Web | Browser-based Office apps (no installation required) |
| Exchange Online (Plan 2) | Full hosted email — 100 GB mailbox, in-place archive, journaling |
| SharePoint (Plan 2) | Full SharePoint Online including site collections, hub sites, syntex |
| Microsoft Teams | Chat, meetings, channels, apps |
| Microsoft Planner | Kanban-style task boards integrated with Teams and M365 Groups |
| Microsoft Forms (Plan E5) | Surveys and quizzes with response analytics |
| Microsoft Bookings | Appointment scheduling tied to staff calendars |
| Microsoft Loop | Collaborative components and pages across M365 apps |
| Microsoft Stream for Office 365 E5 | Video upload, sharing, and transcription |
| To-Do (Plan 3) | Personal task management with Outlook integration |
| Whiteboard (Plan 3) | Collaborative infinite canvas for Teams meetings |
| Sway | Lightweight web-based presentations and reports |
| Yammer Enterprise | Enterprise social network (now Microsoft Viva Engage) |
| Power Apps for Office 365 (Plan 3) | Low-code app building with M365 data sources |
| Power Automate for Office 365 | Workflow automation connecting M365 services |
| Power Virtual Agents for Office 365 | Low-code chatbot builder (now Microsoft Copilot Studio) |
| Power BI Pro | Self-service BI, dashboards, and sharing |
| Microsoft Clipchamp | In-browser video editor |
| Microsoft 365 Phone System | Cloud PBX — enables Teams calling with a calling plan |
| Skype for Business Online (Plan 2) | *(Legacy — use Teams for new deployments)* |
| ~~Microsoft StaffHub~~ | *(Retired — replaced by Shifts in Teams)* |
| Common Data Service | Dataverse storage for Power Platform apps |
| Common Data Service for Teams | Dataverse for Teams — low-code data storage in Teams |
| Project for Office (Plan E5) | Project-management features in M365 apps (not full Project Online) |

---

## Analytics, Learning, and Wellbeing

| Service | Notes |
|---------|-------|
| Microsoft MyAnalytics (Full) | Personal productivity insights — meeting time, focus time, email habits |
| Insights by MyAnalytics Backend | Backend data service for MyAnalytics/Viva Insights |
| Viva Learning Seeded | Learning content aggregation in Teams |
| People Skills — Foundation | AI-driven skills mapping in Viva (preview/limited availability) |
| Microsoft Excel Advanced Analytics | Statistical analysis and advanced data modelling in Excel |
| Microsoft eCDN | Enterprise content delivery network for large-scale video streaming |
| Nucleus | Internal Microsoft service for M365 analytics infrastructure |
| ~~DO NOT USE — Microsoft MyAnalytics (Full)~~ | *(Duplicate/deprecated licence unit — use the non-flagged entry above)* |
| ~~RETIRED — Places Core~~ | *(Retired)* |
| ~~RETIRED — Commercial data protection for Microsoft Copilot~~ | *(Retired)* |

---

## Immersive and Emerging Experiences

| Service | Notes |
|---------|-------|
| Microsoft 365 Lighthouse (Plan 1) | Multi-tenant management portal for managed service providers |
| Immersive spaces for Teams | 3D meeting environments in Teams (via Mesh) |
| Avatars for Teams | Customizable animated avatars for Teams meetings |
| Avatars for Teams (additional) | Additional avatar content pack |

---

## Quick reference — services most relevant to NETW3500 labs

| Lab | Primary services used |
|-----|-----------------------|
| Lab 01 — VM Deployment | *(Azure, not M365)* |
| Lab 05 — Governance and Cost | *(Azure, not M365)* |
| Lab 06 — M365 Administration | Entra ID P2, Exchange Online, Defender for Office 365, SharePoint, Teams |
| Lab 07 — Intune | Microsoft Intune Plan 1, Entra ID P1/P2, Microsoft 365 Defender |

For Azure service coverage see [docs/resources/](resources/).

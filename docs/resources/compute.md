# Compute

Azure compute services let you run applications and workloads without managing physical hardware.

---

## Virtual Machines

Azure VMs give you full control over the OS and runtime environment.

**Common use cases:** running Windows Server for lab exercises, Linux development environments, legacy app testing.

**Cost tip:** Use the **B-series burstable** VM sizes (e.g., `Standard_B2s`) for development — they are significantly cheaper than general-purpose D-series for intermittent workloads. Always **stop (deallocate)** VMs when not in use; a stopped-but-not-deallocated VM still incurs compute charges.

Quickstart: [Create a Windows VM](https://learn.microsoft.com/azure/virtual-machines/windows/quick-create-portal) | [Create a Linux VM](https://learn.microsoft.com/azure/virtual-machines/linux/quick-create-portal)

---

## Azure App Service

A fully managed platform for hosting web apps, REST APIs, and mobile backends.

**Common use cases:** deploying ASP.NET, Node.js, or Python web applications for coursework or demos.

**Cost tip:** The **Free (F1)** and **Basic (B1)** tiers are sufficient for most student projects and consume minimal credits.

Quickstart: [Deploy an ASP.NET app](https://learn.microsoft.com/azure/app-service/quickstart-dotnetcore)

---

## Azure Container Apps

Run containerized applications without managing Kubernetes clusters.

**Common use cases:** microservices demos, containerized capstone projects, API backends.

Quickstart: [Deploy your first container app](https://learn.microsoft.com/azure/container-apps/get-started)

---

## Azure Kubernetes Service (AKS)

Managed Kubernetes for container orchestration at scale.

**Note:** AKS clusters can consume credits quickly. Use the `--node-count 1` flag and stop the cluster when not in use.

Quickstart: [AKS quickstart](https://learn.microsoft.com/azure/aks/learn/quick-kubernetes-deploy-portal)

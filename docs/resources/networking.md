# Networking

Core Azure networking services for connecting and securing your resources.

---

## Virtual Networks (VNet)

A VNet is the foundational private network for your Azure resources. All VMs and most services can be placed inside a VNet to control traffic flow.

**Key concepts:**
- **Subnets** — subdivide a VNet into segments (e.g., `web-subnet`, `db-subnet`).
- **Network Security Groups (NSGs)** — stateful firewall rules applied to a subnet or NIC.
- **VNet Peering** — connect two VNets so resources can communicate privately.

Quickstart: [Create a virtual network](https://learn.microsoft.com/azure/virtual-network/quick-create-portal)

---

## Public IP Addresses and DNS

- Public IPs are required for resources that need to be reachable from the internet (e.g., a web server VM).
- **Basic** SKU public IPs are free at low usage; **Standard** SKU IPs incur a small hourly charge.
- Azure provides a free DNS label (`<name>.<region>.cloudapp.azure.com`) for public IPs — useful for demos without a custom domain.

---

## Azure Load Balancer

Distributes inbound traffic across multiple VMs or instances.

- **Basic** tier: free, limited features, suitable for single-region lab use.
- **Standard** tier: charged per hour, required for availability zones and more advanced scenarios.

---

## Cost tips

- Delete Public IP addresses when they are no longer attached to a resource — they still incur a small charge when idle (Standard SKU).
- VNet creation itself is free; costs arise from gateways, peering egress, and public IPs.

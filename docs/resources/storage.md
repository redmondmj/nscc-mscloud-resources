# Storage

Azure offers several storage options depending on the type of data you need to store.

---

## Azure Blob Storage

Object storage for unstructured data: images, videos, backups, log files, and static website assets.

**Access tiers:**
- **Hot** — frequently accessed data (higher storage cost, lower access cost)
- **Cool** — infrequently accessed data (lower storage cost, higher access cost)
- **Archive** — long-term backup (lowest cost, high retrieval latency)

For student projects, the **Hot** tier is appropriate in almost all cases.

Quickstart: [Upload and download blobs](https://learn.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-portal)

---

## Azure Files

Fully managed file shares accessible over SMB or NFS — useful for shared lab storage or mounting a drive in a VM.

Quickstart: [Create an Azure file share](https://learn.microsoft.com/azure/storage/files/storage-how-to-use-files-portal)

---

## Managed Disks

Block storage attached to Azure VMs. Managed automatically by Azure — no need to worry about storage accounts for OS/data disks.

**Disk types (cost order, lowest to highest):** Standard HDD → Standard SSD → Premium SSD → Ultra Disk.

For lab VMs, **Standard SSD** is a good balance of performance and cost.

---

## Storage cost tips

- Delete storage accounts and disks associated with deleted VMs — they continue to incur charges.
- Use [Azure Storage Explorer](https://azure.microsoft.com/products/storage/storage-explorer) to browse and manage storage resources from your desktop.
- Set a lifecycle management policy on Blob Storage containers to auto-delete data older than 30 days.

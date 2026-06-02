# Bicep Templates

Infrastructure-as-Code templates for common NSCC lab scenarios.

## Prerequisites

```bash
# Install Bicep (requires Azure CLI)
az bicep install
az bicep version
```

## Templates

| Template | Description |
|----------|-------------|
| [student-vm/main.bicep](student-vm/main.bicep) | Single Windows or Linux VM for student labs |

## Deploying a template

```bash
az deployment group create \
  --resource-group rg-<your-id>-<project> \
  --template-file student-vm/main.bicep \
  --parameters student-vm/main.bicepparam
```

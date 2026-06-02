# Databases

Azure managed database services handle provisioning, patching, backups, and high availability so you can focus on schema and queries rather than infrastructure.

---

## Azure SQL Database

A fully managed relational database based on the latest stable SQL Server engine.

**Common use cases:** relational data modelling exercises, web app backends, demonstrating T-SQL and stored procedures.

**Cost tip:** Use the **Serverless** compute tier (General Purpose, serverless) — it auto-pauses after a configurable idle period and you are only billed for vCore-seconds actually used. For short student labs this is dramatically cheaper than a provisioned instance. Set **auto-pause delay** to 1 hour. The **5 DTU Basic tier** (~CA$6/month) is also a low-cost option for persistent small databases.

Quickstart: [Create an Azure SQL Database](https://learn.microsoft.com/azure/azure-sql/database/single-database-create-quickstart)

---

## Azure Database for PostgreSQL — Flexible Server

A fully managed PostgreSQL service with fine-grained control over configuration and maintenance windows.

**Common use cases:** open-source database coursework, Django/Flask backends, demonstrating JSONB, PostGIS, or pgvector.

**Cost tip:** Use the **Burstable B1ms** compute tier for development workloads. Enable **Stop** (not delete) on the server between lab sessions — a stopped Flexible Server does not incur compute charges (storage is still billed). A B1ms server stopped half the time costs roughly CA$5–8/month.

> **Note:** PostgreSQL Flexible Server is a separate resource from Azure SQL Database. The two share billing but are different services with different connection strings and drivers.

Quickstart: [Create a PostgreSQL Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/quickstart-create-server-portal)

---

## Azure Cosmos DB

A globally distributed, multi-model NoSQL database supporting document, key-value, graph, and column-family APIs.

**Common use cases:** NoSQL data modelling, demonstrating eventual consistency models, building document-oriented APIs with the SQL (Core) API or MongoDB-compatible API.

**Cost tip:** Cosmos DB has a **free tier** that includes 1000 RU/s of provisioned throughput and 25 GB of storage at no charge — one free tier account is available per Azure subscription. For pilot labs this is usually sufficient. If you provision beyond the free tier, **serverless** mode (pay-per-request) is cheaper than provisioned throughput for low-traffic student workloads.

> The free tier is applied at the account level, not per database. Create one shared Cosmos DB account with multiple databases rather than one account per student.

Quickstart: [Create a Cosmos DB account (SQL API)](https://learn.microsoft.com/azure/cosmos-db/nosql/quickstart-portal)

---

## Azure SQL Managed Instance

A fully managed SQL Server instance with near-100% SQL Server compatibility, including SQL Agent, CLR, and linked servers.

**Note:** Managed Instance is significantly more expensive than Azure SQL Database and is **not recommended** for student pilot use under the VS Enterprise credit limit. It is included here for reference if demonstrating enterprise migration scenarios with an instructor-managed instance.

Quickstart: [Create a SQL Managed Instance](https://learn.microsoft.com/azure/azure-sql/managed-instance/instance-create-quickstart)

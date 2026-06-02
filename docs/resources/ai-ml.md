# AI and Machine Learning

Azure provides a range of managed AI services — from pre-built models you call via API to full machine learning platforms for training custom models. Most are usable with minimal infrastructure setup, making them well-suited for coursework.

---

## Azure AI Services

A collection of pre-built AI models exposed as REST APIs, covering vision, language, speech, and decision tasks. No ML expertise required — you send data and get predictions back.

**Included APIs (selected):**

| API | What it does |
|-----|-------------|
| Computer Vision / Image Analysis | Object detection, OCR, image captioning |
| Azure AI Language | Sentiment analysis, named entity recognition, summarization, translation |
| Azure AI Speech | Speech-to-text, text-to-speech, speaker recognition |
| Azure AI Document Intelligence | Extract structured data from forms, invoices, receipts |
| Azure AI Content Safety | Detect harmful or inappropriate content |

**Common use cases:** demonstrating AI API integration in any language, building simple AI-powered apps, introductory ML courses that don't require model training.

**Cost tip:** Each API has a **Free (F0)** tier with a monthly transaction allowance (e.g., 5,000 calls/month for Language, 5 hours/month for Speech). For most lab exercises the free tier is sufficient and does not consume Azure credits. Upgrade to S0 (paid) only if free tier limits are hit.

Quickstart: [Create an Azure AI Services resource](https://learn.microsoft.com/azure/ai-services/multi-service-resource)

---

## Azure OpenAI Service

Provides access to OpenAI's GPT, DALL·E, Whisper, and embedding models through a managed Azure endpoint, with enterprise data privacy controls.

**Common use cases:** prompt engineering exercises, building retrieval-augmented generation (RAG) demos, AI application development coursework.

**Access note:** Azure OpenAI requires an **approved application** separate from simply having an Azure subscription. If you have not already been approved, apply at [aka.ms/oai/access](https://aka.ms/oai/access). Approval typically takes 1–3 business days for educational accounts.

**Cost tip:** Token costs vary by model. GPT-4o mini is significantly cheaper per token than GPT-4o for exercises where response quality is secondary. Set a **low max-tokens** limit in student code to prevent runaway costs. Monitor usage under **Azure OpenAI Studio → Quotas**.

Quickstart: [Get started with Azure OpenAI](https://learn.microsoft.com/azure/ai-services/openai/quickstart)

---

## Azure Machine Learning

A managed platform for the full ML lifecycle: data preparation, experiment tracking, model training, deployment, and monitoring.

**Components:**
- **Notebooks** — Jupyter notebooks running on managed compute
- **Automated ML (AutoML)** — trains and evaluates multiple models automatically
- **Designer** — drag-and-drop pipeline builder
- **Managed endpoints** — deploy models as REST APIs
- **Prompt flow** — build and evaluate LLM-based workflows

**Common use cases:** supervised/unsupervised ML coursework, MLOps demonstrations, capstone data science projects.

**Cost tip:** The Azure ML workspace itself is free — you pay only for the compute you use. Use **serverless compute** for notebook experiments (billed per job, no idle charges). Shut down **compute instances** (dedicated VMs) when not running a job — they accrue charges while idle just like regular VMs. For light exercises, the **CPU-based Standard_DS3_v2** is sufficient and much cheaper than GPU instances.

> GPU compute instances (NC-series) can exhaust a monthly credit in hours if left running. Always confirm with students that GPU instances must be stopped immediately after use.

Quickstart: [Create an Azure ML workspace](https://learn.microsoft.com/azure/machine-learning/quickstart-create-resources)

---

## Azure AI Foundry

A unified portal for discovering, deploying, and evaluating AI models — including models from the Azure AI catalog (open-source models like Llama, Mistral, Phi) alongside Azure OpenAI models.

**Common use cases:** comparing model capabilities, deploying open-source LLMs without managing infrastructure, prompt evaluation workflows.

**Cost tip:** Serverless API deployments (pay-per-token) are available for many catalog models and require no dedicated compute. This is the lowest-cost starting point. Managed compute deployments spin up dedicated VMs and accrue charges regardless of usage.

Quickstart: [Get started with Azure AI Foundry](https://learn.microsoft.com/azure/ai-studio/what-is-ai-studio)

# Contributing

Contributions from NSCC staff and students are welcome! This document explains how to submit new content or fix existing material.

---

## What we're looking for

- Bug fixes or corrections in existing docs
- New resource overview docs (e.g., databases, AI services)
- New lab exercises
- New or improved PowerShell scripts and Bicep templates

---

## Getting started

1. Fork the repository on GitHub.
2. Clone your fork:
   ```bash
   git clone https://github.com/<your-username>/nscc-mscloud-resources.git
   cd nscc-mscloud-resources
   ```
3. Create a feature branch:
   ```bash
   git checkout -b add-lab-02-app-service
   ```

---

## Guidelines

### Docs

- Write in clear, plain English. Assume the reader is a first-year student with no prior Azure experience.
- Use the existing doc structure as a template.
- Include cost tips where relevant.
- Link to official Microsoft Learn documentation rather than third-party sources.

### Labs

- Place each lab in `labs/lab-NN-<short-name>/README.md`.
- Include: objectives, prerequisites, step-by-step instructions, a clean-up section, and at least two checkpoint questions.
- Test the lab end-to-end before submitting.

### Scripts and templates

- Include a comment block at the top of every script (`.SYNOPSIS`, `.DESCRIPTION`, `.EXAMPLE` for PowerShell; inline comments for Bicep).
- Never commit secrets, passwords, or `.pem` files. See `.gitignore`.
- Prefer parameterized scripts over hardcoded values.

---

## Submitting a pull request

1. Push your branch: `git push origin add-lab-02-app-service`
2. Open a pull request against `main`.
3. Fill in the PR description with: what changed, why, and how you tested it.
4. A maintainer will review and merge.

---

## Questions?

Open a GitHub Issue or contact the NSCC IT team.

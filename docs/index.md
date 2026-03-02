# 🚀 Terraform Vault Module Documentation

Welcome to the comprehensive documentation for the **Terraform Vault Module**. This module is designed to help you quickly, securely, and consistently deploy [HashiCorp Vault](https://www.vaultproject.io/) infrastructure using Infrastructure as Code (IaC) best practices.

## 📖 What's inside

This `docs/` directory is structured to guide you through different operational domains of Vault. Whether you are setting up authentication for machines, managing PKI infrastructure, or enabling Enterprise features, you will find a dedicated guide here.

### 📚 Available Guides

1. **[Authentication Methods (`auth_methods.md`)](./guides/auth_methods.md)**
   - Human Authentication (Userpass, OIDC/JWT)
   - Machine-to-Machine Authentication (AppRole, Kubernetes)
   - Cloud IAM Integration (AWS, Azure, GCP)

2. **[Secrets Engines (`secrets_engines.md`)](./guides/secrets_engines.md)**
   - Key/Value (KV-V1 and KV-V2)
   - Encryption as a Service (Transit)
   - Public Key Infrastructure / Certificates (PKI)

3. **[Identity Governance (`identity_management.md`)](./guides/identity_management.md)**
   - Vault Entities & Aliases
   - Identity Groups and Nested Groups
   - Policy mapping and inheritance

4. **[Advanced & Enterprise Features (`enterprise_features.md`)](./guides/enterprise_features.md)**
   - Logical Multi-tenancy (Namespaces)
   - Secrets Synchronization (AWS SM, Azure KV, GitHub, Vercel, GCP)
   - Managed Keys (External KMS integration)
   - Raft Storage Autopilot

## 🚀 Getting Started

To see a complete, fully-featured deployment of all these capabilities, refer to the **[`examples/complete`](../examples/complete)** directory.

The complete example has been modularized into easy-to-read files:

- `auth.tf`: Showcases all supported Auth Methods.
- `secrets.tf`: Demonstrates KV, Transit, and PKI engines.
- `identity.tf`: Examples of Entities and Groups.
- `enterprise.tf`: Enterprise-only features like sync and namespaces.
- `main.tf`: Core configurations, auditing, and generic endpoints.

---

_This documentation is continually updated alongside module releases to guarantee 100% parity with the official HashiCorp Vault Provider._

# 🌆️ Adventure 02: Building CloudHaven

Welcome to the second adventure in the **Open Ecosystem Challenge** series!  
Your mission: modernize CloudHaven's infrastructure from manual provisioning to a self-service platform.  
This is a hands-on journey through **OpenTofu**, **Crossplane**, and **Platform Engineering**.

The entire **infrastructure is pre-provisioned in your Codespace** — OpenTofu, a Kubernetes cluster, Crossplane, and mock
cloud services are ready to go.  
**You don't need to set up anything locally. Just focus on solving the problem.**

## 🏗️ The Backstory

Welcome to CloudHaven, a bustling digital metropolis where every district depends on essential services to thrive.
You've just joined the Infrastructure Guild, a team of platform engineers responsible for providing the tools and
services that keep the city running.

CloudHaven is expanding rapidly. The Merchant's Quarter needs storage vaults for their goods and ledgers for tracking
inventory. The Scholar's District requires secure archives for ancient texts. The Artisan's Quarter demands workshops
with specialized tools. Each district has unique needs, but they all depend on the Guild to provide reliable, scalable
infrastructure services.

The Guild used to provision everything manually through cloud consoles — a process that was slow, error-prone, and
impossible to track. Recently, they've started adopting Infrastructure as Code, but the transition is incomplete.

The Guild Master has assigned you to complete the modernization journey: from basic service provisioning with OpenTofu,
through automated service management with Crossplane, to building a self-service platform where districts can request
what they need without waiting for the Guild.

**Your mission: Build the services and tools that will support CloudHaven's future growth.**

## 🎮 Choose Your Level

Each level is a standalone challenge with its own Codespace that builds on the story while being technically
independent — pick your level and start wherever you feel comfortable!

> 💡 Not sure which level to choose? [Learn more about levels](/#how-it-works)

### 🟢 Beginner: The Foundation Stones

**Status:** ✅ Available  
**Topics:** OpenTofu, Remote State, Resource Dependencies

The Guild's first district, Merchant's Quarter, needs essential services: a storage vault for merchant goods and a
ledger system for tracking inventory. A previous engineer started provisioning these services using OpenTofu but never
finished the setup. The state is stored locally, making collaboration impossible, and some services are only
half-configured.

Your mission: Complete the OpenTofu configuration and establish proper state management.

[**Start the Beginner Challenge**](./beginner.md){ .md-button .md-button--primary }

### 🟡 Intermediate: The Living Infrastructure

**Status:** 🚧 Coming on January 19, 2026  
**Topics:** Crossplane, Managed Resources, Dependencies, Drift Detection

The Merchant's Quarter infrastructure is now running, but the Guild Master isn't happy. Every change still requires
someone to run `tofu apply` manually. There's no proper audit trail, and the infrastructure drifts when people make
manual changes outside of code.

The Guild has decided to adopt Crossplane, a Kubernetes-native tool that manages infrastructure declaratively with
built-in drift detection and automatic reconciliation. They want to migrate the Merchant's Quarter services — including
the storage vault and the ledger database — to Crossplane, and model the dependencies between them.

Your mission: Migrate from imperative OpenTofu to declarative Crossplane, model the bucket–database relationship, and
leverage Kubernetes-native reconciliation to keep infrastructure in the desired state.

### 🔴 Expert: The Self-Service Citadel

**Status:** 🚧 Coming on January 26, 2026  
**Topics:** Policies & Governance, Crossplane, Policy-as-Code with Kyverno

Word of your automated infrastructure success has spread throughout CloudHaven. Now, every district wants their own
services, and requests are pouring in. The Guild Council is getting worried: some vaults are being created in expensive
regions, some databases lack encryption, and a few requests ignore naming and labeling conventions.

The Council decrees that no new infrastructure may be created without proper guardrails. Crossplane is already managing
the infrastructure, and a GitOps engine like Argo CD may be syncing manifests from Git, but the policy engine is
incomplete and not enforcing the Guild’s rules.

Your mission: Implement and fix policies that govern how infrastructure is created — ensuring only compliant
Crossplane-managed resources are admitted, while valid configurations continue to work as expected.

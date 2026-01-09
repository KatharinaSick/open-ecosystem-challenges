# 🟢 Beginner: The Foundation Stones

The Merchant's Quarter needs essential services, but the previous engineer left the OpenTofu configuration incomplete.
Your mission: Complete the setup and establish proper infrastructure management.

## ⏰ Deadline

Wednesday, 10 December 2025 at 09:00 CET
> ℹ️ You can still complete the challenge after this date, but points will only be awarded for submissions before the
> deadline.

## 💬 Join the discussion

Share your solutions and questions in
the [challenge thread](TODO)
in the Open Ecosystem Community.

## 🎯 Objective

By the end of this level, you should:

- Successfully run `tofu init`, `tofu plan`, and `tofu apply`
- Provision **storage vaults** (buckets) and **ledger databases** for the Merchant's Quarter districts
- Configure a **remote state backend** to enable team collaboration
- Understand how **`for_each`** loops work to provision multiple resources
- Use the **`enabled`** meta-argument to conditionally create resources
- View infrastructure details through **outputs**

## 🧠 What You'll Learn

- OpenTofu/Terraform basics (init, plan, apply workflow)
- Remote state backends for team collaboration
- Resource loops with `for_each`
- The new `enabled` meta-argument (OpenTofu 1.11+)
- Outputs for sharing resource information

## 🧰 Toolbox

Your Codespace comes pre-configured with the following tools to help you solve the challenge:

- [`tofu`](https://opentofu.org/): The OpenTofu CLI for infrastructure provisioning
- A **mock GCP API** running locally to simulate cloud resources without real cloud costs

## ✅ How to Play

### 1. Fork the Repository

- Click the "Fork" button in the top-right corner of the GitHub repo or
  use [this link](https://github.com/dynatrace-oss/open-ecosystem-challenges/fork).

### 2. Start a Codespace

- From your fork, click the green **Code** button → **Codespaces hamburger menu** → **New with options**.
  ![Create a new Codespace](./images/new-codespace.png)
- Select the **Adventure 02 | 🟢 Beginner (The Foundation Stones)** configuration.
  ![Codespace options](./images/codespace-options.png)

> ⚠️ **Important:** The challenge will not work if you choose another configuration (or the default).

### 3. Wait for Environment to Initialize

- Your Codespace will automatically set up OpenTofu and start the mock GCP API. This usually takes around 2 minutes.

> 💡 **Tip:** To check the progress press `Cmd + Shift + P` (or `Ctrl + Shift + P` on Windows/Linux) and search for
`View Creation Log` (available after a few moments once the Codespace has initialized).

### 4. Navigate to the Infrastructure Directory

```bash
cd adventures/02-building-cloudhaven/beginner/infra
```

### 5. Explore and Complete the Configuration

- Review the existing OpenTofu files:
  - `main.tf` - Provider and backend configuration
  - `variables.tf` - District definitions
  - `merchants.tf` - Resource definitions for vaults and ledgers
  - `outputs.tf` - Infrastructure outputs
- Run the OpenTofu workflow:
  ```bash
  tofu init
  tofu plan
  tofu apply
  ```

### 6. Verify Your Solution

Run the smoke test to validate your solution:

```bash
./smoke-test.sh
```

## 📚 Resources

- [OpenTofu Documentation](https://opentofu.org/docs/)
- [OpenTofu `enabled` meta-argument](https://opentofu.org/docs/v1.11/language/meta-arguments/enabled/)
- [OpenTofu `for_each` meta-argument](https://opentofu.org/docs/language/meta-arguments/for_each/)
- [OpenTofu Backends](https://opentofu.org/docs/language/settings/backends/configuration/)
- [Google Cloud Storage Bucket Resource](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)
- [Google Cloud SQL Instance Resource](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance)

# Level 1: The Echo Distortion

The Echo Server is misbehaving. Both environments seem to be down, and messages are silent. Your mission: investigate
the ArgoCD configuration and restore proper multi-environment delivery.

## 🎯 Objective

By the end of this level, you should:

- See **two distinct Applications** in the Argo CD dashboard (one per environment)
- Ensure each Application deploys to its **own isolated namespace**
- **Make the system resilient** so changes from outside Git cannot break it
- Confirm that **updates flow automatically** without leaving stale resources behind

## 🧠 What You’ll Learn

- How Argo CD ApplicationSets work
- How to reason about templating and sync policies
- How drift detection and self-healing operate in GitOps workflows

## ✅ How to Play

1. **Fork the Repository**  
   Click the “Fork” button in the top-right corner of the GitHub repo.
2. **Start a Codespace**  
   From your fork, click the green “Code” button → “Codespaces” → “Create codespace on main”.
3. **Wait for Infrastructure to Deploy**  
   The pre-provisioned Kubernetes cluster, Argo CD, and sample app will be set up automatically.
4. **Check Deployment Logs**  
   In VS Code (inside Codespaces), press `Cmd + Shift + P` (or `Ctrl + Shift + P` on Windows/Linux) and run:
   `View Creation Log`
5. **Investigate the Argo CD Dashboard**  
   Use the provided link to open the dashboard. Explore the ApplicationSet and its behavior.
6. **Fix the Configuration**  
   Identify and resolve the issues preventing proper multi-environment delivery.
7. **Run the Smoke Test**  
   Use the provided script to verify your fix locally.
8. **Submit Your Completion**  
   Push to `main` to trigger the full verification workflow. Post a screenshot of the result in the Discourse thread to
   claim completion.
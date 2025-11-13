[![Static Badge](https://img.shields.io/badge/Open_Ecosystem_Challenge-Quest-FF9800)](https://open-ecosystem.discourse.group/t/about-the-challenges-category/16)
[![Static Badge](https://img.shields.io/badge/GitHub_Codespace-Launch-green?logo=github)](https://github.com/codespaces/new?hide_repo_select=true&repo=1090520100&skip_quickstart=true&machine=basicLinux32gb&devcontainer_path=.devcontainer/01-gitops-delivery/devcontainer.json&geo=EuropeWest)

# 🚀 Challenge 01: Echoes Lost in Orbit

Welcome to the first challenge in the Open Ecosystem challenge series! Your mission: restore interstellar communication
by TODO. This is a hands-on troubleshooting exercise using Kubernetes, Argo CD, and Kustomize.

<details>
<summary><strong>🌌 Backstory (click to expand)</strong></summary>
TODO
</details>

| 🧠 What You'll Learn                                                                                                                                                        | 🛠️ Prerequisites                                                           | ⏱️ Time    |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|------------|
| <ul><li>Debug broken GitOps flows</li><li>Understand Argo CD ApplicationSet pitfalls</li><li>Enforce environment isolation</li><li>Enable sync, prune & self-heal</li></ul> | <ul><li>Basic Kubernetes & Git</li><li>Argo CD & Kustomize basics</li></ul> | ~30–45 min |

## ⚡ Quick Start (5 minutes)

- Fork this repo
- Create a new codespace. ⚠️ click new with options and select challenge 1
- wait for the post create command to succeed. Follow with cmd shift p "view creation log"

## Level 1

## 🗂️ Repository Layout

- ApplicationSet manifest: `challenges/01-gitops-delivery/manifests/appset.yaml`
- Base Kubernetes manifests: `challenges/01-gitops-delivery/manifests/base/`
- Environment overlays:
    - Staging: `manifests/overlays/staging/`
    - Prod: `manifests/overlays/prod/`
- Quick reachability check: `challenges/01-gitops-delivery/verify-broken-level1.sh`

## 🧪 First Checkpoint (Reachability)

Verify each environment responds:

```bash
bash challenges/01-gitops-delivery/verify-broken-level1.sh
```

Or manually:

```bash
kubectl -n echo-staging port-forward svc/echo-server-staging 8081:80 &
kubectl -n echo-prod    port-forward svc/echo-server-prod    8082:80 &
# In another terminal
curl -s "http://localhost:8081/echo?msg=hello"
curl -s "http://localhost:8082/echo?msg=hello"
```

Stop port-forwards with `CTRL+C` or `kill` the background jobs.

## 🕵️ What’s (Deliberately) Broken?

This challenge begins with four subtle issues embedded in the ApplicationSet manifest. Your job is to discover & fix
them without guessing:

- Only one Application shows up.
- Both environments clash.
- Drift isn’t corrected.
- Old resources linger.
  (You’ll recognize them as you inspect names, namespaces, and sync behavior.)

## 🥇 Level 1 Goal

Restore a healthy, isolated GitOps setup:

- Separate Applications (staging + prod) with distinct names.
- Each in its own namespace (no collisions).
- Automatic sync + prune enabled.
- Manual changes self-heal back to Git.
- Both endpoints return your echoed message.

## 🧰 Debug Toolbox

| Tool        | Purpose                | Quick Use                                        |
|-------------|------------------------|--------------------------------------------------|
| kubectl     | Inspect live state     | `kubectl -n argocd get applications.argoproj.io` |
| k9s         | TUI for cluster        | `k9s` then browse namespaces                     |
| Argo CD UI  | Visual sync/drift view | http://localhost:30100                           |
| Argo CD CLI | Scriptable control     | `argocd app get <name>`                          |

## 🔄 Iterate & Apply

Edit `appset.yaml`, then re-apply:

```bash
kubectl apply -n argocd -f challenges/01-gitops-delivery/manifests/appset.yaml
```

Argo CD will reconcile changes shortly after.

## 🧪 (Optional) Manual Drift Test

After you think it’s fixed, try:

```bash
kubectl -n echo-prod patch deployment echo-server-prod -p '{"spec":{"replicas":3}}'
# Wait ~15s then check if it reverts
kubectl -n echo-prod get deploy echo-server-prod -o jsonpath='{.spec.replicas}'
```

If it returns to the Git-defined replica count automatically, self-heal works.

## 📤 Submission

Push your fixes:

```bash
git add .
git commit -m "chore: fix level 1"
git push origin main
```

A deeper verification workflow will run and validate all criteria.

## 📚 Helpful References

- Argo CD Docs: https://argo-cd.readthedocs.io/
- Kustomize Docs: https://kubectl.docs.kubernetes.io/references/kustomize/
- Kubernetes Docs: https://kubernetes.io/docs/

## 🆘 Need Help?

Open a GitHub Issue or explore with `k9s` to gain insight before asking.

Ready to re‑establish the Echo Server and let the galaxy speak again? 🌠

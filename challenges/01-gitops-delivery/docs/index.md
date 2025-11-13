# 💭 Challenge 01: Echoes Lost in Orbit

> 🚧 TODO update stack once all levels are done

Welcome to the first challenge in the **Open Ecosystem Challenge** series!  
Your mission: restore interstellar communication by fixing a broken GitOps setup.  
This is a hands-on troubleshooting exercise using **Kubernetes**, **Argo CD**, and **Kustomize**.

The entire **infrastructure is pre-provisioned in your Codespace** — Kubernetes cluster, Argo CD, and sample app are
ready to go.  
**You don’t need to set up anything locally. Just focus on solving the problem.**

## 🪐 Backstory

Welcome aboard the GitOps Starliner, a multi-species engineering vessel orbiting the vibrant planet of Polaris-9.  
Life in this quadrant is wonderfully diverse — from the whispering cloud-dwellers of Nebulon to the rhythmic
click-speakers of Crustacea Prime.

Communication between species used to be seamless, thanks to the Echo Server, a universal translator that instantly
echoed your words in the listener’s native format.

But lately, something’s off.

Messages are getting scrambled. Some transmissions never arrive. Others seem to overwrite each other.  
The Echo Server, deployed across the Staging Moonbase and the Production Outpost, is no longer syncing
properly.  
The Argo CD dashboard shows no active deployments, and telemetry from is suspiciously quiet.

You’ve been assigned to investigate the issue.

## 🧠 What You’ll Learn

> 🚧 TODO update once all levels are done

- How to reason about GitOps workflows and Argo CD ApplicationSets
- How to troubleshoot and fix misconfigurations in multi-environment setups
- How sync policies affect automation and drift correction

## ⏱️ Time Commitment

~2 hours total (split across 3 levels):

- Level 1: ~20 min
- Level 2: ~30 min
- Level 3: ~60 min

> This is a rough estimate for a mid-level Cloud/DevOps/Platform engineer

## ✅ Prerequisites

- Basic understanding of Kubernetes concepts (Deployments, Namespaces)
- Familiarity with Git and YAML
- No prior Argo CD experience required — you’ll learn as you go!

## 🛠 Toolbox

Your Codespace comes pre-installed with these tools:

- [`kubectl`](https://kubernetes.io/docs/reference/kubectl/): CLI to interact with your Kubernetes cluster
- [`kubectx` & `kubens`](https://github.com/ahmetb/kubectx): Switch between Kubernetes contexts and namespaces easily
- [`k9s`](https://k9scli.io/): Terminal UI to interact with your Kubernetes cluster

## 🏁 Get Started!

[Play Level 1](./level-1.md){ .md-button .md-button--primary }

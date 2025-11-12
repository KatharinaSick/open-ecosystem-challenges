# 🚀 Challenge 01: Echoes Lost in Orbit

TODO update technology

Welcome to the first challenge in the Open Ecosystem series! Your mission: restore communication across the galaxy by fixing a broken GitOps deployment. This is a hands-on troubleshooting exercise using Kubernetes, Argo CD, and Kustomize.

<details>
<summary><strong>🌌 Backstory (click to expand)</strong></summary>

Welcome aboard the GitOps Starliner, a multi-species engineering vessel orbiting the vibrant planet of Polaris-9. Life
in this quadrant is wonderfully diverse — from the whispering cloud-dwellers of Nebulon to the rhythmic click-speakers
of Crustacea Prime. Communication between species used to be seamless, thanks to the Echo Server, a universal translator
that instantly echoed your words in the listener’s native format.

But lately, something’s off.

Messages are getting scrambled. Some transmissions never arrive. Others seem to overwrite each other. The Echo Server,
deployed across the Staging Moonbase and the Production Outpost, is no longer syncing properly. The Argo CD dashboard
shows only one active deployment, and telemetry from the other site is suspiciously quiet.

You’ve been assigned to investigate the issue. The deployment manifests are stored in a shared GitOps repository, and
the system uses Argo CD with an ApplicationSet to manage environments. Somewhere in the configuration, something’s not
quite right.

</details>

| 🧠 What You'll Learn                                                                                                                                                                     | 🛠️ Prerequisites                                                               | ⏱️ Time Estimate |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|------------------|
| <ul><li>Troubleshoot Argo CD ApplicationSet issues</li><li>Isolate environments in Kubernetes</li><li>Configure auto-sync and pruning</li><li>Restore GitOps deployment health</li></ul> | <ul><li>Basic Kubernetes & Git</li><li>Argo CD & Kustomize experience</li></ul> | ~30-45 min       |

---

## 🎮 How to Play

You'll be working with a pre-provisioned setup. Everything you need is already running. Your job is to:
- Inspect the deployment and configuration
- Identify what's broken
- Fix the issues

To verify your solution, run the provided smoke test script. If it passes, push your changes to `main`—the GitHub Actions workflow will run a more thorough check for submission.

There are **3 levels** to this challenge, each building on the previous one and increasing in difficulty.

TODO add argocd login instructions somewhere

TODO test with. maybe create ./echo script? 
```
kubectl -n echo-prod port-forward svc/echo-server-prod 8080:80
curl -X POST http://localhost:8080 -d 'Hello World!'
```

### 🥇 Level 1: Restore the Echo Server

TODO maybe merge objectives & completion criteria? or change wording in objectives

**🔍 Objectives**
- Get both environments (`staging`, `prod`) of the echo server running again
- Ensure the system is robust and cannot be easily misconfigured

**✅ Completion Criteria**
- Two apps running & visible in Argo CD
- Both apps are reachable and return an echo
  - <em>To invoke:</em> <code>curl http://&lt;service-url&gt;/echo?msg=hello</code>
- Manual changes to resources are automatically reverted (Argo CD auto-sync/prune)

**🧪 Smoke Test**

Run:
```bash
./tests/smoke-test.sh
```
If the test passes, your solution is correct for Level 1.

## 📤 Submission

TODO. Invoke workflow manually? I think that's better with GitOps stuff :)

- Push your changes to the `main` branch.
- The GitHub Actions workflow will run a full verification.
- If all checks pass, you’ve completed the challenge!

---

Ready to restore the Echo Server and get the galaxy talking again?

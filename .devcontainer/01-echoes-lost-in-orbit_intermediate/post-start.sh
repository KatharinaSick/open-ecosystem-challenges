#!/usr/bin/env bash
set -e

echo "✨ Starting level 2 - Intermediate"

REPO_URL="https://github.com/${GITHUB_REPOSITORY}.git"
sed -i "s|__REPO_URL__|${REPO_URL}|g" adventures/01-echoes-lost-in-orbit/intermediate/manifests/appset.yaml

kubectl apply -n argocd -f adventures/01-echoes-lost-in-orbit/intermediate/manifests/appset.yaml

# Give ArgoCD some time to process the ApplicationSet and create the Rollout application
sleep 10

# Update echo-server image tag from 2.4 to 2.5 to trigger the rollout
sed -i 's|echoserver:2.4|echoserver:2.5|g' adventures/01-echoes-lost-in-orbit/intermediate/manifests/base/rollout.yaml
git add adventures/01-echoes-lost-in-orbit/intermediate/manifests/base/rollout.yaml
git commit -m "Update echo-server image to 2.5"
git push

# Refresh ArgoCD to pick up the new commit
argocd app get echo-server-staging --refresh
argocd app get echo-server-prod --refresh

features/argo-rollouts/connect.sh

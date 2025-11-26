#!/usr/bin/env bash
set -e

echo "✨ Starting level 2 - Intermediate"

echo "✨ Exposing Argo Rollouts dashboard"
kubectl argo rollouts dashboard --port 30101 &

#REPO_URL="https://github.com/${GITHUB_REPOSITORY}.git"
#sed -i "s|__REPO_URL__|${REPO_URL}|g" adventures/01-echoes-lost-in-orbit/beginner/manifests/appset.yaml
#
#kubectl apply -n argocd -f adventures/01-echoes-lost-in-orbit/beginne˚r/manifests/appset.yaml
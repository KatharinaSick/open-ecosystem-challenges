#!/usr/bin/env bash
set -e

echo "✨ Starting level 1"

REPO_URL="https://github.com/${GITHUB_REPOSITORY}.git"
sed -i "s|__REPO_URL__|${REPO_URL}|g" adventures/01-echoes-lost-in-orbit/easy/manifests/appset.yaml

kubectl apply -n argocd -f adventures/01-echoes-lost-in-orbit/easy/manifests/appset.yaml
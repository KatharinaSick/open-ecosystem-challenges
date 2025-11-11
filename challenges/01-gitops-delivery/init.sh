#!/usr/bin/env bash
set -e

# TODO
# REPO_URL="https://github.com/${GITHUB_REPOSITORY}.git"
# sed -i "s#__REPO_URL__#${REPO_URL//\//\\/}#g" challenges/01-gitops-delivery/manifests/applicationset.yaml

kubectl apply -n argocd -f challenges/01-gitops-delivery/manifests/appset.yaml
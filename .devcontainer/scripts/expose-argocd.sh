#!/usr/bin/env bash
set -e

# Expose Argo CD Server on HTTP
kubectl port-forward svc/argocd-server -n argocd 8080:80 &


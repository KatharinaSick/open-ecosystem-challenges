#!/usr/bin/env bash
set -e

showFlags() {
  echo " --help         Display this help message"
  echo " --show-flags   Shows available flags"
  echo " --read-only    Disables the ArgoCD admin user and only provides read-only access"
}

help() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  showFlags
}

# Parse flags
read_only=false

for arg in "$@"; do
  case "$arg" in
    --help)
      help
      exit 0
      ;;
    --show-flags)
      showFlags
      exit 0
      ;;
    --read-only)
      read_only=true
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

echo "Installing Argo CD..."
kubectl create namespace argocd
kubectl apply -k features/argocd/manifests

echo "Installing Argo CD CLI..."
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v3.2.0/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

echo "Waiting for Argo CD server to be ready..."
kubectl rollout status deployment/argocd-server -n argocd --timeout=300s

echo "Setting password for alice user..."
admin_password=$(argocd admin initial-password -n argocd)
argocd login localhost:8080 --insecure --username admin --password "$admin_password" --port-forward
argocd account update-password \
  --account alice \
  --current-password $admin_password \
  --new-password a-super-secure-password

if [ "$read_only" = true ]; then
  echo "read only mode enabled"
fi

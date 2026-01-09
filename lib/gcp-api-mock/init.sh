#!/usr/bin/env bash
set -e

echo "✨ Starting the GCP API Mock"
docker run -d -p 30104:8080 ghcr.io/katharinasick/gcp-api-mock:v1.0.0

export STORAGE_EMULATOR_HOST="http://localhost:30104"

echo "✅ GCP API Mock is ready"
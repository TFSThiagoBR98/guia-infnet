#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Aplicando manifests Kubernetes..."

kubectl apply -f "${SCRIPT_DIR}/2-redis-pod-service.yaml"
kubectl apply -f "${SCRIPT_DIR}/3-pvc.yaml"
kubectl apply -f "${SCRIPT_DIR}/1-app-deployment-service.yaml"
kubectl apply -f "${SCRIPT_DIR}/4-writer-pod.yaml"
kubectl apply -f "${SCRIPT_DIR}/5-reader-pod.yaml"

echo "Deploy concluido."

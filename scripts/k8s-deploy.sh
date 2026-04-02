#!/bin/bash
set -e

# 1. Setup paths relative to the script location
# This ensures it works if run from root or from within the scripts folder
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
NAMESPACE="much-todo"
CLUSTER_NAME="much-todo-cluster" 
IMAGE_NAME="backend-app:latest"

cd "$ROOT_DIR"

echo "--- 📦 1. Building and Loading Image into Kind ---"
# We build it here to ensure the latest code is used
docker build -t $IMAGE_NAME -f Dockerfile .
kind load docker-image $IMAGE_NAME --name $CLUSTER_NAME

echo "--- 2. Creating Namespace ---"
kubectl apply -f kubernetes/namespace.yaml

echo "--- 3. Deploying MongoDB Resources ---"
kubectl apply -f kubernetes/mongodb/

echo "--- 4. Waiting for MongoDB to be ready ---"
kubectl wait --for=condition=ready pod -l app=mongodb -n $NAMESPACE --timeout=120s

echo "--- 5. Deploying Backend Resources ---"
kubectl apply -f kubernetes/backend/

echo "--- 6. Deploying Ingress ---"
kubectl apply -f kubernetes/ingress.yaml

echo "--- Deployment Finished ---"
kubectl get all -n $NAMESPACE
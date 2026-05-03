#!/bin/bash
set -e

# 1. Setup paths relative to the script location
# This ensures it works if run from root or from within the scripts folder
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
NAMESPACE="much-todo"
CLUSTER_NAME="much-todo-cluster" 
BACKEND_IMAGE="backend-app:latest"
FRONTEND_IMAGE="frontend-app:latest"

cd "$ROOT_DIR"

echo "--- 1. Ensuring Kind Cluster Exists ---"
if kind get clusters | grep -qx "$CLUSTER_NAME"; then
	echo "Cluster '$CLUSTER_NAME' already exists."
else
	kind create cluster --name "$CLUSTER_NAME" --config kind-config.yaml
fi

echo "--- 2. Waiting for Cluster to Be Ready ---"
kubectl config use-context "kind-$CLUSTER_NAME" >/dev/null
kubectl wait --for=condition=Ready "node/$CLUSTER_NAME-control-plane" --timeout=180s

echo "--- 3. Building and Loading Images into Kind ---"
# Build backend
docker build -t "$BACKEND_IMAGE" -f Dockerfile .
kind load docker-image "$BACKEND_IMAGE" --name "$CLUSTER_NAME"

# Build frontend
cd Client
docker build -t "$FRONTEND_IMAGE" .
cd ..
kind load docker-image "$FRONTEND_IMAGE" --name "$CLUSTER_NAME"

echo "--- 4. Creating Namespace ---"
kubectl apply -f kubernetes/namespace.yaml

echo "--- 5. Deploying MongoDB Resources ---"
kubectl apply -f kubernetes/mongodb/

echo "--- 6. Waiting for MongoDB to be ready ---"
kubectl wait --for=condition=ready pod -l app=mongodb -n "$NAMESPACE" --timeout=300s

echo "--- 7. Deploying Backend Resources ---"
kubectl apply -f kubernetes/backend/

echo "--- 8. Deploying Frontend Resources ---"
kubectl apply -f kubernetes/frontend/

echo "--- 9. Deploying Ingress ---"
kubectl apply -f kubernetes/ingress.yaml

echo "--- Deployment Finished ---"
kubectl get all -n "$NAMESPACE"
kubectl get ingress -n "$NAMESPACE"

echo "--- Browser Access ---"
echo "Ingress (if ingress-nginx is installed): http://localhost"
echo "Port-forward frontend: kubectl port-forward svc/frontend-service 8082:80 -n $NAMESPACE"
echo "Port-forward backend:  kubectl port-forward svc/backend-service 8080:80 -n $NAMESPACE"
echo "Frontend URL: http://localhost:8082"
echo "Backend health URL: http://localhost:8080/health"
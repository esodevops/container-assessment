#!/bin/bash

# Move to the project root to ensure consistency
cd "$(dirname "$0")/.."

NAMESPACE="much-todo"

echo "--- Starting Kubernetes Cleanup for Namespace: $NAMESPACE ---"

# Check if the namespace exists before trying to delete it
if kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
    echo "--- Deleting Namespace and all associated resources... ---"
    # Deleting a namespace can take a minute as K8s cleans up resources
    kubectl delete namespace "$NAMESPACE" --wait=true
    echo "--- Namespace '$NAMESPACE' deleted successfully. ---"
else
    echo "--- Namespace '$NAMESPACE' does not exist. Skipping. ---"
fi

# Optional: Clean up orphaned Persistent Volumes if any exist 
# (Useful if you've been testing storage and things got messy)
echo "--- Checking for orphaned Persistent Volumes... ---"
kubectl get pv | grep "Released" | awk '{print $1}' | xargs -r kubectl delete pv

# Optional: Clear the local Docker image to save space
echo "--- Removing local backend image... ---"
docker rmi backend-app:latest --force 2>/dev/null || true

echo "--- Cleanup Complete! ---"
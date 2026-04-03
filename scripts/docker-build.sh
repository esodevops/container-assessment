#!/bin/bash
set -e

# This ensures the script works even if you run it from inside the scripts/ folder
cd "$(dirname "$0")/.."

echo "--- 🔨 Building Backend Docker Image ---"

# Build the Docker image for the backend
docker build -t backend-app:latest -f Dockerfile .

echo "--- 🔨 Building Frontend Docker Image ---"

# Build the Docker image for the frontend
cd Client
docker build -t frontend-app:latest .
cd ..

echo "--- ✅ Build Complete: backend-app:latest and frontend-app:latest ---"
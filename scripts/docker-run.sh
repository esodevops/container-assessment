#!/bin/bash
set -e

# Ensure we are operating from the project root
cd "$(dirname "$0")/.."

echo "--- Starting Local Development Environment ---"

# Force a pull of third-party images (Mongo/Redis) and start
# We use --build to ensure the backend uses the latest local changes
docker-compose up -d --build

echo "--- Container Status ---"
docker-compose ps

echo "--- Services Status ---"
echo "Backend: http://localhost:8080"
echo "Mongo Express: http://localhost:8081"
echo "Redis Commander: http://localhost:8082"


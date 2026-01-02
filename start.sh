#!/bin/bash
set -e

echo "Starting Poseidon in Production mode..."

# Ensure clean state
docker stack rm poseidon || true
# Wait for services to shutdown
echo "Waiting for stack to be removed..."
while docker stack ls | grep -q "poseidon"; do
    echo "Stack still active, waiting..."
    sleep 2
done
echo "Stack removed."

# Start the services
docker stack deploy --prune -c docker-compose.yml poseidon

echo "Production environment deployed successfully."

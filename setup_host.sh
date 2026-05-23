#!/bin/bash
set -e

# Setup Host Directories for Poseidon (AdGuard Home)
echo "Ensuring host directories exist..."

# AdGuard Home Config
if [ ! -d "/opt/poseidon/conf" ]; then
    echo "Creating /opt/poseidon/conf..."
    sudo mkdir -p /opt/poseidon/conf
    sudo chown -R 1000:1000 /opt/poseidon/conf
fi

# AdGuard Home Work/Data
if [ ! -d "/opt/poseidon/work" ]; then
    echo "Creating /opt/poseidon/work..."
    sudo mkdir -p /opt/poseidon/work
    sudo chown -R 1000:1000 /opt/poseidon/work
fi

echo "Host setup complete."

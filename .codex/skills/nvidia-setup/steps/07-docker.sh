#!/usr/bin/env bash
# Step 7: Configure Docker for NVIDIA GPU access.

set -euo pipefail

echo "=== Configuring Docker for NVIDIA GPU ==="

echo "Installing nvidia-container-toolkit..."
sudo apt-get install -y nvidia-container-toolkit

echo "Configuring Docker runtime..."
sudo nvidia-ctk runtime configure --runtime=docker

echo "Restarting Docker..."
sudo systemctl restart docker

echo
echo "Docker NVIDIA runtime:"
docker info | grep -i nvidia || echo "Not found (may need logout/login)"

echo
echo "nvidia-container-cli info:"
nvidia-container-cli info 2>/dev/null || echo "Not available"

echo
echo "=== Docker configured ==="
echo "NOTE: You may need to logout/login for Docker to pick up the NVIDIA runtime"

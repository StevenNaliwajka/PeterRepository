#!/bin/bash

set -e

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/../..")"
ENV_FILE="$PROJECT_ROOT/Config/gif_pathing.env"

# Load environment variables
if [ ! -f "$ENV_FILE" ]; then
  echo "[ERROR] gif_pathing.env not found at $ENV_FILE"
  exit 1
fi

# Export variables from the .env file
set -a
source "$ENV_FILE"
set +a

# Strip trailing slashes from GIF_BASE_PATH
MOUNT_PATH="${GIF_BASE_PATH%/}"

# Validate required variables
if [[ -z "$NAS_SHARE" || -z "$NAS_USERNAME" || -z "$NAS_PASSWORD" || -z "$NAS_VERSION" ]]; then
  echo "[ERROR] One or more required NAS variables (NAS_SHARE, NAS_USERNAME, NAS_PASSWORD, NAS_VERSION) are missing in gif_pathing.env"
  exit 1
fi

# Create mount point if it doesn't exist
if [ ! -d "$MOUNT_PATH" ]; then
  echo "[INFO] Creating mount point at $MOUNT_PATH"
  sudo mkdir -p "$MOUNT_PATH"
fi

# Mount the NAS
echo "[INFO] Mounting NAS share $NAS_SHARE to $MOUNT_PATH"
sudo mount -t cifs "$NAS_SHARE" "$MOUNT_PATH" \
  -o username="$NAS_USERNAME",password="$NAS_PASSWORD",vers="$NAS_VERSION",uid=0,gid=0

echo "[SUCCESS] NAS mounted at $MOUNT_PATH"

#!/bin/bash

# Get absolute path two levels up
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(realpath "$SCRIPT_DIR/../..")/Config"
DEFAULT_REPO_GIF_PATH="$(realpath "$SCRIPT_DIR/../..")/GIFs"

# Ensure the config directory exists
mkdir -p "$TARGET_DIR"

echo "Choose where to store GIFs:"
echo "1) Inside the repo (default): $DEFAULT_REPO_GIF_PATH"
echo "2) Custom local path"
echo "3) Network-mounted path (e.g., /mnt/nas/gifs)"
read -rp "Enter option [1-3]: " option

case "$option" in
  2)
    read -rp "Enter full local path: " custom_path
    GIF_PATH="$custom_path"
    ;;
  3)
    read -rp "Enter full network-mounted path: " network_path
    GIF_PATH="$network_path"
    ;;
  *)
    GIF_PATH="$DEFAULT_REPO_GIF_PATH"
    ;;
esac

# Convert to relative URL path for FastAPI use
GIF_BASE_URL="/static/gifs"

# Write .env config
{
  echo "GIF_BASE_PATH=$GIF_PATH"
  echo "GIF_BASE_URL=$GIF_BASE_URL"
} > "$TARGET_DIR/gif_pathing.env"

echo "Created $TARGET_DIR/gif_pathing.env with:"
echo "GIF_BASE_PATH=$GIF_PATH"
echo "GIF_BASE_URL=$GIF_BASE_URL"

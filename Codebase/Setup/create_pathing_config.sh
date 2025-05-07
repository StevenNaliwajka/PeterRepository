#!/bin/bash

# Get absolute path two levels up
TARGET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/Config"

# Ensure the target config directory exists
mkdir -p "$TARGET_DIR"

# Define the JSON content
read -r -d '' JSON_CONTENT << 'EOF'
# Absolute path to where your GIFs are stored locally
GIF_BASE_PATH=/home/kevin/PycharmProjects/PeterRepository/GIFs

# Base URL to serve those GIFs publicly (e.g. via Nginx or FastAPI static files)
GIF_BASE_URL=http://localhost:8000/static/gifs
EOF

# Write the JSON to the target path
echo "$JSON_CONTENT" > "$TARGET_DIR/gif_pathing.env"

echo "Created $TARGET_DIR/gif_pathing.env"

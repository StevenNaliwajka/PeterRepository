#!/bin/bash

# Get absolute path two levels up
TARGET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/Config"

# Ensure the target config directory exists
mkdir -p "$TARGET_DIR"

# Define the JSON content
read -r -d '' JSON_CONTENT << 'EOF'
{
  "rules": [
    {
      "name": "halloween",
      "folder": "holidays/halloween",
      "start": "10-25",
      "end": "10-31"
    },
    {
      "name": "xmas",
      "folder": "holidays/xmas",
      "start": "12-20",
      "end": "12-26"
    },
    {
      "name": "spring",
      "folder": "seasons/spring",
      "start": "03-01",
      "end": "05-31"
    },
    {
      "name": "fallback",
      "folder": "fallback",
      "default": true
    }
  ]
}
EOF

# Write the JSON to the target path
echo "$JSON_CONTENT" > "$TARGET_DIR/gif_config.json"

echo "Created $TARGET_DIR/gif_config.json"

#!/bin/bash

APP_DIR="$(dirname "$0")/Codebase/Setup"
PID_FILE="./flask_api.pid"

cd "$APP_DIR"

if [ -f "$PID_FILE" ]; then
    echo "API already running. PID $(cat $PID_FILE)"
    exit 1
fi

echo "Starting Flask API..."
python3 flask_api.py &

echo $! > "$PID_FILE"
echo "Flask API started with PID $(cat $PID_FILE)"

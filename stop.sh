#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$SCRIPT_DIR/Codebase/FastAPIapp/fastapi_api.pid"

if [ ! -f "$PID_FILE" ]; then
    echo "No running FastAPI server found."
    exit 1
fi

PID=$(cat "$PID_FILE")

if ps -p "$PID" > /dev/null 2>&1; then
    echo "Stopping FastAPI server with PID $PID..."
    kill "$PID"
    sleep 1
    echo "FastAPI server stopped."
else
    echo "Process $PID not running. Cleaning up stale PID file."
fi

rm -f "$PID_FILE"

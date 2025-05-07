#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR/Codebase"
# Determine the project root
PROJECT_ROOT="$(cd "$SCRIPT_DIR" && pwd)"
echo "project root $PROJECT_ROOT"

# Path to virtual environment
VENV_DIR="$PROJECT_ROOT/.venv"
# Activate virtual environment
source "$VENV_DIR/bin/activate"
APP_MODULE="main:app"
PID_FILE="$REPO_DIR/FastAPIapp/fastapi_api.pid"



cd "$REPO_DIR"
export PYTHONPATH="$REPO_DIR:$PYTHONPATH"

# Restart if already running
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "API already running. Restarting (PID $PID)..."
        kill "$PID"
        sleep 1
    fi
    rm -f "$PID_FILE"
fi

echo "Starting FastAPI..."
uvicorn "$APP_MODULE" --host 0.0.0.0 --port 8000 &

echo $! > "$PID_FILE"
echo "FastAPI started with PID $(cat "$PID_FILE")"

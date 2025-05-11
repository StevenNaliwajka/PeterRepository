#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
VENV_DIR="$PROJECT_ROOT/.venv"
APP_PORT=8000
MOUNT_SCRIPT="$PROJECT_ROOT/Codebase/Setup/mount_nas.sh"

# Run NAS mount script
echo "Mounting NAS if needed..."
bash "$MOUNT_SCRIPT" || {
  echo "[ERROR] Failed to mount NAS. Exiting."
  exit 1
}

# Kill any process using the target port (likely a previous run of this app)
echo "Checking for existing process on port $APP_PORT..."
PID_TO_KILL=$(lsof -ti tcp:$APP_PORT)

if [ -n "$PID_TO_KILL" ]; then
  echo "Killing process on port $APP_PORT (PID: $PID_TO_KILL)..."
  if kill "$PID_TO_KILL"; then
    echo "Gracefully killed PID $PID_TO_KILL."
  else
    echo "Force killing PID $PID_TO_KILL..."
    if kill -9 "$PID_TO_KILL"; then
      echo "Successfully force-killed PID $PID_TO_KILL."
    else
      echo "[ERROR] Failed to kill process on port $APP_PORT. Exiting."
      exit 1
    fi
  fi
else
  echo "No process currently using port $APP_PORT."
fi

# Activate virtual environment
source "$VENV_DIR/bin/activate"

# Move to correct directory
cd "$PROJECT_ROOT/Codebase"
export PYTHONPATH=".:$PYTHONPATH"

# Start the app (non-blocking or wait-friendly)
echo "Running FastAPI from $(pwd)"
exec uvicorn main:app --host 0.0.0.0 --port 8000

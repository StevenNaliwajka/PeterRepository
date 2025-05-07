#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
VENV_DIR="$PROJECT_ROOT/.venv"
APP_PORT=8000

# Kill any process using the target port (likely a previous run of this app)
echo "Checking for existing process on port $APP_PORT..."
PID_TO_KILL=$(lsof -ti tcp:$APP_PORT)

if [ -n "$PID_TO_KILL" ]; then
  echo "Killing process on port $APP_PORT (PID: $PID_TO_KILL)..."
  kill "$PID_TO_KILL" || {
    echo "Force killing PID $PID_TO_KILL..."
    kill -9 "$PID_TO_KILL"
  }
else
  echo "No process currently using port $APP_PORT."
fi

# Activate virtual environment
source "$VENV_DIR/bin/activate"

# Move to correct directory
cd "$PROJECT_ROOT/Codebase"
export PYTHONPATH=".:$PYTHONPATH"

# Start the app
echo "Running FastAPI from $(pwd)"
exec uvicorn main:app --host 0.0.0.0 --port $APP_PORT

#!/bin/bash

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR/Codebase"
PROJECT_ROOT="$(cd "$SCRIPT_DIR" && pwd)"
VENV_DIR="$PROJECT_ROOT/.venv"

echo "project root $PROJECT_ROOT"

# Activate virtual environment
source "$VENV_DIR/bin/activate"

# Set app module and directory
APP_MODULE="main:app"
cd "$REPO_DIR"
export PYTHONPATH="$REPO_DIR:$PYTHONPATH"

echo "Starting FastAPI..."
exec uvicorn "$APP_MODULE" --host 0.0.0.0 --port 8000
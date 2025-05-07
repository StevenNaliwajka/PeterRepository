#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR" && pwd)"
VENV_DIR="$PROJECT_ROOT/.venv"
REPO_DIR="$PROJECT_ROOT/Codebase"
APP_MODULE="Codebase.FastAPIapp.main:app"

echo "project root $PROJECT_ROOT"

cd "$PROJECT_ROOT"
source "$VENV_DIR/bin/activate"
export PYTHONPATH="$REPO_DIR:$PYTHONPATH"

echo "Starting FastAPI..."
exec uvicorn "$APP_MODULE" --host 0.0.0.0 --port 8000

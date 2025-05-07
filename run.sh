#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
VENV_DIR="$PROJECT_ROOT/.venv"

source "$VENV_DIR/bin/activate"

cd "$PROJECT_ROOT/Codebase/FastAPIapp"
echo "Running FastAPI from $(pwd)"

exec uvicorn main:app --host 0.0.0.0 --port 8000
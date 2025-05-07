#!/bin/bash

echo "Setting up Python virtual environment..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/../..")"
VENV_DIR="$PROJECT_ROOT/.venv"
REQUIREMENTS_FILE="$SCRIPT_DIR/requirements.txt"

APT_CMD="apt install -y"

# Use sudo only if not running as root
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

# Detect active Python version (e.g., 3.11)
PY_VER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")

# Ensure core Python dependencies
if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found, installing..."
  apt update && $SUDO $APT_CMD python3
fi

if ! command -v pip3 >/dev/null 2>&1; then
  echo "pip3 not found, installing..."
  $SUDO $APT_CMD python3-pip
fi

# Ensure version-specific venv is installed
$SUDO $APT_CMD python${PY_VER}-venv >/dev/null 2>&1
if ! python3 -m venv --help >/dev/null 2>&1; then
  echo "Failed to install python${PY_VER}-venv or venv is still broken."
  echo "Try manually running: apt install python${PY_VER}-venv"
  exit 1
fi


# Recreate virtual environment
if [ -d "$VENV_DIR" ]; then
  echo "Removing existing virtual environment at: $VENV_DIR"
  rm -rf "$VENV_DIR"
fi

echo "Creating new virtual environment at: $VENV_DIR"
python3 -m venv "$VENV_DIR"
VENV_OK=$?

if [ $VENV_OK -ne 0 ]; then
  echo "Failed to create virtual environment. ensurepip may still be missing."
  echo "Try: apt install python${PY_VER}-venv"
  exit 1
fi

# Activate and install dependencies
if [ -f "$VENV_DIR/bin/activate" ]; then
  echo "Activating virtual environment..."
  source "$VENV_DIR/bin/activate"

  if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "Installing packages from $REQUIREMENTS_FILE"
    pip install --upgrade pip
    pip install -r "$REQUIREMENTS_FILE"
    echo "Virtual environment is ready."
  else
    echo "No requirements.txt found at: $REQUIREMENTS_FILE"
  fi
else
  echo "Error: activate script not found in $VENV_DIR"
  exit 1
fi

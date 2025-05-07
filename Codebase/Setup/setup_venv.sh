#!/bin/bash

echo "Setting up Python virtual environment..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/../..")"
VENV_DIR="$PROJECT_ROOT/.venv"
REQUIREMENTS_FILE="$SCRIPT_DIR/requirements.txt"

APT_CMD="apt install -y"

# Only use sudo if not running as root
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

# Check and install python3
if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found, installing..."
  apt update && $SUDO $APT_CMD python3
fi

# Check and install python3-venv
if ! python3 -m venv --help >/dev/null 2>&1; then
  echo "python3-venv not found, installing..."
  $SUDO $APT_CMD python3-venv
fi

# Check and install pip3
if ! command -v pip3 >/dev/null 2>&1; then
  echo "pip3 not found, installing..."
  $SUDO $APT_CMD python3-pip
fi

# Detect active python version (e.g., 3.11)
PY_VER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")

# Ensure venv support for that Python version
if ! python3 -m venv --help >/dev/null 2>&1; then
  echo "python3-venv for Python $PY_VER not found, installing python$PY_VER-venv..."
  $SUDO apt install -y python$PY_VER-venv
fi


# Recreate virtual environment (forcefully)
if [ -d "$VENV_DIR" ]; then
  echo "Removing existing virtual environment at: $VENV_DIR"
  rm -rf "$VENV_DIR"
fi

echo "Creating new virtual environment at: $VENV_DIR"
python3 -m venv "$VENV_DIR"

# Activate and install dependencies
if [ -f "$VENV_DIR/bin/activate" ]; then
  echo "Activating virtual environment..."
  source "$VENV_DIR/bin/activate"

  if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "Installing packages from $REQUIREMENTS_FILE"
    pip install --upgrade pip
    pip install -r "$REQUIREMENTS_FILE"
    echo "Done."
  else
    echo "No requirements.txt found at: $REQUIREMENTS_FILE"
  fi
else
  echo "Error: activate script not found in $VENV_DIR"
  echo "You likely need to reinstall python3-venv and recreate the venv:"
  echo "    apt install python3-venv"
  echo "    python3 -m venv .venv"
  exit 1
fi

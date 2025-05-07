#!/bin/bash

echo "Setting up Python virtual environment..."

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../.."
VENV_DIR="$PROJECT_ROOT/.venv"
REQUIREMENTS_FILE="$SCRIPT_DIR/requirements.txt"

# Check for python3
if ! command -v python3 >/dev/null 2>&1; then
  echo "Python3 is not installed. Installing..."
  sudo apt update && sudo apt install -y python3
fi

# Check for python3-venv
if ! python3 -m venv --help >/dev/null 2>&1; then
  echo "python3-venv is not installed. Installing..."
  sudo apt install -y python3-venv
fi

# Check for pip
if ! command -v pip3 >/dev/null 2>&1; then
  echo "pip3 is not installed. Installing..."
  sudo apt install -y python3-pip
fi

# Create venv
if [ ! -d "$VENV_DIR" ]; then
  echo "Creating virtual environment at: $VENV_DIR"
  python3 -m venv "$VENV_DIR"
else
  echo "Virtual environment already exists at: $VENV_DIR"
fi

# Activate and install dependencies
if [ -f "$VENV_DIR/bin/activate" ]; then
  echo "Activating virtual environment..."
  source "$VENV_DIR/bin/activate"

  if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "Installing requirements from $REQUIREMENTS_FILE"
    pip install --upgrade pip
    pip install -r "$REQUIREMENTS_FILE"
    echo "Dependencies installed."
  else
    echo "No requirements.txt found at: $REQUIREMENTS_FILE"
  fi
else
  echo "Error: activate script not found in $VENV_DIR"
  exit 1
fi

#!/bin/bash

echo "Welcome to Peter Repo Setup"

# Determine sudo usage
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

# Setup Configs
bash Codebase/Setup/create_config.sh
bash Codebase/Setup/create_pathing_config.sh

# Install Python
bash Codebase/Setup/install_python.sh

# Create VENV and install requirements
bash Codebase/Setup/setup_venv.sh

# Create necessary folder
mkdir -p Codebase/FastAPIapp

# Ensure run.sh is executable
chmod +x "$(pwd)/run.sh"

echo ""
read -p "Do you want to run the app on startup using systemctl? (y/n): " setup_systemd

if [[ "$setup_systemd" =~ ^[Yy]$ ]]; then
    bash Codebase/Setup/setup_systemd.sh
else
    echo "Skipping systemd setup."
fi

echo ""
echo "Setup complete!"
echo "Update './Config/sites.json'"
echo "After that, deploy your configuration with ./run.sh"

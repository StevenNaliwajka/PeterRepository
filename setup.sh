#!/bin/bash

echo "Welcome to Peter Repo Setup"

# Setup Configs
bash Codebase/Setup/create_config.sh
bash Codebase/Setup/create_pathing_config.sh

# Install Python
bash Codebase/Setup/install_python.sh

# Create VENV and install requirements
bash Codebase/Setup/setup_venv.sh

mkdir Codebase/FastAPIapp



echo "Setup complete!"
echo "Update './Config/sites.json'"
echo "After that, deploy your configuration with ./run.sh"

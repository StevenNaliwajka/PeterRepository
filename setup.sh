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

mkdir -p Codebase/FastAPIapp

# Ensure run.sh is executable
chmod +x "$(pwd)/run.sh"

echo ""
read -p "Do you want to run the app on startup using systemctl? (y/n): " setup_systemd

if [[ "$setup_systemd" == "y" || "$setup_systemd" == "Y" ]]; then
    SERVICE_FILE="/etc/systemd/system/peter.service"
    CURRENT_USER=$(whoami)
    WORKING_DIR="$(pwd)"
    RUN_SCRIPT="$WORKING_DIR/run.sh"

    echo "Creating systemd service at $SERVICE_FILE"

    $SUDO bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Peter Repo FastAPI Server
After=network.target

[Service]
Type=simple
User=$CURRENT_USER
WorkingDirectory=$WORKING_DIR
ExecStart=/bin/bash $RUN_SCRIPT
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    $SUDO systemctl daemon-reload
    $SUDO systemctl enable peter.service
    $SUDO systemctl start peter.service
    echo "Systemd service enabled and started! It will run on boot."
else
    echo "Skipping systemd setup."
fi

echo ""
echo "Setup complete!"
echo "Update './Config/sites.json'"
echo "After that, deploy your configuration with ./run.sh"

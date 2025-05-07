#!/bin/bash

echo "Welcome to Peter Repo Setup"

# Setup Configs
bash Codebase/Setup/create_config.sh
bash Codebase/Setup/create_pathing_config.sh

# Install Python
bash Codebase/Setup/install_python.sh

# Create VENV and install requirements
bash Codebase/Setup/setup_venv.sh

mkdir -p Codebase/FastAPIapp

echo ""
read -p "Do you want to run the app on startup using systemctl? (y/n): " setup_systemd

if [[ "$setup_systemd" == "y" || "$setup_systemd" == "Y" ]]; then
    SERVICE_FILE="/etc/systemd/system/peter.service"

    echo "Creating systemd service at $SERVICE_FILE"

    sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Peter Repo FastAPI Server
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/run.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reexec
    sudo systemctl enable peter.service
    echo "Systemd service enabled! It will run on boot."
else
    echo "Skipping systemd setup."
fi

echo ""
echo "Setup complete!"
echo "Update './Config/sites.json'"
echo "After that, deploy your configuration with ./run.sh"

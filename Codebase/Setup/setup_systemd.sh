#!/bin/bash

set -e

# Determine sudo usage
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

SERVICE_FILE="/etc/systemd/system/peter.service"
WORKING_DIR="$(pwd)"
RUN_SCRIPT="$WORKING_DIR/run.sh"

echo "Creating systemd service at $SERVICE_FILE"

$SUDO bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Peter Repo FastAPI Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$WORKING_DIR
ExecStart=/bin/bash $RUN_SCRIPT
Restart=always
RestartSec=3
StandardOutput=append:/var/log/peter.log
StandardError=append:/var/log/peter.err
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

$SUDO systemctl daemon-reload
$SUDO systemctl enable peter.service
$SUDO systemctl start peter.service

echo "Systemd service enabled and started! It will run on boot."

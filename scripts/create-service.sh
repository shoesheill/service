source "$(dirname "$0")/../.env"
# Current user
CURRENT_USER=$(whoami)

# Current folder (where this script is located)
CURRENT_DIR=$(pwd)

# Service file path
SERVICE_FILE="$CURRENT_DIR/../systemd/$SERVICE_FILE"

# Ensure folder exists
mkdir -p "$(dirname "$SERVICE_FILE")"

# Write the service file
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Start services required for ASEC
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
User=$CURRENT_USER
ExecStart=/bin/bash $CURRENT_DIR/start.sh
ExecStop=/bin/bash $CURRENT_DIR/stop.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

echo "Service file created at: $SERVICE_FILE"

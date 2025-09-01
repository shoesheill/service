# set -a; source ../.env; set +a
source "$(dirname "$0")/../.env"


echo "Copying service file from $PROJECT_PATH ..."
echo "Copying service file to $DEST_PATH ..."

DEST_PATH="$DEST_PATH/$SERVICE_FILE"

# sudo groupadd docker 
# sudo usermod -aG docker $USER
# newgrp docker

echo "Copying service file to $DEST_PATH ..."
# sudo cp "$PROJECT_PATH/systemd/$SERVICE_FILE" "$DEST_PATH"
sudo chmod 644 ../systemd/$SERVICE_FILE
sudo cp ../systemd/$SERVICE_FILE "$DEST_PATH"
sudo 
echo "Setting up systemd service..."
eval "$INSTALL_UFW"
eval "$ALLOW_POSTGRES"
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_FILE"
sudo systemctl start "$SERVICE_FILE"

echo "$SERVICE_FILE created sucessfuly. Service is active."
echo "To check status, use: sudo systemctl status $SERVICE_FILE"
echo "To view logs, use: sudo journalctl -u $SERVICE_FILE -f"
echo "To stop the service, use: sudo systemctl stop $SERVICE_FILE"
echo "To restart the service, use: sudo systemctl restart $SERVICE_FILE"

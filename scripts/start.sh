set -a
source "$(dirname "$0")/../.env"
set +a

cd "$PROJECT_PATH/docker" 
echo "Starting Docker containers...PROJECT_PATH: $PROJECT_PATH"
# go to project docker folder and start
cd "$PROJECT_PATH/docker"
$DOCKER_COMPOSE_UP_BUILD
echo "Docker containers started."
echo "To check status, use: sudo systemctl status $SERVICE_FILE"
echo "To view logs, use: sudo journalctl -u $SERVICE_FILE -f"
echo "To stop the service, use: sudo systemctl stop $SERVICE_FILE"
echo "To restart the service, use: sudo systemctl restart $SERVICE_FILE"
echo "To stop and remove containers, use: $DOCKER_COMPOSE_DOWN"
echo "To view running containers, use: docker ps"
echo "To view all containers (including stopped), use: docker ps -a"
echo "To view Docker logs, use: docker logs <container_id>"
echo "If it did not work yet, contact the developer who wrote this script."
set -a
source "$(dirname "$0")/../.env"
set +a

cd "$PROJECT_PATH/docker" 
echo "Starting Docker containers...PROJECT_PATH: $PROJECT_PATH"
# go to project docker folder and start
cd "$PROJECT_PATH/docker"
# Conditional down
if [ "$RESET_DOCKER_VOLUMES" = "true" ]; then
    echo "RESET_DOCKER_VOLUMES=$RESET_DOCKER_VOLUMES -> Removing containers AND volumes"
    $DOCKER_COMPOSE_DOWN_VOLUMES
else
    echo "RESET_DOCKER_VOLUMES=$RESET_DOCKER_VOLUMES -> Removing containers only, keeping volumes"
    $DOCKER_COMPOSE_DOWN
fi

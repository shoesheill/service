# Path to .env file relative to scripts/
ENV_FILE="../.env"

# Get full path of this script
SCRIPT_PATH=$(realpath "$0")

# Folder where this script resides (/asec/service/scripts)
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

# ROOT_DIR = two levels up (/asec)
ROOT_DIR=$(dirname "$(dirname "$SCRIPT_DIR")")

# PROJECT_PATH = one level up (/asec/service)
PROJECT_PATH=$(dirname "$SCRIPT_DIR")

# Get WSL IP address dynamically
WSL_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Update ROOT_DIR in .env
if grep -q "^ROOT_DIR=" "$ENV_FILE"; then
    sed -i "s|^ROOT_DIR=.*|ROOT_DIR=\"$ROOT_DIR\"|" "$ENV_FILE"
else
    echo "ROOT_DIR=\"$ROOT_DIR\"" >> "$ENV_FILE"
fi

# Update PROJECT_PATH in .env
if grep -q "^PROJECT_PATH=" "$ENV_FILE"; then
    sed -i "s|^PROJECT_PATH=.*|PROJECT_PATH=\"$PROJECT_PATH\"|" "$ENV_FILE"
else
    echo "PROJECT_PATH=\"$PROJECT_PATH\"" >> "$ENV_FILE"
fi

# Update WSL_IP in .env
if grep -q "^WSL_IP=" "$ENV_FILE"; then
    sed -i "s|^WSL_IP=.*|WSL_IP=$WSL_IP|" "$ENV_FILE"
else
    echo "WSL_IP=$WSL_IP" >> "$ENV_FILE"
fi

echo "Updated ROOT_DIR=$ROOT_DIR, PROJECT_PATH=$PROJECT_PATH, WSL_IP=$WSL_IP in $ENV_FILE"

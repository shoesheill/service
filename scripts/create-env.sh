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

echo "Updated ROOT_DIR=$ROOT_DIR and PROJECT_PATH=$PROJECT_PATH in $ENV_FILE"

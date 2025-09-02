#!/bin/bash
# ============================================
# create-env.sh with auto-permission handling
# ============================================

ENV_FILE="../.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
ROOT_DIR=$(dirname "$(dirname "$SCRIPT_DIR")")
PROJECT_PATH=$(dirname "$SCRIPT_DIR")
WSL_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Ensure the .env file exists
if [ ! -w "$ENV_FILE" ]; then
    echo ".env not writable, attempting with sudo..."
    sudo touch "$ENV_FILE" || { echo "Cannot create .env even with sudo"; exit 1; }
fi

# Function to update or add a variable
update_env_var() {
    VAR_NAME=$1
    VAR_VALUE=$2
    if grep -q "^$VAR_NAME=" "$ENV_FILE"; then
        sudo sed -i "s|^$VAR_NAME=.*|$VAR_NAME=\"$VAR_VALUE\"|" "$ENV_FILE"
    else
        echo "$VAR_NAME=\"$VAR_VALUE\"" | sudo tee -a "$ENV_FILE" >/dev/null
    fi
}

update_env_var ROOT_DIR "$ROOT_DIR"
update_env_var PROJECT_PATH "$PROJECT_PATH"
update_env_var WSL_IP "$WSL_IP"

echo "Updated ROOT_DIR=$ROOT_DIR, PROJECT_PATH=$PROJECT_PATH, WSL_IP=$WSL_IP in $ENV_FILE"

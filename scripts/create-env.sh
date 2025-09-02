#!/bin/bash
# ============================================
# create-env.sh with auto-permission handling
# ============================================

ENV_FILE="../.env"

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



# --- Prepare Postgres Directories ---
echo "Setting up Postgres data and backup directories..."

DATA_DIR="$ROOT_DIR/postgres/data"
BACKUP_DIR="$ROOT_DIR/postgres/backups"
WAL_DIR="$ROOT_DIR/postgres/wal_archive"

# Remove old data directory only if it's empty or first setup
if [ ! -d "$DATA_DIR" ]; then
    mkdir -p "$DATA_DIR"
    echo "Created data directory: $DATA_DIR"
fi

mkdir -p "$BACKUP_DIR" "$WAL_DIR"

# Set correct ownership for Postgres container (UID/GID 999)
sudo mkdir -p "$DATA_DIR" "$BACKUP_DIR" "$WAL_DIR"
sudo chown -R 999:999 "$DATA_DIR" "$WAL_DIR"
sudo chmod 700 "$DATA_DIR"
sudo chown -R "$(whoami)":"$(whoami)" "$BACKUP_DIR"
sudo chmod 700 "$BACKUP_DIR"


echo "Postgres directories ready."
ENV_FILE="../.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi
# --- Prepare Postgres Directories ---
echo "Setting up Postgres data and backup directories..."


DATA_DIR="$DATA_PATH"
BACKUP_DIR="${CUSTOM_BACKUP_DIR:-$BACKUP_PATH}"
WAL_DIR="$WAL_ARCHIVE_PATH"
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
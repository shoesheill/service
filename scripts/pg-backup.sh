#!/bin/bash
# ============================================
# Postgres Backup Script with Cron Setup (uses .env)
# ============================================

# -------- Load Environment --------
set -a
source "$(dirname "$0")/../.env" 2>/dev/null || {
    echo "❌ Cannot load .env file. Exiting."
    exit 1
}
set +a

# -------- Configuration (from .env) --------
CONTAINER_NAME="$POSTGRES_CONTAINER_NAME"
DB_NAME="$POSTGRES_DB"
DB_USER="$POSTGRES_USER"
DB_PASS="$POSTGRES_PASSWORD"
BACKUP_DIR="${CUSTOM_BACKUP_DIR:-$BACKUP_PATH}"
MAX_BACKUPS=7
SCRIPT_PATH="$(realpath "$0")"

# -------- Check required vars --------
if [ -z "$CONTAINER_NAME" ] || [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$BACKUP_DIR" ]; then
    echo "❌ Missing required env vars. Check your .env file."
    exit 1
fi

# -------- Create backup folder if missing --------
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR" || { echo "❌ Cannot create $BACKUP_DIR, exiting."; exit 1; }
    chmod 700 "$BACKUP_DIR"
    echo "📂 Created backup folder: $BACKUP_DIR"
fi

# -------- Perform backup --------
DATE=$(date +%F_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_$DATE.sql"

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    echo "❌ Container $CONTAINER_NAME is not running. Start it first."
    exit 1
fi

# Run pg_dump with password via PGPASSWORD env
docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER_NAME" \
    pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Backup successful: $BACKUP_FILE"
else
    echo "❌ Backup failed!"
    rm -f "$BACKUP_FILE"
    exit 1
fi

# -------- Clean old backups --------
cd "$BACKUP_DIR" || exit 1
ls -tp | grep -v '/$' | tail -n +$((MAX_BACKUPS+1)) | xargs -r rm --
echo "🧹 Old backups cleaned (kept last $MAX_BACKUPS)."

# -------- Setup Cron Jobs --------
# Remove existing cron jobs for this script
crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" | crontab -

# Add new cron jobs
(crontab -l 2>/dev/null; echo "0 * * * * $SCRIPT_PATH >> $BACKUP_DIR/pg_backup.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "0 */4 * * * $SCRIPT_PATH >> $BACKUP_DIR/pg_backup.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "0 2 * * * $SCRIPT_PATH >> $BACKUP_DIR/pg_backup.log 2>&1") | crontab -

echo "⏰ Cron jobs updated. Current crontab:"
crontab -l

#!/bin/bash
# 🐾 sync_to_vault.sh – Sincroniza Anuset89-Vault al vault Cryptomator montado

SRC="$HOME/Anuset89-Vault/"
DST="/home/saze/.local/share/Cryptomator/mnt/Anuset89-Vault-1/"
LOGDIR="$HOME/sync_logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOGFILE="$LOGDIR/sync_$TIMESTAMP.log"

mkdir -p "$LOGDIR"

# ⚠️ Verificar montaje real del destino
if ! findmnt -rno TARGET "$DST" &>/dev/null; then
  echo "❌ Error: El destino $DST no parece estar montado."
  echo "⛔ Abortando sincronización."
  exit 1
fi

echo "🔁 Sincronizando desde $SRC a $DST..."
rsync -a --info=progress2 --no-perms --no-owner --no-group \
  --exclude='.git' \
  --exclude='*.c9r' \
  --exclude='Anuset89/d/' \
  --exclude='__pycache__/' \
  --exclude='node_modules/' \
  --exclude='*.log' \
  "$SRC" "$DST" | tee "$LOGFILE"

echo "✅ Copia completada. Log en $LOGFILE"

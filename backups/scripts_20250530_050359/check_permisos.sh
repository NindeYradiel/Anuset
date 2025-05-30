#!/bin/bash
set -euo pipefail

echo "🔍 Escaneando permisos en ~/Anuset..."

BASE="$HOME/Anuset"
CURRENT_USER=$(whoami)

# Colores
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

echo -e "\n📁 Directorios con dueño distinto a ${YELLOW}$CURRENT_USER${NC}:"
find "$BASE" -type d ! -user "$CURRENT_USER" -exec ls -ld {} \; 2>/dev/null | grep -vE '^$' || echo -e "${GREEN}✅ Ninguno${NC}"

echo -e "\n📄 Archivos no escribibles por ${YELLOW}$CURRENT_USER${NC}:"
find "$BASE" -type f ! -writable -user "$CURRENT_USER" -exec ls -l {} \; 2>/dev/null | grep -vE '^$' || echo -e "${GREEN}✅ Todos los archivos son escribibles${NC}"

echo -e "\n🔐 Archivos o carpetas con dueño ${RED}root${NC}:"
find "$BASE" \( -user root -o -group root \) -exec ls -ld {} \; 2>/dev/null | grep -vE '^$' || echo -e "${GREEN}✅ No se detectaron objetos root${NC}"

echo -e "\n✅ Escaneo completo.\n"

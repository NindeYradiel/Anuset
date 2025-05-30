#!/bin/bash
# diag_anu89.sh - Diagnóstico extendido para Anuset89-Vault
# Kali - 2025-05-28

NOW=$(date '+%Y-%m-%d %H:%M:%S')
LOGFILE="diag_anu89_$(date +%Y%m%d_%H%M%S).md"

log() {
  echo -e "$1" | tee -a "$LOGFILE"
}

echo "📋 Diagnóstico de Anuset89 - $NOW" > "$LOGFILE"
log ""


### 1. Archivos importantes
log "## 🔑 Archivos importantes:"
for f in docker-compose.yml main_controller.py backend/Dockerfile frontend/Dockerfile frontend/nginx.conf; do
  if [[ -f "$f" ]]; then
    SIZE=$(du -h "$f" | cut -f1)
    MODIFIED=$(stat -c %y "$f")
    log "- 📂 **$f** | Tamaño: $SIZE | Modificado: $MODIFIED"
  else
    log "- ⚠️ **$f** no encontrado."
  fi
done
log ""


### 2. Servicios Activos
log "## 🚀 Servicios activos (docker ps):"
docker ps --format '  | {{.Names}} | {{.Image}} | {{.Status}} | {{.Ports}} |' | tee -a "$LOGFILE"
log ""


### 3. Logs Recientes
log "## 📄 Logs recientes de cada contenedor (últimas 10 líneas):"
CONTAINERS=$(docker ps -a --format '{{.Names}}')
for c in $CONTAINERS; do
  log ""
  log "#### 🔹 Logs: \`$c\`"
  docker logs --tail 10 "$c" 2>&1 | sed 's/^/> /' | tee -a "$LOGFILE"
done
log ""


### 4. Archivos Grandes (>100MB)
log "## 🧱 Archivos grandes (>100MB):"
find . -type f -size +100M -exec du -h {} + | sort -hr | head -n 20 | sed 's/^/> /' | tee -a "$LOGFILE"
log ""


### 5. Espacio usado en ./data/
if [[ -d "./data" ]]; then
  log "## 💾 Espacio utilizado en ./data/:"
  du -h --max-depth=1 ./data 2>/dev/null | sort -hr | sed 's/^/> /' | tee -a "$LOGFILE"
else
  log "## ℹ️  No se encontró la carpeta ./data/"
fi
log ""


### 6. Revisión de Dockerfile y WORKDIR
log "## 🔧 Revisión de Dockerfile por servicio:"
for d in */Dockerfile; do
  SERVICE=$(dirname "$d")
  log ""
  log "#### 🏷️ Dockerfile: \`$d\`"

  # 6.1. WORKDIR
  if grep -q '^WORKDIR ' "$d"; then
    WD=$(grep '^WORKDIR ' "$d" | cut -d' ' -f2)
    log "> ✅ WORKDIR definido en \`$WD\`"
  else
    log "> ❌ Falta **WORKDIR** en $SERVICE"
  fi

  # 6.2. CMD o ENTRYPOINT
  if grep -Eq '^(CMD|ENTRYPOINT) ' "$d"; then
    log "> ✅ CMD/ENTRYPOINT presente."
  else
    log "> ❌ Falta **CMD** o **ENTRYPOINT** en $SERVICE"
  fi

  # 6.3. EXPOSE
  if grep -q '^EXPOSE ' "$d"; then
    EXPO=$(grep '^EXPOSE ' "$d" | cut -d' ' -f2)
    log "> ✅ EXPOSE $EXPO"
  else
    log "> ⚠️ Falta **EXPOSE** en $SERVICE"
  fi

  # 6.4. requirements.txt (solo Python services)
  if [[ -f "$SERVICE/requirements.txt" ]]; then
    log "> ✅ requirements.txt encontrado en $SERVICE"
  else
    log "> ⚠️ Falta **requirements.txt** en $SERVICE (si usa Python)"
  fi
done
log ""


### 7. Revisión de entrypoint.sh
log "## 🔄 Revisión de entrypoint.sh por servicio:"
for e in */entrypoint.sh; do
  SERVICE=$(dirname "$e")
  log ""
  log "#### 🔹 entrypoint: \`$e\`"

  # 7.1. Permisos ejecutables
  if [[ -x "$e" ]]; then
    log "> ✅ entrypoint.sh es ejecutable"
  else
    log "> ❌ entrypoint.sh NO es ejecutable"
  fi

  # 7.2. Invocación correcta de Python/Uvicorn
  if grep -qE 'exec (python|uvicorn)' "$e"; then
    log "> ✅ entrypoint.sh invoca correctamente 'exec python' o 'exec uvicorn'"
  else
    log "> ❌ entrypoint.sh NO invoca 'exec python' ni 'exec uvicorn'"
  fi
done
log ""


### 8. Revisión de frontend/nginx.conf y permisos
log "## 🌐 Revisión de \`frontend/nginx.conf\` y permisos:"
if [[ -f "frontend/nginx.conf" ]]; then
  PERM=$(stat -c "%a" frontend/nginx.conf)
  if [[ "$PERM" == "644" ]]; then
    log "> ✅ Permisos correctos (644)"
  else
    log "> ⚠️ Permisos actuales: $PERM (deberían ser 644)"
  fi

  # 8.1. Que use proxy hacia openwebui y sirva /front/
  if grep -q 'proxy_pass.*openwebui:8080' frontend/nginx.conf; then
    log "> ✅ proxy_pass apunta a openwebui:8080"
  else
    log "> ❌ proxy_pass NO apunta a openwebui:8080"
  fi

  if grep -q 'location /front/' frontend/nginx.conf; then
    log "> ✅ /front/ definido correctamente"
  else
    log "> ❌ Falta 'location /front/' en nginx.conf"
  fi
else
  log "⚠️ frontend/nginx.conf no encontrado"
fi
log ""


### 9. Contenedores en reinicio o con errores específicos
log "## 🔴 Contenedores en estado de reinicio o con errores críticos:"
for c in $(docker ps -a --format '{{.Names}}'); do
  STATE=$(docker inspect -f '{{.State.Status}}' "$c")
  if [[ "$STATE" == "restarting" ]]; then
    log "> ❌ $c está **reiniciando**"
  elif [[ "$STATE" == "exited" ]]; then
    CODE=$(docker inspect -f '{{.State.ExitCode}}' "$c")
    log "> ⚠️ $c salió con código $CODE"
  fi
done
log ""


### 10. Pistas de errores comunes en logs
log "## ⚠️ Pistas de errores comunes ([Error], [Exception], [Traceback]):"
for c in $(docker ps -a --format '{{.Names}}'); do
  ERR=$(docker logs --tail 50 "$c" 2>&1 | grep -Ei 'error|exception|traceback|failed')
  if [[ -n "$ERR" ]]; then
    log ""
    log "#### ❗ $c:"
    echo "$ERR" | sed 's/^/  > /' | tee -a "$LOGFILE"
  fi
done
log ""


log "🚀 Diagnóstico completo. El reporte se guardó en **$LOGFILE**"
log ""


# Mostrar en pantalla (no solo en archivo)
echo "📂 Abriendo $LOGFILE en pantalla..."
cat "$LOGFILE"

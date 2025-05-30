#!/bin/bash
# 🔍 Anuset89 Diagnóstico Extendido (con Markdown)
# Genera un informe completo en markdown: estado, archivos clave, espacio, servicios

REPORTE="reporte_anuset89_$(date +%Y-%m-%d_%H%M).md"
echo "# 🧠 Diagnóstico del Sistema Anuset89 - $(date)" > "$REPORTE"
echo >> "$REPORTE"

### 1. Información básica
echo "## 📅 Información General" >> "$REPORTE"
echo "- 📁 Proyecto: $(basename "$PWD")" >> "$REPORTE"
echo "- 📂 Ruta: \`$PWD\`" >> "$REPORTE"
echo "- 🕒 Fecha actual: \`$(date)\`" >> "$REPORTE"
echo >> "$REPORTE"

### 2. Servicios activos
echo "## 🧩 Servicios activos (docker ps)" >> "$REPORTE"
docker ps --format '| {{.Names}} | {{.Image}} | {{.Status}} | {{.Ports}} |' | (
  echo '| Nombre | Imagen | Estado | Puertos |'
  echo '|--------|--------|--------|---------|'
  cat
) >> "$REPORTE"
echo >> "$REPORTE"

### 3. Archivos principales y fechas
print_archivo_info() {
  local path="$1"
  if [ -f "$path" ]; then
    echo "- \`$path\`: $(stat -c '%y (%s bytes)' "$path")"
  else
    echo "- ⚠️ No encontrado: \`$path\`"
  fi
}
echo "## 📄 Archivos importantes" >> "$REPORTE"
echo "### Frontend" >> "$REPORTE"
print_archivo_info frontend/Dockerfile >> "$REPORTE"
print_archivo_info frontend/nginx.conf >> "$REPORTE"
print_archivo_info frontend/vite.config.js >> "$REPORTE"
echo >> "$REPORTE"
echo "### Backend" >> "$REPORTE"
print_archivo_info backend/Dockerfile >> "$REPORTE"
print_archivo_info backend/requirements.txt >> "$REPORTE"
print_archivo_info backend/main.py >> "$REPORTE"
echo >> "$REPORTE"
echo "### Compose y control" >> "$REPORTE"
print_archivo_info docker-compose.yml >> "$REPORTE"
print_archivo_info main_controller.py >> "$REPORTE"
echo >> "$REPORTE"

### 4. Archivos grandes (mayores a 100MB)
echo "## 🧱 Archivos grandes (>100MB)" >> "$REPORTE"
find . -type f -size +100M 2>/dev/null | while read archivo; do
  peso=$(du -sh "$archivo" | cut -f1)
  echo "- $archivo ($peso)" >> "$REPORTE"
done
[[ $(tail -n 1 "$REPORTE") == "## 🧱 Archivos grandes (>100MB)" ]] && echo "- Nada encontrado." >> "$REPORTE"
echo >> "$REPORTE"

### 5. Logs recientes
echo "## 🪵 Logs recientes de servicios" >> "$REPORTE"
for svc in $(docker ps --format '{{.Names}}'); do
  echo "### 📦 \`$svc\`" >> "$REPORTE"
  docker logs --tail=10 "$svc" 2>&1 | sed 's/^/    /' >> "$REPORTE"
  echo >> "$REPORTE"
done

### 6. Uso de espacio
if [ -d "./data" ]; then
  echo "## 💾 Espacio usado en ./data/" >> "$REPORTE"
  du -sh ./data/* 2>/dev/null | sort -hr | sed 's/^/- /' >> "$REPORTE"\  
  echo >> "$REPORTE"
fi

echo "## ✅ Fin del reporte. Guardado como: $REPORTE"
echo "✅ Revisa: $REPORTE"

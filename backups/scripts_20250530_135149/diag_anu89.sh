#!/usr/bin/env bash
set -euo pipefail

# 🧭 Establecer ruta raíz del proyecto desde cualquier lugar
PROJECT_ROOT="$(dirname "$(dirname "$(realpath "$0")")")"
cd "$PROJECT_ROOT"

# 📅 Timestamp
NOW="$(date +%Y%m%d_%H%M%S)"
REPORT="diag_anu89_${NOW}.md"

# 📂 Función para mostrar existencia de archivo
check_file() {
  local label="$1"
  local path="$2"
  if [[ -f "$path" ]]; then
    echo "- 📂 **$label** | Tamaño: $(du -h "$path" | cut -f1) | Modificado: $(stat -c %y "$path")"
  else
    echo "- ⚠️ **$label** no encontrado."
  fi
}

# 🚀 Encabezado
{
  echo "## 🔑 Archivos importantes:"
  check_file "docker-compose.yml" "docker-compose.yml"
  check_file "main_controller.py" "main_controller.py"
  check_file "backend/Dockerfile" "backend/Dockerfile"
  check_file "frontend/Dockerfile" "frontend/Dockerfile"
  check_file "frontend/nginx.conf" "frontend/nginx.conf"
  echo

  echo "## 🚀 Servicios activos (docker ps):"
  docker ps --format '| {{.Names}} | {{.Names}} | {{.Status}} | {{.Ports}} |'
  echo

  echo "## 📄 Logs recientes de cada contenedor (últimas 10 líneas):"
  for c in $(docker ps -aq); do
    name=$(docker inspect --format='{{.Name}}' "$c" | sed 's/\///')
    echo -e "\n#### 🔹 Logs: \`$name\`"
    docker logs --tail 10 "$c" 2>&1 || echo "(sin logs)"
  done

  echo -e "\n## 🧱 Archivos grandes (>100MB):"
  find ./data -type f -size +100M -exec du -h {} + | sort -hr | head -n 20

  echo -e "\n## 💾 Espacio utilizado en ./data/:"
  du -h --max-depth=1 ./data | sort -hr

  echo -e "\n## 🔧 Revisión de Dockerfile por servicio:"
  for df in $(find . -name Dockerfile); do
    echo -e "\n#### 🏷️ Dockerfile: \`$df\`"
    grep -q WORKDIR "$df" && echo "✅ WORKDIR definido" || echo "❌ Falta WORKDIR"
    grep -q -E 'CMD|ENTRYPOINT' "$df" && echo "✅ CMD/ENTRYPOINT presente." || echo "❌ Falta CMD o ENTRYPOINT"
    grep -q EXPOSE "$df" && echo "✅ EXPOSE presente" || echo "⚠️ Falta EXPOSE"
    req="$(dirname "$df")/requirements.txt"
    [[ -f "$req" ]] && echo "✅ requirements.txt encontrado en $(basename $(dirname "$df"))" || echo "⚠️ Falta requirements.txt"
  done

  echo -e "\n## 🔄 Revisión de entrypoint.sh por servicio:"
  for ep in $(find . -name entrypoint.sh); do
    echo -e "\n#### 🔹 entrypoint: \`$ep\`"
    [[ -x "$ep" ]] && echo "✅ entrypoint.sh es ejecutable" || echo "❌ entrypoint.sh NO es ejecutable"
    grep -q -E 'exec (python|uvicorn)' "$ep" && echo "✅ entrypoint.sh invoca correctamente" || echo "❌ entrypoint.sh NO invoca 'exec python' ni 'exec uvicorn'"
  done

  echo -e "\n## 🌐 Revisión de \`frontend/nginx.conf\` y permisos:"
  if [[ -f frontend/nginx.conf ]]; then
    perms=$(stat -c %a frontend/nginx.conf)
    echo "✅ Permisos: $perms"
    grep -q 'proxy_pass http://openwebui:8080' frontend/nginx.conf && echo "✅ proxy_pass apunta a openwebui:8080" || echo "❌ proxy_pass incorrecto"
    grep -q 'location /front/' frontend/nginx.conf && echo "✅ /front/ definido correctamente" || echo "❌ Falta 'location /front/'"
  else
    echo "⚠️ frontend/nginx.conf no encontrado"
  fi

  echo -e "\n## 🔴 Contenedores en estado de reinicio o con errores críticos:"
  docker ps -a --format '{{.Names}} {{.Status}}' | grep -E 'Exited|Restarting' || echo "✅ Todos los contenedores están estables."

  echo -e "\n## ⚠️ Pistas de errores comunes ([Error], [Exception], [Traceback]):"
  for c in $(docker ps -aq); do
    name=$(docker inspect --format='{{.Name}}' "$c" | sed 's/\///')
    echo -e "\n#### ❗ $name:"
    docker logs "$c" 2>&1 | grep -E 'Error|Exception|Traceback' | tail -n 5 || echo "(sin errores detectados)"
  done

  echo -e "\n🚀 Diagnóstico completo. El reporte se guardó en **$REPORT**"
} | tee "$REPORT"

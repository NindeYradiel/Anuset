#!/bin/bash

OUTPUT="logs-anuset89.txt"
> "$OUTPUT"  # Limpia el archivo si existe

echo "📦 Exportando logs de todos los contenedores en ejecución..." | tee -a "$OUTPUT"

for container in $(docker ps -a --format '{{.Names}}'); do
  echo -e "\n\n===================== 🔹 LOGS: $container 🔹 =====================" | tee -a "$OUTPUT"
  docker logs "$container" 2>&1 | tee -a "$OUTPUT"
done

echo -e "\n✅ Logs exportados en: $OUTPUT"

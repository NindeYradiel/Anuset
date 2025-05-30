#!/bin/bash

echo "🧹 Iniciando limpieza de archivos corruptos o vacíos..."

# Archivos a eliminar
declare -a FILES_TO_DELETE=(
    "./="
    "./[frontend"
    "./[frontend]"
)

for file in "${FILES_TO_DELETE[@]}"; do
    if [ -f "$file" ]; then
        echo "🗑️ Eliminando $file"
        rm -v "$file"
    else
        echo "✅ $file ya no existe"
    fi
done

# Anuu_visual: si es archivo vacío, lo transformamos en carpeta
if [ -f "./anuu_visual" ]; then
    echo "🔄 Reemplazando archivo vacío 'anuu_visual' por carpeta..."
    rm -v "./anuu_visual"
    mkdir -v "./anuu_visual"
else
    echo "✅ 'anuu_visual' ya es una carpeta o no existe"
fi

echo "✨ Limpieza completada."

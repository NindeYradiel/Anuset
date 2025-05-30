#!/bin/bash
set -euo pipefail

OUTPUT="estructura_$(date +%Y%m%d).txt"
EXCLUDE="__pycache__|.git|.DS_Store|node_modules"

echo "📸 Generando snapshot estructural de Anuset..."
tree -a -L 3 -I "$EXCLUDE" > "$OUTPUT"

echo "✅ Snapshot guardado como $OUTPUT"

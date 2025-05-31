#!/bin/bash
# parchea_dockerfiles.sh
# Aplica un parche estándar a todos los Dockerfiles en services/*/
# Ordena instrucciones, crea usuario appuser, usa COPY --chown y --chmod, etc.

set -euo pipefail

BASE_DIR="./services"

for df in $(find "$BASE_DIR" -type f -name Dockerfile); do
  echo "Procesando $df..."

  # Leer contenido original para análisis
  original=$(cat "$df")

  # Detectar si hay RUN adduser o similar
  has_adduser=$(grep -E "adduser|useradd" "$df" || true)
  # Detectar si hay USER ya definido
  has_user=$(grep "^USER " "$df" || true)
  # Detectar WORKDIR
  has_workdir=$(grep "^WORKDIR " "$df" || true)

  # Vamos a reconstruir el Dockerfile ordenado
  # Suponemos que base image está al inicio, mantenerla
  base_image=$(grep "^FROM " "$df" | head -1)

  # Crear usuario appuser si no existe
  # Añadimos instrucciones RUN para crear appuser (sin home, sin passwd)
  # Usamos --no-create-home para simplicidad y evitar peso extra
  adduser_cmd="RUN adduser --disabled-password --gecos '' appuser || true"

  # Define WORKDIR temprano
  workdir_line="WORKDIR /app"

  # Buscar requirements.txt en COPY
  # Luego pip install
  # Luego copiar todo el código con --chown
  # Finalmente USER appuser

  # Extraemos líneas COPY requirements.txt
  copy_reqs=$(grep -E "COPY.*requirements.txt" "$df" || true)
  # Extraemos línea pip install
  pip_install=$(grep -E "pip install" "$df" || true)

  # Otras líneas COPY que no sean requirements.txt
  copy_other=$(grep "^COPY " "$df" | grep -v "requirements.txt" || true)

  # Quitar chmod o chown manuales en RUN que sean innecesarios
  # Eliminamos RUN chmod o chown en general (simplificando)
  cleaned=$(echo "$original" | grep -vE "RUN (chmod|chown) " )

  # Ahora armamos el nuevo Dockerfile paso a paso:

  {
    echo "$base_image"
    echo ""
    echo "# Crear usuario appuser para seguridad"
    echo "$adduser_cmd"
    echo ""
    echo "# Definir directorio de trabajo"
    echo "$workdir_line"
    echo ""
    if [[ -n "$copy_reqs" ]]; then
      # Reescribimos COPY requirements.txt con permiso 644
      echo "# Copiar requirements.txt con permiso 644"
      echo "COPY --chmod=644 requirements.txt ."
    fi
    if [[ -n "$pip_install" ]]; then
      echo "# Instalar dependencias python"
      echo "$pip_install"
    fi
    echo ""
    # Copiar resto del código con propietario appuser
    echo "# Copiar todo el código con propiedad appuser"
    echo "COPY --chown=appuser:appuser . ."
    echo ""
    # Cambiar a usuario appuser
    echo "# Usar usuario appuser para ejecutar la app"
    echo "USER appuser"
    echo ""
    # Añadir resto del contenido limpio (sin las líneas ya procesadas)
    # Eliminamos las líneas de FROM, adduser, WORKDIR, COPY requirements.txt, pip install, COPY otro y USER para evitar duplicados
    tail_cleaned=$(echo "$cleaned" | grep -v "^FROM " | grep -v "adduser" | grep -v "^WORKDIR " | grep -v "COPY.*requirements.txt" | grep -v "pip install" | grep -v "^COPY " | grep -v "^USER ")
    if [[ -n "$tail_cleaned" ]]; then
      echo "# Otras instrucciones originales"
      echo "$tail_cleaned"
    fi

  } > "${df}.patched"

  # Sobrescribimos el Dockerfile original
  mv "${df}.patched" "$df"
  echo "  -> $df parchado."
done

echo "Parche aplicado a todos los Dockerfiles en $BASE_DIR"


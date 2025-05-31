FROM python:3.10-slim as base

# Crear usuario appuser para seguridad
RUN adduser --disabled-password --gecos '' appuser || true

# Definir directorio de trabajo
WORKDIR /app

# Copiar requirements.txt con permiso 644
COPY --chmod=644 requirements.txt .
# Instalar dependencias python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar todo el código con propiedad appuser
COPY --chown=appuser:appuser . .

# Usar usuario appuser para ejecutar la app

# Otras instrucciones originales
CMD ["./entrypoint.sh"]
USER appuser
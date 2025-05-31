FROM python:3.11-slim

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
ENV PYTHONDONTWRITEBYTECODE=1     PYTHONUNBUFFERED=1     PATH="/app/bin:$PATH"

EXPOSE 8000
CMD ["python", "app.py"]
USER appuser
FROM alpine:latest AS downloader
RUN apk add --no-cache curl git
WORKDIR /models
RUN echo "Sin descarga de modelo para frontend"

FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/bin:$PATH"

RUN adduser --disabled-password --gecos "" appuser
USER appuser

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

EXPOSE 8000
CMD ["python", "app.py"]

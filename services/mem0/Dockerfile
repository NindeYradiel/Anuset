FROM alpine:3.19

RUN apk add --no-cache python3 py3-pip curl git

RUN adduser --disabled-password --gecos '' appuser || true

WORKDIR /app

COPY --chmod=644 requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=appuser:appuser . .

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/bin:$PATH"

EXPOSE 8000

USER appuser

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

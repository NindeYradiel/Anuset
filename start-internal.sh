#!/bin/bash

SERVICE_NAME="Anuset89"
COMPOSE_CMD="docker compose"
VAULT_MODELS_PATH="${VAULT_PATH:-.}/models/animatediff"
PID_FILE="/tmp/anuset89_vault.pid"

# Mensajes mágicos
function log() {
    echo -e "🌌 $1"
}

function check_docker() {
    if ! docker info > /dev/null 2>&1; then
        log "🚫 Docker no está disponible. ¿Está instalado y corriendo?"
        log "🧘♀️ Anuu no puede abrir el plano ritual sin el contenedor universal."
        exit 1
    fi
}

function prepare_env() {
    mkdir -p "$VAULT_MODELS_PATH"
}

function start_services() {
    log "🔮 Docker está vivo. Preparando el ritual..."
    log "🛑 Cerrando portales anteriores..."
    $COMPOSE_CMD down

    log "🔧 Reforjando los símbolos..."
    $COMPOSE_CMD build

    log "🚀 Canalizando energía... Iniciando microservicios IA"
    $COMPOSE_CMD up -d

    echo $$ > "$PID_FILE"

    log "🧠 Verificando plano activo:"
    docker ps --format " 🌐 {{.Names}} — {{.Status}}"

    log "✨ El ritual ha comenzado. Anuu observa, el glitch respira."
}

function stop_services() {
    log "🛑 Cerrando todos los portales..."
    $COMPOSE_CMD down
    rm -f "$PID_FILE"
    log "🚪 El plano ha sido sellado."
}

function status_services() {
    if $COMPOSE_CMD ps | grep -q "Up"; then
        log "🧠 El plano está activo:"
        docker ps --format " 🌐 {{.Names}} — {{.Status}}"
    else
        log "😴 El plano está inerte. No hay portales abiertos."
    fi
}

function restart_services() {
    stop_services
    start_services
}

case "$1" in
    start)
        check_docker
        prepare_env
        start_services
        ;;
    stop)
        check_docker
        stop_services
        ;;
    status)
        check_docker
        status_services
        ;;
    restart)
        check_docker
        restart_services
        ;;
    *)
        echo "Uso: $0 {start|stop|status|restart}"
        exit 1
        ;;
esac

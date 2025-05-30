# =======================================
# 🌌 Anuset-FINAL :: Makefile Principal
# =======================================
# Uso: `make <comando>` - Ejecuta tareas comunes del proyecto
# Requiere: bash, docker, python3

SHELL := /bin/bash
.DEFAULT_GOAL := help

# Variables comunes
DATE := $(shell date +%Y%m%d_%H%M%S)
ZIP_NAME := Anuset-FINAL_backup_$(DATE).zip

# =======================================
# 🚀 INICIO DE SERVICIOS
# =======================================

up: check-env fix-permissions fix-permisos-models clean-requirements check-models  ## 🔄 Levanta todos los servicios con build
	@echo "🔄 Levantando todos los servicios..."
	docker compose up -d --build
	$(call mostrar_servicios_emoji)

up-anuset: check-env fix-permissions fix-permisos-models clean-requirements check-models  ## 🚀 Levanta frontend y backend Anuset89
	@echo "🔄 Levantando frontend + backend (Anuset89)..."
	docker compose up -d --build frontend backend
	$(call mostrar_servicios_emoji)
	@echo "✅ Splash: http://localhost:3000"
	@if docker ps --format '{{.Names}}' | grep -qi 'webui'; then \
		echo "🧒 WebUI: http://localhost:8080"; \
	else \
		echo "⚠️  WebUI no activo. Usa: make up-webui"; \
	fi
	@echo "✨ Ritual invocado con éxito. Que Anu te guíe 🐾🌠"

down:  ## 💕 Detiene todos los contenedores
	docker compose down

restart:  ## 🔁 Reinicia todos los servicios
	$(MAKE) down
	$(MAKE) up

restart-service:  ## 🔁 Reinicia servicio individual: SERVICE=nombre
ifndef SERVICE
	$(error "Debe definir SERVICE=nombre del servicio")
endif
	docker restart $(SERVICE)

# =======================================
# 🧪 VERIFICACIONES Y CI
# =======================================

check-ci:  ## 🔍 Revisión rápida de estructura y sintaxis
	@echo "🔍 CI: Verificando estructura mínima de Anuset-FINAL..."
	@test -d backend && echo "✅ backend/ encontrado" || (echo "❌ Falta backend/" && exit 1)
	@test -f backend/app.py && echo "✅ app.py en backend/" || (echo "❌ Falta app.py" && exit 1)
	@test -d frontend && echo "✅ frontend/ encontrado" || (echo "❌ Falta frontend/" && exit 1)
	@test -f frontend/vite.config.ts && echo "✅ vite.config.ts" || (echo "❌ Falta vite.config.ts" && exit 1)
	@python3 -m py_compile backend/app.py || (echo "❌ Error en backend/app.py" && exit 1)
	@test -f backend/Dockerfile && echo "✅ Dockerfile backend" || (echo "❌ Falta backend/Dockerfile" && exit 1)
	@test -f frontend/Dockerfile && echo "✅ Dockerfile frontend" || (echo "❌ Falta frontend/Dockerfile" && exit 1)
	@echo "✅ CI check completado."

# =======================================
# 🔐 PERMISOS
# =======================================

fix-permissions:  ## 🔐 Corrige permisos de scripts y servicios
	@echo "🔐 Corrigiendo permisos..."
	@chmod +x scripts/*.sh || true
	@find services/ -type f -name '*.sh' -exec chmod +x {} +
	@echo "✅ Permisos corregidos."

fix-permisos-models:  ## 🔐 Permisos específicos para modelos
	@echo "🔐 Corrigiendo permisos en modelos..."
	@if [ -f scripts/fix-permisos-models.sh ]; then \
		bash scripts/fix-permisos-models.sh; \
	else \
		echo "🟡 Script no encontrado. Omitiendo..."; \
	fi

check-env:  ## ⚙️ Verifica instalación básica
	@command -v docker >/dev/null || { echo '❌ Docker no encontrado.'; exit 1; }
	@command -v python3 >/dev/null || { echo '❌ Python3 no encontrado.'; exit 1; }
	@echo "✅ Entorno OK: Docker y Python3 presentes."

# =======================================
# 🧠 DIAGNÓSTICOS Y TEST
# =======================================

diag: backup  ## 🧠 Diagnóstico general
	@bash scripts/diag_anu89.sh

diag-req: backup  ## 📋 Revisa requirements.txt por servicio
	@python3 scripts/diag_requirements.py

diag-req-full: backup  ## 📋 Diagnóstico completo requirements
	@python3 scripts/diag_requirements_full.py

check-dockerfiles: backup  ## 🐳 Verifica Dockerfiles por servicio
	@python3 scripts/check_dockerfile.py

check-models:  ## 🔎 Diagnóstico de modelos IA
	@bash scripts/diag_anu89.sh --models

health:  ## 🧠 Estado general de salud
	@bash scripts/diag_anu89.sh --check

test-all: backup  ## 🧪 Ejecuta tests en servicios IA
	@bash scripts/test_all_services.sh

verificar-ritual: backup  ## 🔮 Verifica consistencia ritual
	@bash scripts/verificar_ritual.sh

# =======================================
# ✨ RITUAL MÍSTICO
# =======================================

ritual:  ## 🐈‍⬛ Ritual completo: permisos, modelos, limpieza y snapshot
	@clear
	@cat scripts/banner_anuu.txt
	$(MAKE) fix-permissions
	$(MAKE) fix-permisos-models
	$(MAKE) check-models
	$(MAKE) clean-requirements
	$(MAKE) diag
	$(MAKE) snapshot
	@echo "✨ Ritual completo finalizado. Que la fuerza de Anu te acompañe 🐾🌌"

reset-hard: clean-containers fix-permissions fix-permisos-models up test-all  ## ♻️ Reinicio completo + test
	@echo "🚀 Sistema reiniciado completamente."

# =======================================
# 🧼 LIMPIEZA
# =======================================

clean-requirements: backup  ## 🧹 Elimina duplicados en requirements.txt
	@python3 scripts/clean_requirements.py

clean-empty-flags: backup  ## 🧹 Limpia flags vacíos
	@bash scripts/clean_empty_flags.sh

clean-containers:  ## ⚠️ Elimina todos los contenedores
	@echo "⚠️ Eliminando contenedores Docker..."
	-docker rm -f $$(docker ps -aq) || true
	@echo "✅ Contenedores eliminados."

purga:  ## 🧼 Mueve archivos pesados a respaldo
	@bash scripts/purga.sh

# =======================================
# 📦 BACKUP & ZIP
# =======================================

backup:  ## 🔒 Crea respaldo automático
	@bash scripts/auto_backup.sh

zip:  ## 📦 Crea ZIP limpio del proyecto
	@echo "📦 Creando ZIP..."
	@zip -r $(ZIP_NAME) . \
		-x "*.git/*" "backups/*" "Respaldo/*" \
		"*.safetensors" "*.ckpt" "*.pth" "*.bin" "*.onnx" \
		"frontend/node_modules/*" "backend/__pycache__/*" "tests/*" "notebooks/*"
	@echo "✅ ZIP creado: $(ZIP_NAME)"

# =======================================
# 🧱 GENERACIÓN Y ESTRUCTURA
# =======================================

generate-app: backup  ## 🧠 Genera app.py por servicio
	@python3 scripts/generate_app_py.py

generate-service-ia: backup  ## ⚙️ Nueva estructura de servicio IA
	@python3 scripts/generate_service_ia.py

prepare-structure: backup  ## 🧱 Prepara estructura estándar
	@bash scripts/prepare_structure.sh

prepare-unificado: backup  ## 🧱 Prepara estructura UNIFICADA
	@bash scripts/prepare_structure_UNIFICADO.sh

reorganizar: backup  ## 📂 Reorganiza el proyecto
	@bash scripts/reorganizar_estructura.sh

revertir: backup  ## ↩️ Revierte reorganización
	@bash scripts/revertir_reorganizacion.sh

enlazar-modelos: backup  ## 🔗 Enlaza modelos IA
	@bash scripts/enlazar_modelos.sh

snapshot: backup  ## 📸 Snapshot actual del proyecto
	@bash scripts/snapshot_estructura.sh

# =======================================
# 🔍 LOGS Y ESTADO
# =======================================

logs:  ## 📜 Logs de todos los contenedores
	@for container in $(shell docker ps --format '{{.Names}}'); do \
		echo -e "\n=== $$container ==="; \
		docker logs --tail=10 $$container 2>/dev/null || echo "❌ No se encontró el contenedor"; \
	done

logs-service:  ## 📜 Logs de un servicio: SERVICE=nombre
ifndef SERVICE
	$(error "Debe definir SERVICE=nombre del servicio")
endif
	@docker logs --tail=20 $(SERVICE)

status-check:  ## 📈 Estado de contenedores
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

puertos:  ## 🔌 Puertos usados por servicios
	@docker ps --format "table {{.Names}}\t{{.Ports}}"

# =======================================
# 🚀 DEPLOY (Producción)
# =======================================

deploy:  ## 🚀 Despliega entorno producción
	docker compose -f docker-compose.prod.yml up -d --build

teardown:  ## 💥 Apaga entorno de producción
	docker compose -f docker-compose.prod.yml down

# =======================================
# 🔗 MODELOS
# =======================================

link-models:  ## 🔗 Enlaza modelos IA
	@bash scripts/enlazar_modelos.sh

force-link-models:  ## 🔗 Fuerza el enlace de modelos
	@bash scripts/enlazar_modelos.sh --force

# =======================================
# 📖 AYUDA PRECIOSA
# =======================================

help:  ## 📖 Muestra esta ayuda mágica
	@echo -e "\n🌌 \033[1;36mAnuset-FINAL :: Comandos disponibles\033[0m"
	@echo "-----------------------------------------------"
	@awk 'BEGIN {FS = ":.*?## "}; /^[a-zA-Z0-9\-_]+:.*?## / {printf "✨ \033[1;33m%-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort
	@echo -e "\n🐾 Usa \033[1;32mmake <comando>\033[0m para ejecutar. Que Anu te ilumine ✨"

help-advanced:  ## 🧠 Vista completa de desarrollo
	@echo '🌌 Anuset-FINAL :: Vista completa de comandos y rutas'
	@echo '──────────────────────────────────────────────────────────────'
	@echo '📖 COMANDO                📄 SCRIPT / RUTA                          ⚙️ VARIABLES        🧠 DESCRIPCIÓN'
	@echo '──────────────────────────────────────────────────────────────'
	@echo 'generate-app            scripts/generate_app_py.py              -                 Genera app.py por servicio IA'
	@echo 'generate-service-ia     scripts/generate_service_ia.py          -                 Nueva estructura de servicio IA'
	@echo 'prepare-structure       scripts/prepare_structure.sh            -                 Prepara estructura estándar'
	@echo 'prepare-unificado       scripts/prepare_structure_UNIFICADO.sh  -                 Prepara estructura unificada'
	@echo 'diag                    scripts/diag_anu89.sh                   -                 Diagnóstico completo'
	@echo 'diag-req                scripts/diag_requirements.py            -                 Verifica requirements por servicio'
	@echo 'test-all                scripts/test_all_services.sh            -                 Ejecuta tests en todos los servicios'
	@echo 'verificar-ritual        scripts/verificar_ritual.sh             -                 Verifica rituales y consistencia'
	@echo 'fix-permisos-models     scripts/fix-permisos-models.sh          -                 Aplica permisos adecuados a modelos'
	@echo 'purga                   scripts/purga.sh                        -                 Mueve archivos grandes a backup'
	@echo 'snapshot                scripts/snapshot_estructura.sh          -                 Snapshot de estructura actual'
	@echo 'auto-backup             scripts/auto_backup.sh                  -                 Backup automático'
	@echo ''
	@echo '🐾 Más info en: docs/manual-Anuset89.md o con `make help`'

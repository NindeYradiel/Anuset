# Makefile místico y estelar para Anuset89
# ✨✨✨ Con ayuda visual via gum y gatitos mágicos 🐱🌙

# Detecta si 'gum' está instalado para ayuda visual
GUM_EXISTS := $(shell command -v gum 2> /dev/null)

.PHONY: help help-advanced clean menu create-% test-% generate-service regen-all install-all salud lanzar stop update-rituals build-all logs servicios ritual musica voz memoria codellama animatediff frontend diag

NO_GUM_MSG = "⚠️ La herramienta 'gum' no está instalada. Para disfrutar de un menú visual elegante, instala gum desde https://github.com/charmbracelet/gum"

# ============================
#        AYUDA BÁSICA
# ============================

help:
ifeq ($(GUM_EXISTS),)
	@echo "$(NO_GUM_MSG)"
	@echo "🐱 Comandos básicos disponibles:"
	@echo "  🧹 make clean               — Purga contenedores y redes Docker que no se están usando"
	@echo "  🪄 make menu                — Muestra el menú místico interactivo y visual"
	@echo "  🏗️ make create-<nombre>     — Crea estructura base para un nuevo servicio IA en ./services/"
	@echo "  🚀 make test-<nombre> [PORT=xxxx] — Testea el servicio IA localmente en puerto específico"
	@echo "  ✨ make generate-service NAME=<nombre> — Genera un servicio IA completo con Dockerfile y scripts"
	@echo "  🔄 make regen-all           — Regenera todos los servicios IA desde plantillas base"
	@echo "  📦 make install-all         — Instala todas las dependencias necesarias (backend + frontend)"
	@echo "  🧿 make salud               — Ejecuta diagnóstico completo de salud del sistema y servicios"
	@echo "  ▶️ make lanzar              — Arranca todos los servicios IA activos en docker-compose"
	@echo "  ⏹️ make stop                — Detiene todos los servicios IA corriendo"
	@echo "  ⚙️ make update-rituals      — Actualiza los rituales y configuraciones base del sistema"
	@echo "  🧹 make ritual-limpieza     — Limpieza profunda de sistema, permisos y formatos"
	@echo "  ✨ make ritual-despliegue   — Construye y lanza todos los servicios IA"

else
	@gum style --foreground 208 --bold "🐱 Comandos básicos para invocar Anuset89"
	@gum style --foreground 75 --bold "🧹 Limpieza y gestión:"
	@echo "  $$(gum style --foreground 81 --bold "make clean")                 — Purga contenedores y redes Docker que no están en uso"
	@echo "  $$(gum style --foreground 81 --bold "make menu")                  — Muestra el menú místico interactivo y visual"
	@echo ""
	@gum style --foreground 203 --bold "🏗️ Creación y control de servicios IA:"
	@echo "  $$(gum style --foreground 220 --bold "make create-<nombre>")        — Crea estructura base en ./services/<nombre>"
	@echo "  $$(gum style --foreground 220 --bold "make test-<nombre> [PORT=xxxx]") — Test local del servicio IA en el puerto indicado"
	@echo "  $$(gum style --foreground 220 --bold "make generate-service NAME=<nombre>") — Genera un servicio IA completo listo para producción"
	@echo "  $$(gum style --foreground 220 --bold "make regen-all")               — Regenera todos los servicios desde plantilla base actualizada"
	@echo "  $$(gum style --foreground 220 --bold "make lanzar")                  — Arranca todos los servicios IA definidos en docker-compose"
	@echo "  $$(gum style --foreground 220 --bold "make stop")                    — Detiene todos los servicios IA activos"
	@echo ""
	@gum style --foreground 71 --bold "📦 Preparación y dependencias:"
	@echo "  $$(gum style --foreground 201 --bold "make install-all")               — Instala dependencias de backend y frontend"
	@echo "  $$(gum style --foreground 201 --bold "make update-rituals")            — Actualiza rituales y configuraciones del sistema"
	@echo ""
	@gum style --foreground 75 --bold "🧿 Diagnóstico y salud:"
	@echo "  $$(gum style --foreground 201 --bold "make salud")                     — Ejecuta diagnóstico completo y reporta estado de servicios"
	@echo ""
	@gum style --foreground 75 --bold "📂 Rutas y dominios implicados:"
	@echo "  $$(gum style --foreground 255 --bold "./services/<nombre>")     — Carpeta base para cada módulo o servicio IA"
	@echo "  $$(gum style --foreground 255 --bold "./scripts/")              — Carpeta con scripts auxiliares y rituales"
	@echo "  $$(gum style --foreground 255 --bold "./backend/ y ./frontend/") — Aplicaciones principales backend y frontend"
	@echo ""
	@gum style --foreground 208 --bold "🌟 Consejo del Oráculo: Invoca $$(gum style --foreground 81 --bold "make help-advanced") para ver rituales, variables y rutas detalladas"
	@gum style --foreground 207 --bold "🔮 Rituales Anuset para control total:"
	@echo "  $$(gum style --foreground 220 --bold "make ritual-limpieza")         — Limpieza profunda del sistema Docker y permisos"
	@echo "  $$(gum style --foreground 220 --bold "make ritual-despliegue")       — Despliegue de todos los servicios IA"
	@echo "  $$(gum style --foreground 220 --bold "make ritual-test-completo")    — Test y diagnóstico integral de todos los servicios"
	@echo "  $$(gum style --foreground 220 --bold "make ritual-mantenimiento")    — Lint, formato, permisos y Dockerfiles"
	@echo "  $$(gum style --foreground 220 --bold "make ritual-backup")           — Backup automático de configuraciones y datos"

endif

# ============================
#       AYUDA AVANZADA
# ============================

help-advanced:
ifeq ($(GUM_EXISTS),)
	@echo "$(NO_GUM_MSG)"
else
	@gum style --foreground 207 --bold "🐱 Rituales Avanzados y Variables para Anuset89"
	@echo ""
	@gum style --foreground 110 --bold "🧹 Limpieza y gestión:"
	@echo "  $$(gum style --foreground 81 --bold "make clean")        — Purga contenedores y redes Docker huérfanas"
	@echo "  $$(gum style --foreground 81 --bold "make menu")         — Menú místico visual para control rápido"
	@echo ""
	@gum style --foreground 203 --bold "🏗️ Control avanzado de servicios IA:"
	@echo "  $$(gum style --foreground 220 --bold "make create-<nombre>")          — Crea estructura base para nuevo servicio IA"
	@echo "  $$(gum style --foreground 220 --bold "make test-<nombre> [PORT=xxxx]") — Test local especificando puerto"
	@echo "  $$(gum style --foreground 220 --bold "make generate-service NAME=<nombre>") — Genera un servicio IA listo para producción con Dockerfile, scripts y configuraciones"
	@echo "  $$(gum style --foreground 220 --bold "make regen-all")                 — Regenera todos los servicios IA desde plantilla base"
	@echo "  $$(gum style --foreground 220 --bold "make lanzar")                    — Arranca todos los servicios IA definidos"
	@echo "  $$(gum style --foreground 220 --bold "make stop")                      — Detiene todos los servicios IA"
	@echo ""
	@gum style --foreground 71 --bold "📦 Preparación y gestión de dependencias:"
	@echo "  $$(gum style --foreground 201 --bold "make install-all")               — Instala todas las dependencias necesarias (backend + frontend)"
	@echo "  $$(gum style --foreground 201 --bold "make update-rituals")            — Actualiza rituales y configuraciones del sistema"
	@echo ""
	@gum style --foreground 75 --bold "🧿 Diagnósticos detallados:"
	@echo "  $$(gum style --foreground 201 --bold "make salud")                     — Diagnóstico avanzado de salud y estado de servicios"
	@echo ""
	@gum style --foreground 75 --bold "📂 Rutas y dominios implicados:"
	@echo "  $$(gum style --foreground 255 --bold "./services/<nombre>")     — Servicios IA independientes"
	@echo "  $$(gum style --foreground 255 --bold "./scripts/")              — Scripts auxiliares y rituales de control"
	@echo "  $$(gum style --foreground 255 --bold "./backend/ y ./frontend/") — Aplicaciones principales"
	@echo ""
	@gum style --foreground 204 --bold "🧙‍♂️ Variables mágicas:"
	@echo "  $$(gum style --foreground 81 --bold "PORT")                 — Puerto donde correr el servicio IA en test local"
	@echo "  $$(gum style --foreground 81 --bold "NAME")                 — Nombre identificador del servicio IA"
	@echo ""
	@gum style --foreground 208 --bold "🌟 Consejo: Usa $$(gum style --foreground 81 --bold "make clean") frecuentemente para evitar conflictos y maleficios"
	@gum style --foreground 213 --bold "🔮 Rituales mágicos de Anuset:"
	@echo "  $$(gum style --foreground 207 --bold "make ritual-renacer")     — Purga todo, regenera servicios y lanza todo limpio (renacimiento total)"

endif
 
# ============================
#          LIMPIEZA
# ============================

clean:
	@if [ -z "$(GUM_EXISTS)" ]; then \
		echo "$(NO_GUM_MSG)"; \
	else \
		gum style --foreground 208 "💨 Purga todos los contenedores y redes olvidadas..."; \
	fi
	-docker compose down --rmi local -v --remove-orphans
	-docker system prune -f
	@if [ -z "$(GUM_EXISTS)" ]; then \
		echo "💨 Purga completada."; \
	else \
		gum style --foreground 82 "💨 Purga completada."; \
	fi

# ============================
#     RITUAL DE RENACER ✨
# ============================
ritual-renacer:
	@echo "🌑 Invocando ritual de purga, regeneración y renacimiento..."
	$(MAKE) clean
	$(MAKE) regen-all
	$(MAKE) lanzar

# ============================
#      MENÚ MÍSTICO VISUAL
# ============================

menu:
	@if [ -z "$(GUM_EXISTS)" ]; then \
		echo "$(NO_GUM_MSG)"; \
	else \
		gum style --foreground 208 "🔮 Invocando menú místico visual..."; \
		./scripts/run.sh; \
	fi

# ============================
#  CREAR ESTRUCTURA DE SERVICIO
# ============================

create-%:
	@gum style --foreground 93 "🔧 Forjando estructura base para servicio '$*'..."
	@mkdir -p services/$*
	@touch services/$*/app.py
	@echo "FROM python:3.11-slim" > services/$*/Dockerfile
	@echo "WORKDIR /app" >> services/$*/Dockerfile
	@echo "COPY app.py ./app.py" >> services/$*/Dockerfile
	@echo "RUN pip install fastapi uvicorn" >> services/$*/Dockerfile
	@echo "EXPOSE 8000" >> services/$*/Dockerfile
	@echo 'CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]' >> services/$*/Dockerfile
	@gum style --foreground 75 "✔ Estructura base creada en ./services/$*"

# ============================
#  TEST LOCAL DE SERVICIO IA
# ============================

test-%:
	@if [ -z "$(PORT)" ]; then \
		PORT=8000; \
	fi; \
	gum style --foreground 208 "🚀 Testeando servicio '$*' en puerto $$PORT..."; \
	cd services/$* && uvicorn app:app --host 0.0.0.0 --port $$PORT

# ============================
# GENERAR SERVICIO COMPLETO
# ============================

generate-service:
ifndef NAME
	$(error Variable NAME no definida. Uso: make generate-service NAME=<nombre>)
endif
	@gum style --foreground 93 "🛠️ Generando servicio IA completo para '$(NAME)'..."
	@mkdir -p services/$(NAME)
	@cp templates/service_template/* services/$(NAME)/
	@gum style --foreground 75 "✔ Servicio '$(NAME)' generado desde plantilla."

# ============================
# REGENERAR TODOS LOS SERVICIOS
# ============================

regen-all:
	@gum style --foreground 208 "♻️ Regenerando todos los servicios IA desde plantilla..."
	@for d in services/*; do \
		if [ -d "$$d" ]; then \
			name=$$(basename $$d); \
			make generate-service NAME=$$name; \
		fi; \
	done
	@gum style --foreground 75 "✔ Todos los servicios regenerados."

# ============================
# INSTALAR DEPENDENCIAS BACKEND + FRONTEND
# ============================

install-all:
	@gum style --foreground 208 "📦 Instalando dependencias backend + frontend..."
	@pip install -r backend/requirements.txt
	@cd frontend && npm install
	@gum style --foreground 75 "✔ Dependencias instaladas."

# ============================
# DIAGNÓSTICO COMPLETO DEL SISTEMA
# ============================

salud:
	@gum style --foreground 208 "🧿 Ejecutando diagnóstico completo del sistema..."
	@./scripts/diag.sh

# ============================
# LANZAR TODOS LOS SERVICIOS IA
# ============================

lanzar:
	@gum style --foreground 208 "🚀 Arrancando todos los servicios IA..."
	@docker compose up -d

# ============================
# DETENER TODOS LOS SERVICIOS IA
# ============================

stop:
	@gum style --foreground 208 "🛑 Deteniendo todos los servicios IA..."
	@docker compose down

# ============================
# ACTUALIZAR RITUALES Y CONFIGURACIONES
# ============================

update-rituals:
	@gum style --foreground 208 "🔄 Actualizando rituales y configuraciones..."
	@./scripts/update_rituals.sh

# ============================
# EJEMPLOS DE SERVICIOS CON NOMBRE
# ============================

servicios:
	@echo "Lista servicios IA disponibles:"
	@ls services/

ritual:
	@cd services/ritual && uvicorn app:app --reload

musica:
	@cd services/musica && uvicorn app:app --reload

voz:
	@cd services/voz && uvicorn app:app --reload

memoria:
	@cd services/memoria && uvicorn app:app --reload

codellama:
	@cd services/codellama && uvicorn app:app --reload

animatediff:
	@cd services/animatediff && uvicorn app:app --reload

frontend:
	@cd frontend && npm run dev

diag:
	@./scripts/diag.sh

# ============================
# AÑADIR TOKEN DE Huggingface
# ============================
ritual-token:
	@gum style --foreground 206 "✨ Ritual para configurar tu Hugging Face Token ✨"
	@token=$$(gum input --placeholder "Introduce tu Hugging Face Token (HF_TOKEN)" --password); \
	if [ -z "$$token" ]; then \
		gum style --foreground 196 "[ERROR] No se introdujo ningún token. Abortando."; exit 1; \
	fi; \
	if [ ! -f .env ]; then \
		echo "HF_TOKEN=$$token" > .env; \
		gum style --foreground 39 "✔ Archivo \".env\" creado con tu token."; \
	else \
		if grep -q "^HF_TOKEN=" .env; then \
			sed -i "s/^HF_TOKEN=.*/HF_TOKEN=$$token/" .env; \
			gum style --foreground 39 "✔ Token HF_TOKEN actualizado en \".env\"."; \
		else \
			echo "HF_TOKEN=$$token" >> .env; \
			gum style --foreground 39 "✔ Token HF_TOKEN añadido a \".env\"."; \
		fi; \
	fi
# ============================
#     RITUALES MÍSTICOS
# ============================

ritual-limpieza:
	@echo "🧹 Ritual de limpieza profunda del plano IA..."
	./scripts/clean_docker_system.sh
	./scripts/fix_permissions.sh
	./scripts/format.sh

ritual-despliegue:
	@echo "✨ Ritual de despliegue estelar de servicios..."
	./scripts/build_all_services.sh
	./scripts/update_rituals.sh
	$(DC) up -d

ritual-test-completo:
	@echo "🧪 Ritual de prueba y diagnóstico total..."
	./scripts/test_all_services.sh
	./scripts/status_services.sh

ritual-mantenimiento:
	@echo "🔧 Ritual de mantenimiento y armonización de planos..."
	./scripts/lint.sh
	./scripts/format.sh
	./scripts/fix_permissions.sh
	./scripts/fix_dockerfiles.py

ritual-backup:
	@echo "📦 Invocando ritual de resguardo sagrado con versión semántica..."
	@mkdir -p backups
	@last=$$(ls backups/backup-anuset-v*.tar.gz 2>/dev/null | \
		sed -E 's/.*v([0-9]+)-([0-9]+)\.tar\.gz/\1 \2/' | \
		sort -n -k1,1 -k2,2 | tail -n 1); \
	if [ -z "$$last" ]; then v1=0; v2=1; \
	else \
		v1=$$(echo $$last | cut -d' ' -f1); \
		v2=$$(echo $$last | cut -d' ' -f2); \
		if [ "$$v2" -ge 9 ]; then \
			v1=$$((v1 + 1)); v2=0; \
		else \
			v2=$$((v2 + 1)); \
		fi; \
	fi; \
	version="v$${v1}-$${v2}"; \
	file="backups/backup-anuset-$$version.tar.gz"; \
	tar --exclude='./backups' \
	    --exclude='./node_modules' \
	    --exclude='*.pyc' \
	    --exclude='__pycache__' \
	    -czf $$file \
	    Makefile \
	    docker-compose.yml docker-compose*.yml \
	    .env* \
	    scripts/ \
	    services/ \
	    backend/ \
	    frontend/ && \
	echo "✅ Backup creado como: $$file"

# ====================================
#          BACKUPS
# ====================================
BACKUP_DIR := ./backups

.PHONY: ritual-backups ritual-restore

ritual-backups:
	@if [ ! -d "$(BACKUP_DIR)" ]; then \
		echo "❌ Carpeta $(BACKUP_DIR) no existe"; \
		exit 1; \
	fi; \
	echo "📜 Listado de backups válidos:"; \
	ls "$(BACKUP_DIR)"/backup-anuset-v*.tar.gz 2>/dev/null | grep -E '^.*backup-anuset-v[0-9]+-[0-9]+\.tar\.gz$$' || echo "⛔️ No hay backups válidos aún."

ritual-restore:
	@echo "🌀 Invocando ritual de restauración..."; \
	files=$$(ls "$(BACKUP_DIR)"/backup-anuset-v*.tar.gz 2>/dev/null | grep -E '^.*backup-anuset-v[0-9]+-[0-9]+\.tar\.gz$$'); \
	if [ -z "$$files" ]; then \
		echo "⛔️ No hay backups disponibles."; exit 1; \
	fi; \
	echo "🧾 Backups disponibles:"; \
	echo "$$files" | nl -w2 -s'. '; \
	echo -n "🧙‍♀️ Elige el número a restaurar: "; \
	read num; \
	selected=$$(echo "$$files" | sed -n "$${num}p"); \
	if [ -z "$$selected" ]; then \
		echo "❌ Selección inválida."; exit 1; \
	fi; \
	echo "🧭 Restaurando desde: $$selected"; \
	tar -xzf "$$selected" -C . && echo "✅ Restauración completada desde: $$selected"

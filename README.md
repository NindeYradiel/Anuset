# 🌌 Anuset-FINAL

**Anuset-FINAL** es una plataforma mística-cyberpunk modular para rituales interactivos con IA: texto, imagen, música, video y código. Basado en `FastAPI`, `React/Vite`, contenedores Docker y modelos como `DeepSeek`, `MusicGen`, `ComfyUI` y más.

---

## 🚀 Instalación rápida (dev)

Clona el repositorio y levanta los servicios:

```bash
git clone https://github.com/TuUsuario/anuset-final.git
cd anuset-final
make deploy
Requisitos:

Docker + Docker Compose

Make

Linux o WSL2

🧭 Estructura principal
txt
Copiar
Editar
Anuset-FINAL/
├── frontend/         → React + Vite (ritual visual)
├── backend/          → FastAPI (generación de prompts y control)
├── services/         → Módulos IA: comfyui, code, voz, música...
├── scripts/          → Utilidades comunes y entrypoints IA
├── .github/workflows → CI para validación automática
├── Makefile          → Comandos rápidos: build, logs, zip, clean
└── .gitignore        → Configurado para excluir lo inútil
⚙️ CI/CD con GitHub Actions
Cada push a main ejecuta tests y builds mínimos:

Archivo: .github/workflows/ci.yml

Corrige errores comunes: archivos faltantes, rutas, permisos

Salida esperada: ✅ build-test pasa

En caso de error:

bash
Copiar
Editar
# Verifica que los servicios estén bien definidos
make diag

# Revisa que .gitignore no excluya archivos clave
cat .gitignore
🧰 Comandos útiles (Makefile)
bash
Copiar
Editar
make build       # Construye todos los servicios
make deploy      # Arranca todo en Docker
make logs        # Logs de servicios
make clean       # Limpieza segura
make zip         # Exporta versión limpia del proyecto
make help        # Muestra ayuda
🗃️ Exportación y backups
Puedes exportar una versión limpia para backup:

bash
Copiar
Editar
make zip
# → anuset-final_YYYYMMDD_HHMM.zip
🤝 Contribuciones
Este proyecto es mantenido por Kali/NindeYradiel. Se aceptan ideas, issues y pull requests mágicos o útiles.

🌠 Licencia
MIT License — libre para invocar, bifurcar o reimaginar.
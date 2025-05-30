### 🧠 **Scripts principales del sistema**

#### 🔧 `main_controller.py`

> Lanza, monitorea y reinicia automáticamente todos los servicios IA locales definidos en `docker-compose.yml`.

**Ejecutar:**

```
bash


CopiarEditar
python3 main_controller.py
```

**Funciones:**

- Inicia todos los servicios (si están apagados).
- Verifica que estén activos (cada 60s).
- Descarga modelos Ollama si falta alguno.
- Imprime estado y errores en vivo en la terminal.

------

#### 🩺 `diag_anu89.sh`

> Script de diagnóstico que inspecciona, lista y analiza el estado completo del entorno.

**Ejecutar:**

```
bash


CopiarEditar
./diag_anu89.sh
```

**Incluye:**

- Archivos clave del proyecto
- Contenedores activos (`docker ps`)
- Últimos logs de cada servicio (últimas 10 líneas)
- Revisión de Dockerfile por errores (CMD, ENTRYPOINT, EXPOSE)
- Archivos grandes (>100MB) para depuración
- Estado del espacio en `data/`
- Contenedores que están reiniciando ❌

------

#### 🧹 `cleanup_anu89.sh`

> Automatiza limpieza segura de archivos corruptos, temporales o innecesarios.

**Ejecutar:**

```
bash


CopiarEditar
./cleanup_anu89.sh
```

**Acciones:**

- Elimina archivos vacíos o malformados del root
- Mueve `data/imagen/models/*.safetensors` y `.ckpt` a `/home/saze/Respaldo/models`
- Limpia temporales de Git
- Mueve estructura `Anuset89/d/` (datos cifrados) a `/home/saze/Respaldo/d/` si ya no es parte activa

------

### 🐳 **Contenedores y Servicios**

Todos los servicios se levantan con:

```
bash


CopiarEditar
docker compose up -d
```

O bien, automatizado desde:

```
bash


CopiarEditar
python3 main_controller.py
```

**Servicios incluidos:**

- `frontend` (React + Nginx)
- `backend` (FastAPI + generación de perfiles ritual)
- `openwebui` (interfaz de conversación con LLMs)
- `ollama` (proveedor de modelos como llama3, mistral, codellama…)
- `memgpt`, `musicgen`, `xtts-es`, `animatediff`, `stableaudio`, `codellama`, `comfyui`

------

### 🔐 **Bóveda Cryptomator restaurada**

- Ubicación: `/home/saze/Anuset89-Vault/Anuset89/`
- Archivos clave: `masterkey.cryptomator`, `vault.cryptomator`, y carpeta `d/`
- Montar con la app **Cryptomator** para acceder al contenido cifrado.

------

### 💡 Recomendaciones finales

- ✅ Ejecutá `cleanup_anu89.sh` antes de cada backup
- ✅ Usá `diag_anu89.sh` para saber qué falla antes de depurar
- ✅ Todos los `.sh` tienen permisos ejecutables (`chmod +x`)
- 🧪 Todos los servicios se reinician automáticamente si fallan
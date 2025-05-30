🔹 Con el archivo windows-launcher.bat ya preparado, puedes iniciar todo el sistema Anuset89 en Windows con Docker Desktop + WSL2 de forma automática.

🪄 ¿Cómo usarlo?
✅ Requisitos previos (solo una vez):
Tener Docker Desktop para Windows instalado y funcionando.

Tener una distro WSL2 (como Debian) configurada y Docker Desktop conectado con WSL2.

Tener el proyecto Anuset89-test01 clonado en alguna ruta accesible (por ejemplo: C:\Users\tu_usuario\Anuset89-test01).

(Opcional) Crear carpeta compartida C:\data si la usas en Docker.

▶️ Iniciar Anuset89 en Windows
1. Haz doble clic en:
plaintext
Copiar
Editar
windows-launcher.bat
2. El script hace esto:
Abre una terminal (cmd) con entorno adecuado.

Lanza los servicios Docker (frontend + backend).

Espera hasta que todo esté iniciado.

Abre automáticamente:
👉 http://localhost (tu app Anuset89)

3. Al cerrar la terminal, se detienen todos los contenedores (limpio).
🛑 Detener manualmente (si hiciera falta):
En una terminal, desde la carpeta del proyecto:

bash
Copiar
Editar
docker compose down

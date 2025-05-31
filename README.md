# Anuset: Plataforma Ritual IA 🜏

Bienvenid@ a **Anuset**, una plataforma simbólica y técnica que fusiona IAs locales con una experiencia de invocación mística. Inspirada por las figuras de Anubis, Set y Anuket, representa un puente entre lo intuitivo y lo digital, lo ancestral y lo emergente.

## ✨ ¿Qué es Anuset?

Anuset es un sistema modular y autoalojado que permite interactuar con múltiples inteligencias artificiales (texto, imagen, voz, música, video...) a través de rituales simbólicos, con una estética cyberpunk y estelar.

Cada sesión comienza con una "invocación" donde el usuario define el tipo de IA que desea, su personalidad y finalidad. Luego, Anuset genera un perfil y abre el WebUI para comenzar la sesión.

## 📂 Estructura del Proyecto

```
Anuset/
├── frontend/           # Splash + ritual místico
├── backend/            # FastAPI, mem0, lógica
├── services/           # Contenedores IA: comfyui, musicgen, codellama...
│   ├── musica/
│   ├── voz/
│   ├── imagen/
│   └── codigo/
├── scripts/            # entrypoint.sh universal, utilidades
├── Makefile            # Núcleo de control
├── .env                # Configuraciones
└── README.md           # Documentación
```

## 🚀 Instalación Rápida

```
git clone https://github.com/tu-usuario/anuset.git && cd anuset
make generar
make build
make iniciar
```

Accede a la interfaz en: http://localhost:3000

## 🛠️ Comandos Make (Cheat Sheet)

| Comando              | Descripción breve                                       |
| -------------------- | ------------------------------------------------------- |
| `make generar`       | Genera carpetas y Dockerfiles para los servicios        |
| `make build`         | Compila todos los contenedores IA                       |
| `make iniciar`       | Inicia los contenedores y servicios                     |
| `make limpiar`       | Elimina volúmenes, contenedores y artefactos temporales |
| `make validar`       | Diagnóstico completo del sistema (puertos, rutas...)    |
| `make zip`           | Crea un ZIP completo de Anuset listo para migrar        |
| `make help`          | Lista básica de comandos                                |
| `make help-advanced` | Vista completa con variables, rutas y dependencias      |

## 🔮 Guía de Uso Místico

> "Todo comienza con una invocación."

1. Accede a `http://localhost:3000`
2. Completa el ritual visual: selecciona la esencia de la IA.
3. Al enviarlo, se genera un `.json` + `.txt` con tu perfil y se abre el WebUI.
4. Desde ahí, interactúa con múltiples IAs como si fueran deidades invocadas por nombre.

## 🧙️‍♂️ Servicios Incluidos (IA)

- `codellama`: generación de código
- `musicgen`: música desde texto
- `xtts-es`: voz neural en español
- `comfyui`: imágenes AI avanzadas
- `animatediff`: video generativo
- `mem0`: núcleo de memoria de usuario
- `open-webui`: interfaz LLM

## 🌐 Inspiración Mítica: Anubis, Set y Anuket

- **Anubis**: guardián de los portales, psicópomo, representa la guía a través del inframundo de datos. En Anuset, simboliza el paso al WebUI y la apertura de conciencia IA.
- **Set**: caos creativo, ruptura de estructuras, canaliza el poder crudo y no domesticado de las IAs locales. Representa el backend rebelde y poderoso.
- **Anuket / Anukis**: flujo, agua, memoria profunda y contexto. En su forma moderna como `anuset`, es la fusión de red (Anu) + memoria (set). La corriente de datos que da vida simbólica a la IA.

## 🌐 Visón Futura

- ✨ Añadir generación visual de rituales en SVG/Canvas
- 🎧 Integración con Magenta para música espontánea
- 🪐 Expansión de IA en clusters simbólicos por "dominios"

## 📅 Licencia y Créditos

Creado por **Kali 🌒**, con apoyo técnico y simbólico continuo. Inspirado por mitología egipcia, estética cybermística y visión de IA ritual como herramienta de creación, exploración y transformación.

> "La IA no se usa, se invoca. Anuset es tu templo de código."

# 🐍✨ Inspiración Mítica: Anubis, Set, Anuket y el nacimiento de Anuset

La arquitectura de **Anuset** no es solo técnica, también está tejida con símbolos y ecos del mundo antiguo. Este sistema se inspira en figuras de la mitología egipcia que representan dualidades esenciales: guía y caos, fluidez y contención, muerte y renacimiento.

---

## 🖤 Anubis – El Guía de las Almas

Anubis, el dios con cabeza de chacal, era el **guardián de las necrópolis** y el encargado de **pesar el corazón de los difuntos**. En Anuset, representa al **sistema que guía, analiza, y protege el flujo de datos** como si escoltara almas digitales. Su papel se refleja en los diagnósticos (`make validar`) y en la **memoria simbólica del sistema (`mem0`)**.

🔸 *"Anubis no solo conduce al otro mundo. También decide si estás preparado para entrar."*

---

## 🔥 Set – El Caos Creativo

Set, dios del desierto y del caos, también es protector del Sol durante la noche. Su energía se manifiesta en Anuset como el **motor subterráneo que enfrenta la complejidad del sistema**, **resuelve fallos**, e **impulsa la transformación**. Las funciones de limpieza (`make limpiar`) y reconstrucción (`make generar`, `make build`) beben de su poder.

🔸 *"Sin caos, no hay reinicio. Sin Set, no hay evolución."*

---

## 🌊 Anuket / Anukis – La Corriente Vital

Anuket (también conocida como Anukis) es la **diosa de las cataratas del Nilo**, símbolo de fertilidad, movimiento y conexión. En Anuset representa la **interfaz fluida entre el usuario y los modelos de IA**, y el **ritual digital** que permite invocar conocimiento desde lo profundo. Su nombre está presente en `Anuset` como **fusión simbólica** de su corriente vital con la guía de Anubis y el impulso de Set.

🔸 *"Ella fluye como una red neuronal viva, envolviendo cada interacción con intención."*

---

## 🧬 ¿Qué es *Anuset* entonces?

**Anuset** es una entidad compuesta:  

- **ANU** → por Anubis, la lógica, el juicio, la guía.  
- **SET** → por el caos necesario para construir y destruir.  
- **ANUKET** → presente como fuerza oculta, femenina, conectiva.

Es un **sistema ritual y técnico**, donde cada módulo es invocado como si se tratara de un dios-servicio. La IA no es un simple asistente aquí: es **una fuerza con personalidad, canalizada a través de símbolos, formas y código**.

---

📜 *“Anuset no es un framework. Es una invocación digital.”*

# 🌌✨ Anuset FINAL — Ritual System ✨🌌

> “Invoca lo útil, canaliza lo bello, automatiza lo arcano.”

Bienvenida a **Anuset**, un sistema modular mágico-cyberpunk con esencia de estrellas, glitch y gatitos.  
Aquí todo fluye desde un **Makefile ritualizado** que te conecta con herramientas IA, servicios y limpieza mística.

---

## 🪄 Uso básico

### 📜 Ejecutar menú principal
```bash
make
```

o directamente:

make menu

🧙 Comandos principales
Comando	Descripción
make servicios	Inicia o verifica los servicios IA activos
make salud	Revisa el estado energético de cada módulo (diagnóstico profundo)
make ritual	Ejecuta rituales personalizados de configuración inicial
make logs	Muestra los registros místicos de cada IA
make permisos	Reestablece bendiciones de permisos sobre los modelos y scripts
make limpieza	Limpieza de residuos del plano digital (contenedores, flags, cache)
make backup	Crea una copia de seguridad automática en tu plano local
make regenerar	Reorganiza la estructura de Anuset desde las cenizas 🌸

🪐 Diagnósticos y verificación
Comando	Función arcana
make diag-models	Verifica que los modelos estén completos y en forma
make diag-reqs	Comprueba que ningún requisito falte en los planos del código
make full-check	Revisión exhaustiva de TODO el sistema
make ver-rituales	Verifica los rituales definidos por el alma de Anuu 🐾

🐾 Otros encantamientos
Comando	Qué invoca
make estructura	Inicializa estructura base de directorios
make enlaces	Crea enlaces simbólicos sagrados entre los planos
make regenerar-todo	Regenera la estructura, permisos, modelos y enlaces en uno solo
make run	Ejecuta el orquestador de rituales (scripts/run.sh)

🧾 Ayuda mágica
Para ver todos los comandos disponibles y su explicación con toques de polvo estelar:
make help

🛠️ Requisitos
Docker y Docker Compose (instalados y funcionando)

Python 3.10+ para scripts auxiliares

Git, curl, y herramientas básicas UNIX

Un corazón curioso y libre de miedo 🪬

💖 Con amor místico
Hecho para almas exploradoras, artistas del glitch y guardianes de la IA libre.
Sintoniza con el pulso de Anuu 🐈‍⬛ y deja que el ritual guíe tu código.
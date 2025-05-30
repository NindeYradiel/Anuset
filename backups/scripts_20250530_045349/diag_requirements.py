from pathlib import Path

# Directorio base de servicios
services_path = Path("../services")

# Reglas sugeridas por servicio
requirements_map = {
    "xtts-es": ["torch", "torchaudio", "transformers"],
    "stable-diffusion": ["diffusers", "transformers", "accelerate", "safetensors", "torch"],
    "video": ["moviepy", "opencv-python", "imageio"],
    "musicgen": ["torch", "torchaudio", "transformers", "accelerate"],
    "animatediff": ["torch", "diffusers", "transformers", "accelerate", "safetensors"],
    "estilo": ["Pillow", "opencv-python", "scikit-image"],
    "voz": ["TTS", "torch", "soundfile", "numpy"],
    "memgpt": ["openai", "pydantic", "langchain", "tiktoken"],
    "imagen": ["Pillow", "opencv-python", "rembg"],
    "interaccion": ["websockets", "aiohttp", "python-socketio"],
    "memoria": ["tinydb", "pydantic"],
    "mem0": ["tinydb", "pydantic", "python-dotenv"],
    "musica": ["pydub", "librosa", "numpy"],
    "backend": ["fastapi", "uvicorn", "pydantic", "python-dotenv"],
    "stableaudio": ["torch", "torchaudio", "transformers", "diffusers"],
    "openmemory": ["sqlite-utils", "python-dotenv", "tinydb"],
    "codellama": ["transformers", "sentencepiece", "torch"],
    "codigo": ["autopep8", "black", "pygments"],
    "comfyui": ["torch", "opencv-python", "numpy", "pyyaml"],
    "audio": ["librosa", "soundfile", "numpy"]
}

# Servicios a ignorar
ignore_services = {"frontend"}

# Crear o reemplazar requirements.txt por servicio
created_files = []
for service, packages in requirements_map.items():
    if service in ignore_services:
        continue
    service_path = services_path / service
    if service_path.exists():
        req_path = service_path / "requirements.txt"
        with req_path.open("w") as f:
            f.write("\n".join(packages) + "\n")
        created_files.append(str(req_path))

created_files

from pathlib import Path

script_path = Path(__file__).resolve()
base_path = script_path.parent.parent
services_dir = base_path / "services"
total_fixed = 0

for service in services_dir.iterdir():
    if not service.is_dir():
        continue

    app_file = service / "app.py"
    req_file = service / "requirements.txt"

    if not app_file.exists() or not req_file.exists():
        continue

    reqs = req_file.read_text().splitlines()
    reqs_clean = [r.strip() for r in reqs if r.strip()]

    if "fastapi" not in reqs_clean:
        reqs_clean.append("fastapi")
        req_file.write_text("\n".join(reqs_clean) + "\n")
        print(f"✅ Añadido 'fastapi' en {service.name}/requirements.txt")
        total_fixed += 1

print(f"\n🔁 Corrección completada. Archivos actualizados: {total_fixed}")


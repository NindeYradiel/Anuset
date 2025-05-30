#!/usr/bin/env python3

import re
from pathlib import Path

IGNORE_SERVICES = {"frontend"}
STANDARD_MODULES = {
    "os", "sys", "re", "math", "json", "time", 
    "pathlib", "logging", "subprocess", "typing", "shutil"
}

# Rutas absolutas basadas en la ubicación del script
script_dir = Path(__file__).resolve().parent
services_dir = script_dir.parent / "services"
output_md = script_dir / "requirements_report.md"

def extract_imports(app_path):
    if not app_path.exists():
        return set()
    code = app_path.read_text(encoding="utf-8")
    imports = set()
    for line in code.splitlines():
        if line.startswith("import "):
            parts = re.findall(r'import (\w+)', line)
            imports.update(parts)
        elif line.startswith("from "):
            match = re.match(r'from (\w+)(?:\.\w+)* import', line)
            if match:
                imports.add(match.group(1))
    return imports - STANDARD_MODULES

def read_requirements(req_path):
    if not req_path.exists():
        return []
    return [line.strip().split('==')[0] for line in req_path.read_text(encoding="utf-8").splitlines() if line.strip()]

def generate_report():
    report = ["# Análisis de Dependencias\n"]
    
    for service in sorted(services_dir.iterdir()):
        if not service.is_dir() or service.name in IGNORE_SERVICES:
            continue

        app_path = service / "app.py"
        req_path = service / "requirements.txt"

        used_imports = extract_imports(app_path)
        listed_reqs = set(read_requirements(req_path))

        missing = sorted(used_imports - listed_reqs)
        extra = sorted(listed_reqs - used_imports)
        
        report.append(f"## Servicio: {service.name}")
        report.append(f"- **app.py**: `{sorted(used_imports)}`")
        report.append(f"- **requirements.txt**: `{sorted(listed_reqs)}`")
        
        if not req_path.exists():
            report.append("> ⚠️ **No existe requirements.txt**")
        elif not listed_reqs:
            report.append("> ⚠️ **requirements.txt vacío**")
        else:
            if missing:
                report.append(f"> ❌ **Faltan**: `{missing}`")
            if extra:
                report.append(f"> ⚠️ **Sobran**: `{extra}`")
            if not missing and not extra:
                report.append("> ✅ **Dependencias correctas**")
                
        report.append("\n---")

    output_md.write_text("\n".join(report), encoding="utf-8")
    print(f"✅ Reporte generado en: {output_md}")

if __name__ == "__main__":
    generate_report()
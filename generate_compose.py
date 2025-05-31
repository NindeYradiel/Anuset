#!/usr/bin/env python3
import os
import yaml

services_dir = "services"
compose_file = "docker-compose.generated.yml"
network_name = "anuset_net"
start_port = 5001

services = {}
port = start_port

for service_name in sorted(os.listdir(services_dir)):
    path = os.path.join(services_dir, service_name)
    dockerfile = os.path.join(path, "Dockerfile")

    if not os.path.isdir(path) or not os.path.isfile(dockerfile):
        print(f"⚠️  Saltando {service_name}: no tiene Dockerfile.")
        continue

    data_volume = f"./data/{service_name}:/app/data"

    os.makedirs(f"data/{service_name}", exist_ok=True)

    services[service_name] = {
        "build": {
            "context": path,
            "dockerfile": "Dockerfile"
        },
        "ports": [f"{port}:8000"],
        "volumes": [data_volume],
        "networks": [network_name],
        "container_name": f"anuset89-vault-{service_name}"
    }

    print(f"✅ {service_name} asignado al puerto {port}")
    port += 1

compose = {
    "networks": {
        network_name: {
            "driver": "bridge"
        }
    },
    "services": services
}

with open(compose_file, "w") as f:
    yaml.dump(compose, f, default_flow_style=False)

print(f"\n✅ {compose_file} generado para {len(services)} servicios desde puerto {start_port}.")

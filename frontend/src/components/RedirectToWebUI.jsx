import { useEffect, useState } from "react";

export default function RedirectToWebUI() {
  const [url, setUrl] = useState(null);

  useEffect(() => {
    fetch("/openwebui-config.json")
      .then((res) => res.json())
      .then((data) => {
        if (data.openWebUI) {
          setUrl(data.openWebUI);
          window.location.href = data.openWebUI;  // redirige automáticamente
        }
      })
      .catch(() => {
        console.error("No se pudo cargar la configuración Open WebUI");
      });
  }, []);

  return (
    <div style={{ color: "#9c88ff", textAlign: "center", marginTop: "2rem" }}>
      {url ? `Redirigiendo a ${url}...` : "Cargando configuración..."}
    </div>
  );
}

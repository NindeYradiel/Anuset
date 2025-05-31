import { useEffect, useState } from "react";
import "./WebUIProxy.css"; // CSS personalizado para glitch + fondo

export default function WebUIProxy() {
  const [cargando, setCargando] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => setCargando(false), 3000); // Simulación de carga ritual
    return () => clearTimeout(timer);
  }, []);

  return (
    <div className="webui-container">
      {cargando ? (
        <div className="ritual-loader">
          <div className="stars" />
          <div className="glitch">Invocando Anuu...</div>
        </div>
      ) : (
        <>
          <div className="anuu-avatar" title="Anuu te acompaña" />
          <iframe
            src="http://localhost:3001"
            className="webui-iframe"
            title="Open WebUI"
          />
        </>
      )}
    </div>
  );
}

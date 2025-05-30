
import { useEffect, useState } from 'react';

export default function AppWrapper() {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => setLoading(false), 4000);
    return () => clearTimeout(timer);
  }, []);

  return loading ? null : (
    <div>
      <h1>🌌 AnuSet89 UI Cargada</h1>
    </div>
  );
}

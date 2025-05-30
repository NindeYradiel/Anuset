
import { useState } from "react";

const AnuuIcon = ({ onClick }: { onClick: () => void }) => {
  const [hovered, setHovered] = useState(false);

  return (
    <img
      src="/anuu-icon.png"
      alt="Anuu Icon"
      onClick={onClick}
      className={`fixed bottom-6 left-6 z-50 w-16 h-16 transition-transform transform ${
        hovered ? "scale-110" : "scale-100"
      }`}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
    />
  );
};

export default AnuuIcon;

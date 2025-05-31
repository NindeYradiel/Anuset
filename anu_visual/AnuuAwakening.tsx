
import { useEffect } from "react";

const AnuuAwakening = ({ visible, onClose }: { visible: boolean; onClose: () => void }) => {
  useEffect(() => {
    const audio = new Audio("/musicaOcean.mp3");
    if (visible) {
      audio.play();
    } else {
      audio.pause();
    }
    return () => {
      audio.pause();
    };
  }, [visible]);

  if (!visible) return null;

  return (
    <div
      className="fixed inset-0 z-40 bg-black bg-opacity-80 flex items-center justify-center"
      onClick={onClose}
    >
      <img src="/anuu-awake.png" alt="Anuu Awake" className="max-w-full max-h-full" />
    </div>
  );
};

export default AnuuAwakening;

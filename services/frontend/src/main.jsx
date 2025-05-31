import React from 'react';
import ReactDOM from 'react-dom/client';
import AppWrapper from './AppWrapper.jsx';
import '../style.css';

document.addEventListener('DOMContentLoaded', () => {
  const splash = document.getElementById('splash-screen');
  setTimeout(() => {
    splash?.remove();
    const root = document.getElementById('root');
    if (root) {
      document.body.classList.add('loaded');
      ReactDOM.createRoot(root).render(
        <React.StrictMode>
          <AppWrapper />
        </React.StrictMode>
      );
    }
  }, 4000);
});

import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';

const App = () => (
  <div className="container">
    <h1>✨ Bienvenida a Anuset</h1>
    <p>Esta es la interfaz inicial del ritual.</p>
  </div>
);

ReactDOM.createRoot(document.getElementById('root')).render(<App />);

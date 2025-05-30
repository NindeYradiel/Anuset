// /home/saze/Anuset89/frontend/public/service-worker.js

self.addEventListener('install', function(e) {
  console.log('[ServiceWorker] Install');
  e.waitUntil(
    caches.open('anuset89-cache').then(function(cache) {
      return cache.addAll([
        '/',
        '/index.html',
        '/splash.css',
        '/fondo.png',
        '/iconokali.jpg',
        '/musicaOcean.mp3',
        '/manifest.webmanifest'
      ]);
    })
  );
});

self.addEventListener('fetch', function(e) {
  e.respondWith(
    caches.match(e.request).then(function(response) {
      return response || fetch(e.request);
    })
  );
});

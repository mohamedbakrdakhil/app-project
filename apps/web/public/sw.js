const CACHE_NAME = 'masteri-v1';
const APP_SHELL = ['/', '/home', '/login', '/manifest.json'];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(APP_SHELL))
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // Never cache API responses (security/freshness requirement)
  if (url.pathname.startsWith('/api/') || url.pathname.startsWith('/_next/data/')) {
    event.respondWith(fetch(request));
    return;
  }

  // Navigation requests: network first, fall back to cached index
  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request).catch(() =>
        caches.match('/').then((cached) => cached || fetch(request))
      )
    );
    return;
  }

  // App shell assets: cache first
  event.respondWith(
    caches.match(request).then((cached) => cached || fetch(request))
  );
});

# HERZ Shop Web (Next.js + Firebase)

Web storefront and admin panel that share the same Firebase project/RTDB schema as the Flutter app:
- Realtime Database paths: `products`, `orders/{uid}`, `purchases/{uid}`, `roles/{uid}/isAdmin`, `users`, `usersByEmail`, `usersByPhone`, `mailQueue` (optional).
- Auth: Email/Password (Google optional if enabled in Firebase).

## 1) Setup

### Environment (.env.local)
Copy `.env.local.example` to `.env.local` and fill from your Firebase project (same project as the Flutter app):
```
NEXT_PUBLIC_FIREBASE_API_KEY=...
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=...
NEXT_PUBLIC_FIREBASE_DATABASE_URL=...
NEXT_PUBLIC_FIREBASE_PROJECT_ID=...
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=...
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=...
NEXT_PUBLIC_FIREBASE_APP_ID=...
```
> Never commit `.env.local`.

### Install & run (Windows/macOS/Linux)
```bash
npm install
npm run dev    # http://localhost:3000
```

### Build
```bash
npm run build
# static output will be in /out
npm start      # runs the production build locally
```

### Deploy to Firebase Hosting
```bash
# one-time init inside /web
firebase init hosting   # choose existing project, set public dir to "out", configure as SPA = y

# deploy
npm run build
firebase deploy
# or: npm run deploy   (build + deploy)
```

> With `next.config.mjs` set to `output: 'export'`, `npm run build` creates the static site in `/out`. Point Hosting to `out` (see firebase.json).

## 2) Features (MVP)
- Public store: products list, product detail, cart (localStorage), checkout.
- Auth: Email/Password, Google (if enabled).
- Checkout: runs RTDB transaction to decrement `products/{productId}/stock` (no increment), creates order under `orders/{uid}/{orderId}`, sets `purchases/{uid}/{productId}=true`. Rolls back stock if failure.
- Orders page: reads `orders/{uid}`.
- Admin panel: checks `roles/{uid}/isAdmin`; allows CRUD on `products/{productId}` with same fields as the Flutter app (name/name_en/desc/desc_en/descExtra/descExtra_en/price/stock/imageUrl/gallery/beforeAfter).
- Images: expects URLs; optional upload flow can be added with Firebase Storage (not storing secrets in code).

## 3) Quick test checklist
1. Login: create account or sign in with email/password (Google if enabled).
2. Products: homepage loads products from `products` without permission errors.
3. Cart + checkout: add items, checkout; stock decrements via transaction, order appears under `orders/{uid}`, `purchases/{uid}` updated.
4. Admin: user with `roles/{uid}/isAdmin=true` can create/update/delete products; non-admin is redirected/blocked.

## 4) Notes on Firebase Rules
- Keep the RTDB rules aligned with the Flutter app: public read for `products`; admin-only full writes; non-admin stock decrement allowed via transaction; admin-only writes for other product fields; per-user reads/writes for `orders` and `purchases`.
- Do not hardcode keys; use `.env.local` for Firebase config.

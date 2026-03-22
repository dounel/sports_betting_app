# Vercel Deploy Guide

**Automatik deploy lè ou pouse sou GitHub**

## Etap 1: Kreye kont Vercel

1. Ale sou [vercel.com](https://vercel.com)
2. Klike "Sign Up" ak GitHub
3. Otorize Vercel pou akse repo GitHub ou yo

## Etap 2: Importe pwojè ou a

1. Nan Vercel dashboard, klike "Add New Project"
2. Chwazi repo `sports_betting_app` ou a
3. Klike "Import"

## Etap 3: Configure Project

**Framework Preset:** `Other` (paske se yon Node.js project simple)

**Root Directory:** `./` (default)

**Build Command:** (kite vid)

**Output Directory:** (kite vid)

## Etap 4: Configure Environment Variables

Ale nan "Settings" → "Environment Variables", ajoute:

```
FOOTBALL_API_KEY = 396b03798bb52ede1863990b1fe633b3
```

## Etap 5: Deploy

Klike "Deploy"

## Etap 6: Pran URL ou a

Lè deploy fini, Vercel ap ba ou yon URL tankou:
```
https://sports-betting-app-xyz123.vercel.app
```

**RANPLASE URL SA NAN FLUTTER:**

Nan fichye `lib/core/services/football_api_service.dart`, modifye:
```dart
static const String _vercelProxyUrl = 'https://sports-betting-app-xyz123.vercel.app';
```

## Etap 7: Aktive Auto-Deploy

Vercel deja konfigire pou auto-deploy lè ou pouse sou GitHub. Men verifye:

1. Nan Vercel dashboard → Project Settings → Git
2. Verifye "Production Branch" se `main` (oswa branch ou itilize)
3. "Deploy Hooks" aktive

## Test API a

Ale nan:
```
https://[URL-OU-A]/api/matches?type=all&limit=10
```

Ou ta dwe wè match yo nan JSON.

## Pwoblèm komen

**404 Not Found:**
- Verifye `vercel.json` la byen nan root directory
- Verifye `api/matches.js` egziste

**CORS Error toujou:**
- Verifye URL la korek nan Flutter
- Eseye rafrechi paj la (Ctrl+F5)

**API Key pa mache:**
- Verifye varyab anviwònman an byen mete nan Vercel
- Redeploy aplikasyon an

## Deploy ak Git (Altènatif)

Si ou pa vle itilize GitHub integration:

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
vercel --prod
```

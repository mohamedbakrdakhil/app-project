# Masteri

> Maîtrisez les sciences médicales, niveau par niveau.

Application d'apprentissage médical progressive inspirée de Duolingo : progression par niveaux, XP, streak, révisions espacées (SM-2), QCM, questions à trou et génération de contenu par IA.

## Stack technique

| Couche | Technologie |
|---|---|
| Web | Next.js 15, App Router, TypeScript strict |
| Styling | Tailwind CSS + CSS variables |
| Auth & DB | Supabase Auth + PostgreSQL + RLS |
| Business logic | `@masteri/core` — Zod, SM-2, scoring, badges |
| IA | Anthropic API (`claude-sonnet-4-6`) |
| Tests | Vitest (unitaires) + Playwright (E2E) |
| Monorepo | pnpm workspaces |

## Installation

```bash
pnpm install
```

## Variables d'environnement

Copie `apps/web/.env.local.example` vers `apps/web/.env.local` :

```bash
cp apps/web/.env.local.example apps/web/.env.local
```

Remplis les valeurs :

| Variable | Description |
|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | URL du projet Supabase |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Clé anon Supabase |
| `SUPABASE_SERVICE_ROLE_KEY` | Service role (serveur uniquement) |
| `ANTHROPIC_API_KEY` | Clé Anthropic (optionnel, active la génération IA) |
| `ANTHROPIC_MODEL` | Modèle Anthropic (défaut : `claude-sonnet-4-6`) |

## Supabase — Migrations & Seed

Dans le SQL Editor de ton projet Supabase, exécute dans cet ordre :

1. `packages/db/supabase/migrations/0001_initial_schema.sql`
2. `packages/db/supabase/migrations/0002_badges.sql`
3. `packages/db/supabase/migrations/0003_ai_content.sql`
4. `packages/db/supabase/seed.sql`

## Développement

```bash
pnpm dev        # Lance l'app web sur localhost:3000
pnpm test       # Tests unitaires (Vitest)
pnpm typecheck  # Vérification TypeScript
pnpm lint       # ESLint
pnpm build      # Build de production
pnpm e2e        # Tests E2E Playwright (app doit tourner)
```

## Architecture

```
masteri/
├── apps/web/                    # Next.js App Router
│   ├── app/
│   │   ├── (auth)/              # Login, Register
│   │   ├── (app)/               # Home, Subject, Lesson, Reviews, Profile, Admin
│   │   └── api/                 # Route handlers serveur
│   ├── components/
│   │   ├── layout/              # AppShell, Header, BottomNav
│   │   ├── lesson/              # LessonPlayer, IntroStep, RecallStep, FillBlankStep, CompleteStep
│   │   ├── providers/           # AuthProvider
│   │   └── ui/                  # Button, Card, XPBar, BoneSVG, Skeleton, TimerRing...
│   └── lib/
│       ├── supabase/            # browser.ts, server.ts, admin.ts
│       ├── ai/                  # generate-content.ts
│       └── rate-limit.ts
│
├── packages/core/               # Logique métier partagée
│   ├── lesson-schema.ts         # Schémas Zod
│   ├── scoring.ts               # Calcul XP
│   ├── sm2.ts                   # Algorithme SM-2
│   ├── badges.ts                # Évaluation badges
│   └── progress.ts
│
├── packages/db/
│   └── supabase/
│       ├── migrations/          # 0001, 0002, 0003
│       └── seed.sql             # Anatomie, 6 niveaux
│
└── packages/content/
    └── anatomy/skeletal-system.seed.json
```

## Fonctionnalités MVP

- ✅ Authentification (email/password)
- ✅ Leçons : intro → recall (QCM) → fill_blank → complete
- ✅ Validation des réponses côté serveur
- ✅ XP et progression persistés en base
- ✅ Répétition espacée SM-2
- ✅ Badges (8 types)
- ✅ Objectif quotidien configurable
- ✅ Freemium (3 leçons/jour gratuit)
- ✅ Pipeline IA (génération de brouillons)
- ✅ Interface d'administration
- ✅ Visualisation SVG des os
- ✅ Analytics d'erreurs personnelles
- ✅ PWA manifest

## Sécurité

- RLS activé sur toutes les tables
- `user_id` toujours dérivé de la session serveur
- Answer keys jamais exposées avant soumission
- XP et progression calculés côté serveur
- Service role uniquement dans les route handlers serveur
- Rate limiting sur les routes sensibles

## Hors scope (à venir)

- Expo mobile
- Stripe (paiement)
- Ligues hebdomadaires
- Notifications push
- Mode hors-ligne
- Viewer 3D

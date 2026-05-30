# Masteri

Application d'apprentissage médical progressive. Ticket 01 — MVP Foundation.

## Installation

```bash
pnpm install
```

## Variables d'environnement

Copy `.env.example` to `apps/web/.env.local` and fill in:

- `NEXT_PUBLIC_SUPABASE_URL` — your Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` — your Supabase anon key
- `SUPABASE_SERVICE_ROLE_KEY` — your Supabase service role key (server only)

## Lancement

```bash
pnpm dev
```

## Migrations Supabase

Apply migrations via the Supabase dashboard SQL editor or CLI:

```bash
supabase db reset
```

Or run `packages/db/supabase/migrations/0001_initial_schema.sql` manually.

## Seed

Run `packages/db/supabase/seed.sql` in the Supabase SQL editor after migrations.

## Tests

```bash
pnpm test
```

## Architecture

- `apps/web` — Next.js App Router web application
- `packages/core` — Business logic: lesson schema (Zod), scoring, SM-2, progress
- `packages/db` — SQL migrations and seed data
- `packages/content` — Educational content seeds
- `packages/config` — Shared TypeScript and ESLint config

## Hors scope (Ticket 01)

- 3D viewer
- Expo mobile app
- Stripe payments
- AdMob
- Push notifications
- Weekly leagues
- AI content generation
- Offline mode

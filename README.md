# Masteri

Application d'apprentissage médical progressive.

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

Run migrations in order:
1. `packages/db/supabase/migrations/0001_initial_schema.sql` — core schema
2. `packages/db/supabase/migrations/0002_badges.sql` — badges & user_badges tables

## Seed

Run `packages/db/supabase/seed.sql` in the Supabase SQL editor after migrations.

## Tests

```bash
pnpm test
```

## Architecture

- `apps/web` — Next.js App Router web application
- `packages/core` — Business logic: lesson schema (Zod), scoring, SM-2, progress, badges
- `packages/db` — SQL migrations and seed data
- `packages/content` — Educational content seeds
- `packages/config` — Shared TypeScript and ESLint config

## Features by Ticket

### Ticket 01 — MVP Foundation
- Auth (Supabase), profiles, lesson attempts, scoring, XP, streak
- 6 anatomy levels with fill_blank + recall steps

### Ticket 02 — Spaced Repetition & Reviews
- SM-2 algorithm, spaced_rep_cards, /reviews page
- Daily review queue with due card count on home

### Ticket 03 — SVG Visuals & Analytics
- SVG bone diagrams in intro steps (femur, tibia, cranium, etc.)
- Error analytics dashboard `/analytics/errors`
- Playwright e2e setup

### Ticket 04 — Social & Gamification
- **Badges system**: 8 badge types awarded on lesson completion
  - `first_level_complete` — first level finished
  - `perfect_score` — 100% score on a level
  - `streak_days` — consecutive daily streak (3 and 7 day milestones)
  - `total_xp` — XP thresholds (100 and 500 XP)
  - `levels_complete_count` — number of completed levels (3 and 6)
- Badges displayed in lesson summary and on profile page
- **Daily XP goal** — configurable per-user (3/5/10/15/20 levels/day) via profile page
- **XP history chart** — 7-day bar chart on profile page
- **Home page** — today's XP vs daily goal, levels completed today
- Migration: `packages/db/supabase/migrations/0002_badges.sql`

## Hors scope

- 3D viewer
- Expo mobile app
- Stripe payments
- AdMob
- Push notifications
- Weekly leagues
- AI content generation
- Offline mode

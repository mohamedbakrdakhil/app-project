create table if not exists public.badges (
  id text primary key check (id ~ '^[a-z0-9_]+$'),
  name_fr text not null,
  description_fr text not null,
  icon text not null,
  condition_type text not null check (condition_type in (
    'first_level_complete',
    'perfect_score',
    'streak_days',
    'total_xp',
    'levels_complete_count'
  )),
  condition_value integer not null default 1 check (condition_value > 0),
  created_at timestamptz not null default now()
);

create table if not exists public.user_badges (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  badge_id text not null references public.badges(id) on delete cascade,
  earned_at timestamptz not null default now(),
  unique (user_id, badge_id)
);

alter table public.badges enable row level security;
alter table public.user_badges enable row level security;

create policy badges_select_all
on public.badges
for select
to authenticated
using (true);

create policy user_badges_select_own
on public.user_badges
for select
to authenticated
using ((select auth.uid()) = user_id);

-- Seed badges
insert into public.badges (id, name_fr, description_fr, icon, condition_type, condition_value) values
  ('first_steps', 'Premiers pas', 'Complète ton premier niveau', '🎯', 'first_level_complete', 1),
  ('perfectionist', 'Perfectionniste', 'Obtiens un score parfait sur un niveau', '💎', 'perfect_score', 1),
  ('streak_3', 'En feu', '3 jours de streak consécutifs', '🔥', 'streak_days', 3),
  ('streak_7', 'Semaine parfaite', '7 jours de streak consécutifs', '🏆', 'streak_days', 7),
  ('xp_100', 'Centurion', 'Accumule 100 XP', '⚡', 'total_xp', 100),
  ('xp_500', 'Expert', 'Accumule 500 XP', '🌟', 'total_xp', 500),
  ('levels_3', 'Explorateur', 'Complète 3 niveaux', '🗺️', 'levels_complete_count', 3),
  ('levels_6', 'Anatomiste', 'Complète les 6 niveaux d''anatomie', '🦴', 'levels_complete_count', 6)
on conflict (id) do update set
  name_fr = excluded.name_fr,
  description_fr = excluded.description_fr,
  icon = excluded.icon,
  condition_type = excluded.condition_type,
  condition_value = excluded.condition_value;

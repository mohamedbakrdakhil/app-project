-- Weekly league snapshots
create table if not exists public.league_snapshots (
  id uuid primary key default gen_random_uuid(),
  week_start date not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  display_name text not null,
  xp_this_week integer not null default 0 check (xp_this_week >= 0),
  tier text not null default 'bronze' check (
    tier in ('bronze', 'silver', 'gold', 'platinum', 'diamond', 'champion')
  ),
  rank_in_tier integer,
  created_at timestamptz not null default now(),
  unique (week_start, user_id)
);

create index if not exists league_snapshots_week_tier_xp_idx
on public.league_snapshots(week_start, tier, xp_this_week desc);

alter table public.league_snapshots enable row level security;

create policy league_snapshots_select_all
on public.league_snapshots
for select
to authenticated
using (true);

-- Weekly XP accumulator (resets each week)
create table if not exists public.weekly_xp (
  user_id uuid not null references auth.users(id) on delete cascade,
  week_start date not null,
  xp_earned integer not null default 0 check (xp_earned >= 0),
  updated_at timestamptz not null default now(),
  primary key (user_id, week_start)
);

alter table public.weekly_xp enable row level security;

create policy weekly_xp_select_own
on public.weekly_xp
for select
to authenticated
using ((select auth.uid()) = user_id);

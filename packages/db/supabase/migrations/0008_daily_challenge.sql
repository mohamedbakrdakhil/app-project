create table if not exists public.daily_challenges (
  id uuid primary key default gen_random_uuid(),
  challenge_date date not null unique,
  level_id uuid not null references public.levels(id),
  created_at timestamptz not null default now()
);
alter table public.daily_challenges enable row level security;
create policy "Anyone can read daily challenges" on public.daily_challenges
  for select using (true);

create table if not exists public.daily_challenge_completions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  challenge_date date not null,
  completed_at timestamptz not null default now(),
  xp_earned int not null default 0,
  unique(user_id, challenge_date)
);
alter table public.daily_challenge_completions enable row level security;
create policy "Users manage own completions" on public.daily_challenge_completions
  for all using (auth.uid() = user_id);

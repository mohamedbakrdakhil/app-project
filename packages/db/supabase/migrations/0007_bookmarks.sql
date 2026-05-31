create table if not exists public.bookmarked_levels (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  level_id uuid not null references public.levels(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique(user_id, level_id)
);
alter table public.bookmarked_levels enable row level security;
create policy "Users manage own bookmarks" on public.bookmarked_levels
  for all using (auth.uid() = user_id);

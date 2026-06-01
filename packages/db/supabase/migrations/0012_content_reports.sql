create table if not exists public.content_reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  level_id uuid not null references public.levels(id) on delete cascade,
  question_key text,
  reason text not null check (reason in ('incorrect_content','typo','unclear','outdated','other')),
  details text,
  status text not null default 'pending' check (status in ('pending','reviewed','resolved')),
  created_at timestamptz not null default now()
);
alter table public.content_reports enable row level security;
create policy "Users create own reports" on public.content_reports
  for insert with check (auth.uid() = reporter_id);
create policy "Users see own reports" on public.content_reports
  for select using (auth.uid() = reporter_id);

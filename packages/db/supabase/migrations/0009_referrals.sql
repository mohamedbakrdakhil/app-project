create table if not exists public.referrals (
  id uuid primary key default gen_random_uuid(),
  referrer_id uuid not null references public.profiles(id) on delete cascade,
  referred_email text not null,
  referred_user_id uuid references public.profiles(id) on delete set null,
  status text not null default 'pending' check (status in ('pending','completed')),
  created_at timestamptz not null default now(),
  unique(referrer_id, referred_email)
);
alter table public.referrals enable row level security;
create policy "Users see own referrals" on public.referrals
  for select using (auth.uid() = referrer_id);
create policy "Users create own referrals" on public.referrals
  for insert with check (auth.uid() = referrer_id);

create table if not exists public.study_groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  owner_id uuid not null references public.profiles(id) on delete cascade,
  invite_code text not null unique default substring(md5(random()::text), 1, 8),
  created_at timestamptz not null default now()
);
alter table public.study_groups enable row level security;
create policy "Members can read groups" on public.study_groups
  for select using (
    exists (select 1 from public.study_group_members where group_id = id and user_id = auth.uid())
  );
create policy "Owner can update/delete group" on public.study_groups
  for all using (auth.uid() = owner_id);

create table if not exists public.study_group_members (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.study_groups(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  joined_at timestamptz not null default now(),
  unique(group_id, user_id)
);
alter table public.study_group_members enable row level security;
create policy "Members can read membership" on public.study_group_members
  for select using (auth.uid() = user_id);
create policy "Users manage own membership" on public.study_group_members
  for all using (auth.uid() = user_id);

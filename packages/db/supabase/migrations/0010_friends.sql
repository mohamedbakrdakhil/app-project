create table if not exists public.friend_requests (
  id uuid primary key default gen_random_uuid(),
  sender_id uuid not null references public.profiles(id) on delete cascade,
  receiver_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending','accepted','declined')),
  created_at timestamptz not null default now(),
  unique(sender_id, receiver_id)
);
alter table public.friend_requests enable row level security;
create policy "Users see own friend requests" on public.friend_requests
  for select using (auth.uid() = sender_id or auth.uid() = receiver_id);
create policy "Users send friend requests" on public.friend_requests
  for insert with check (auth.uid() = sender_id);
create policy "Receiver can update status" on public.friend_requests
  for update using (auth.uid() = receiver_id);

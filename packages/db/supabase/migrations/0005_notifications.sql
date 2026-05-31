create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null check (type in ('badge_earned', 'streak_reminder', 'review_due', 'league_result', 'level_unlocked')),
  title text not null,
  body text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists notifications_user_unread_idx
on public.notifications(user_id, is_read, created_at desc);

alter table public.notifications enable row level security;

create policy notifications_select_own
on public.notifications
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy notifications_update_own
on public.notifications
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create table if not exists public.ai_content_drafts (
  id uuid primary key default gen_random_uuid(),
  created_by uuid references auth.users(id) on delete set null,
  subject_id text references public.subjects(id) on delete cascade,
  chapter_id uuid references public.chapters(id) on delete cascade,
  input_prompt jsonb not null,
  content_public jsonb,
  answer_key jsonb,
  status text not null default 'pending' check (
    status in ('pending', 'generating', 'draft_review_required', 'approved', 'rejected', 'error')
  ),
  error_message text,
  model_used text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_ai_drafts_updated_at
before update on public.ai_content_drafts
for each row execute function public.set_updated_at();

alter table public.ai_content_drafts enable row level security;

-- Only service role can read/write drafts (admin panel uses service role)
-- No client-facing policies — admin only

create table if not exists public.plan_subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  plan text not null default 'free' check (plan in ('free', 'premium')),
  stripe_customer_id text,
  stripe_subscription_id text,
  current_period_end timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id)
);

create trigger set_plan_subscriptions_updated_at
before update on public.plan_subscriptions
for each row execute function public.set_updated_at();

alter table public.plan_subscriptions enable row level security;

create policy plan_subscriptions_select_own
on public.plan_subscriptions
for select
to authenticated
using ((select auth.uid()) = user_id);

-- Auto-create free subscription on new user
create or replace function public.handle_new_user_plan()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.plan_subscriptions (user_id, plan)
  values (new.id, 'free')
  on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created_plan on auth.users;
create trigger on_auth_user_created_plan
after insert on auth.users
for each row execute function public.handle_new_user_plan();

-- Daily lesson usage tracking
create table if not exists public.daily_lesson_usage (
  user_id uuid not null references auth.users(id) on delete cascade,
  usage_date date not null,
  lessons_started integer not null default 0 check (lessons_started >= 0),
  primary key (user_id, usage_date)
);

alter table public.daily_lesson_usage enable row level security;

create policy daily_usage_select_own
on public.daily_lesson_usage
for select
to authenticated
using ((select auth.uid()) = user_id);

-- Enable pgcrypto for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- Utility: set_updated_at trigger function
-- ============================================================
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- ============================================================
-- profiles
-- ============================================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id                  uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email               text,
  full_name           text,
  avatar_url          text,
  streak              integer NOT NULL DEFAULT 0,
  last_active         date,
  total_xp            integer NOT NULL DEFAULT 0,
  daily_goal          integer NOT NULL DEFAULT 5,
  current_league_tier text NOT NULL DEFAULT 'bronze',
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "profiles: select own" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "profiles: update own" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE OR REPLACE TRIGGER trg_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- Auto-create profile on sign-up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', '')
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- subjects
-- ============================================================
CREATE TABLE IF NOT EXISTS public.subjects (
  id              text PRIMARY KEY,
  slug            text UNIQUE NOT NULL,
  name_fr         text NOT NULL,
  icon            text,
  color           text,
  description_fr  text,
  order_index     integer NOT NULL DEFAULT 0,
  is_published    boolean NOT NULL DEFAULT false,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "subjects: select published" ON public.subjects
  FOR SELECT USING (is_published = true);

CREATE OR REPLACE TRIGGER trg_subjects_updated_at
  BEFORE UPDATE ON public.subjects
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- chapters
-- ============================================================
CREATE TABLE IF NOT EXISTS public.chapters (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id  text NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  slug        text NOT NULL,
  title_fr    text NOT NULL,
  icon        text,
  order_index integer NOT NULL DEFAULT 0,
  is_published boolean NOT NULL DEFAULT false,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (subject_id, slug)
);

ALTER TABLE public.chapters ENABLE ROW LEVEL SECURITY;

CREATE POLICY "chapters: select published" ON public.chapters
  FOR SELECT USING (is_published = true);

CREATE OR REPLACE TRIGGER trg_chapters_updated_at
  BEFORE UPDATE ON public.chapters
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- levels
-- ============================================================
CREATE TABLE IF NOT EXISTS public.levels (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  chapter_id      uuid NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  slug            text NOT NULL,
  title_fr        text NOT NULL,
  order_index     integer NOT NULL DEFAULT 0,
  difficulty      text NOT NULL DEFAULT 'easy',
  xp_reward       integer NOT NULL DEFAULT 100,
  content_public  jsonb NOT NULL DEFAULT '{}',
  content_status  text NOT NULL DEFAULT 'draft',
  is_published    boolean NOT NULL DEFAULT false,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (chapter_id, slug)
);

ALTER TABLE public.levels ENABLE ROW LEVEL SECURITY;

CREATE POLICY "levels: select published" ON public.levels
  FOR SELECT USING (is_published = true);

CREATE OR REPLACE TRIGGER trg_levels_updated_at
  BEFORE UPDATE ON public.levels
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- level_answer_keys (service role only — no RLS select for users)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.level_answer_keys (
  id        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  level_id  uuid UNIQUE NOT NULL REFERENCES public.levels(id) ON DELETE CASCADE,
  answers   jsonb NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.level_answer_keys ENABLE ROW LEVEL SECURITY;
-- No SELECT policy for authenticated users — only service role can read

CREATE OR REPLACE TRIGGER trg_level_answer_keys_updated_at
  BEFORE UPDATE ON public.level_answer_keys
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- lesson_attempts
-- ============================================================
CREATE TABLE IF NOT EXISTS public.lesson_attempts (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  level_id         uuid NOT NULL REFERENCES public.levels(id) ON DELETE CASCADE,
  status           text NOT NULL DEFAULT 'started', -- started | completed | abandoned
  started_at       timestamptz NOT NULL DEFAULT now(),
  completed_at     timestamptz,
  score_percent    integer,
  xp_earned        integer,
  duration_seconds integer,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.lesson_attempts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "lesson_attempts: select own" ON public.lesson_attempts
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "lesson_attempts: insert own" ON public.lesson_attempts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "lesson_attempts: update own" ON public.lesson_attempts
  FOR UPDATE USING (auth.uid() = user_id);

CREATE OR REPLACE TRIGGER trg_lesson_attempts_updated_at
  BEFORE UPDATE ON public.lesson_attempts
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- question_attempts
-- ============================================================
CREATE TABLE IF NOT EXISTS public.question_attempts (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_attempt_id  uuid NOT NULL REFERENCES public.lesson_attempts(id) ON DELETE CASCADE,
  user_id            uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  level_id           uuid NOT NULL REFERENCES public.levels(id) ON DELETE CASCADE,
  step_index         integer NOT NULL,
  question_key       text NOT NULL,
  answer             jsonb NOT NULL DEFAULT '{}',
  is_correct         boolean NOT NULL DEFAULT false,
  xp_earned          integer NOT NULL DEFAULT 0,
  answered_at        timestamptz NOT NULL DEFAULT now(),
  created_at         timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.question_attempts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "question_attempts: select own" ON public.question_attempts
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "question_attempts: insert own" ON public.question_attempts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- user_progress
-- ============================================================
CREATE TABLE IF NOT EXISTS public.user_progress (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  level_id            uuid NOT NULL REFERENCES public.levels(id) ON DELETE CASCADE,
  is_completed        boolean NOT NULL DEFAULT false,
  best_score_percent  integer NOT NULL DEFAULT 0,
  attempts_count      integer NOT NULL DEFAULT 0,
  total_xp_earned     integer NOT NULL DEFAULT 0,
  first_completed_at  timestamptz,
  last_attempt_at     timestamptz,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, level_id)
);

ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_progress: select own" ON public.user_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "user_progress: insert own" ON public.user_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_progress: update own" ON public.user_progress
  FOR UPDATE USING (auth.uid() = user_id);

CREATE OR REPLACE TRIGGER trg_user_progress_updated_at
  BEFORE UPDATE ON public.user_progress
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- spaced_rep_cards
-- ============================================================
CREATE TABLE IF NOT EXISTS public.spaced_rep_cards (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  level_id         uuid NOT NULL REFERENCES public.levels(id) ON DELETE CASCADE,
  concept_key      text NOT NULL,
  concept_label    text NOT NULL,
  ease_factor      numeric(4,2) NOT NULL DEFAULT 2.5,
  interval_days    integer NOT NULL DEFAULT 1,
  repetitions      integer NOT NULL DEFAULT 0,
  lapses           integer NOT NULL DEFAULT 0,
  next_review_date date NOT NULL DEFAULT CURRENT_DATE + 1,
  last_reviewed_at timestamptz,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, concept_key)
);

ALTER TABLE public.spaced_rep_cards ENABLE ROW LEVEL SECURITY;

CREATE POLICY "spaced_rep_cards: select own" ON public.spaced_rep_cards
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "spaced_rep_cards: insert own" ON public.spaced_rep_cards
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "spaced_rep_cards: update own" ON public.spaced_rep_cards
  FOR UPDATE USING (auth.uid() = user_id);

CREATE OR REPLACE TRIGGER trg_spaced_rep_cards_updated_at
  BEFORE UPDATE ON public.spaced_rep_cards
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- review_logs
-- ============================================================
CREATE TABLE IF NOT EXISTS public.review_logs (
  id                       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id                  uuid NOT NULL REFERENCES public.spaced_rep_cards(id) ON DELETE CASCADE,
  quality                  integer NOT NULL CHECK (quality BETWEEN 0 AND 5),
  previous_interval_days   integer NOT NULL,
  next_interval_days       integer NOT NULL,
  previous_ease_factor     numeric(4,2) NOT NULL,
  next_ease_factor         numeric(4,2) NOT NULL,
  reviewed_at              timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.review_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "review_logs: select own via card" ON public.review_logs
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.spaced_rep_cards c
      WHERE c.id = card_id AND c.user_id = auth.uid()
    )
  );

CREATE POLICY "review_logs: insert own via card" ON public.review_logs
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.spaced_rep_cards c
      WHERE c.id = card_id AND c.user_id = auth.uid()
    )
  );

-- ============================================================
-- streak_history
-- ============================================================
CREATE TABLE IF NOT EXISTS public.streak_history (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  activity_date   date NOT NULL,
  xp_earned       integer NOT NULL DEFAULT 0,
  levels_completed integer NOT NULL DEFAULT 0,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, activity_date)
);

ALTER TABLE public.streak_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "streak_history: select own" ON public.streak_history
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "streak_history: insert own" ON public.streak_history
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "streak_history: update own" ON public.streak_history
  FOR UPDATE USING (auth.uid() = user_id);

CREATE OR REPLACE TRIGGER trg_streak_history_updated_at
  BEFORE UPDATE ON public.streak_history
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

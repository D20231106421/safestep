-- SafeStep Supabase PostgreSQL Schema
-- Replaces all previous Firebase / Firestore collections.
-- Run this script in your Supabase project's SQL Editor.

-- 1. Users table (tracks anonymous persistent device UUIDs)
create table if not exists public.users (
  id uuid primary key,
  last_active timestamptz not null default now(),
  app_version text,
  platform text,
  created_at timestamptz not null default now()
);

-- 2. Simulation History Logs
create table if not exists public.history_logs (
  user_id uuid not null references public.users(id) on delete cascade,
  id bigint not null,
  date text not null,
  score integer not null,
  total integer not null,
  shields integer not null,
  status text not null,
  results jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  primary key (user_id, id)
);

create index if not exists idx_history_logs_user_id_desc
  on public.history_logs (user_id, id desc);

-- 3. User-created Custom Scenarios
create table if not exists public.custom_scenarios (
  user_id uuid not null references public.users(id) on delete cascade,
  id bigint not null,
  is_active boolean not null default true,
  type text not null,
  category text not null,
  technique text not null default 'Social Engineering',
  sender text not null,
  timestamp text not null default 'Terkini',
  message text not null,
  is_scam boolean not null default true,
  explanation text not null default '',
  recommended_actions jsonb not null default '[]'::jsonb,
  reply_options jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  primary key (user_id, id)
);

create index if not exists idx_custom_scenarios_user_id
  on public.custom_scenarios (user_id);

-- 4. Table Privileges & Row Level Security (RLS)
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on table public.users to anon, authenticated;
grant select, insert, update, delete on table public.history_logs to anon, authenticated;
grant select, insert, update, delete on table public.custom_scenarios to anon, authenticated;

alter table public.users enable row level security;
alter table public.history_logs enable row level security;
alter table public.custom_scenarios enable row level security;

-- Note: SafeStep currently uses a client-generated persistent UUID (IdentityService)
-- without Supabase Auth sign-in. These policies allow anon access scoped by client requests.
-- Once you add Supabase Auth, replace these policies with `auth.uid() = id` / `auth.uid() = user_id`.
create policy "Allow anon full access to users"
  on public.users for all
  to anon, authenticated
  using (true)
  with check (true);

create policy "Allow anon full access to history_logs"
  on public.history_logs for all
  to anon, authenticated
  using (true)
  with check (true);

create policy "Allow anon full access to custom_scenarios"
  on public.custom_scenarios for all
  to anon, authenticated
  using (true)
  with check (true);

-- Run this once in Supabase → SQL Editor → New query → Run.
-- It creates a single shared row that the page reads and updates.

create table if not exists public.capsule (
  id int primary key default 1 check (id = 1),
  data jsonb not null default '{"memories":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

insert into public.capsule (id, data)
values (1, '{"memories":[]}'::jsonb)
on conflict (id) do nothing;

alter table public.capsule enable row level security;

drop policy if exists "capsule read" on public.capsule;
drop policy if exists "capsule insert" on public.capsule;
drop policy if exists "capsule update" on public.capsule;

create policy "capsule read" on public.capsule
  for select to anon using (true);

create policy "capsule insert" on public.capsule
  for insert to anon with check (true);

create policy "capsule update" on public.capsule
  for update to anon using (true) with check (true);

grant select, insert, update on public.capsule to anon;

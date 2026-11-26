-- Run this once in Supabase → SQL Editor → New query → Run.
-- Creates a public bucket for audio uploaded from the page.

insert into storage.buckets (id, name, public, file_size_limit)
values ('audio', 'audio', true, 20971520)
on conflict (id) do update set public = true, file_size_limit = 20971520;

drop policy if exists "audio read" on storage.objects;
drop policy if exists "audio insert" on storage.objects;
drop policy if exists "audio update" on storage.objects;
drop policy if exists "audio delete" on storage.objects;

create policy "audio read" on storage.objects
  for select to anon using (bucket_id = 'audio');

create policy "audio insert" on storage.objects
  for insert to anon with check (bucket_id = 'audio');

create policy "audio update" on storage.objects
  for update to anon using (bucket_id = 'audio') with check (bucket_id = 'audio');

create policy "audio delete" on storage.objects
  for delete to anon using (bucket_id = 'audio');

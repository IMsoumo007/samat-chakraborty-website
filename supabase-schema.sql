-- Run this entire file in Supabase SQL Editor.
-- 1) Create tables
create extension if not exists pgcrypto;

create table if not exists public.news (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text,
  location text,
  excerpt text,
  content text not null,
  featured_image_url text,
  published boolean not null default false,
  published_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.media (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  caption text,
  type text not null check (type in ('photos','videos')),
  file_url text not null,
  storage_path text not null,
  published boolean not null default false,
  created_at timestamptz not null default now()
);

-- 2) Enable RLS
alter table public.news enable row level security;
alter table public.media enable row level security;

-- 3) Public visitors can only read published content
drop policy if exists "Public read published news" on public.news;
create policy "Public read published news" on public.news
for select using (published = true);

drop policy if exists "Public read published media" on public.media;
create policy "Public read published media" on public.media
for select using (published = true);

-- 4) Authenticated admin account can manage content.
-- IMPORTANT: create your admin user in Supabase Authentication first.
drop policy if exists "Authenticated manage news" on public.news;
create policy "Authenticated manage news" on public.news
for all to authenticated using (true) with check (true);

drop policy if exists "Authenticated manage media" on public.media;
create policy "Authenticated manage media" on public.media
for all to authenticated using (true) with check (true);

-- 5) Storage buckets
insert into storage.buckets (id, name, public) values ('photos','photos',true)
on conflict (id) do nothing;
insert into storage.buckets (id, name, public) values ('videos','videos',true)
on conflict (id) do nothing;

-- Public visitors can read files.
drop policy if exists "Public read photos" on storage.objects;
create policy "Public read photos" on storage.objects
for select using (bucket_id = 'photos');

drop policy if exists "Public read videos" on storage.objects;
create policy "Public read videos" on storage.objects
for select using (bucket_id = 'videos');

-- Authenticated admins can upload/update/delete files.
drop policy if exists "Authenticated manage photos" on storage.objects;
create policy "Authenticated manage photos" on storage.objects
for all to authenticated using (bucket_id = 'photos') with check (bucket_id = 'photos');

drop policy if exists "Authenticated manage videos" on storage.objects;
create policy "Authenticated manage videos" on storage.objects
for all to authenticated using (bucket_id = 'videos') with check (bucket_id = 'videos');


-- 6) Editable social-media links
create table if not exists public.social_links (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  platform text not null,
  url text not null,
  sort_order integer not null default 0,
  enabled boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.social_links enable row level security;

drop policy if exists "Public read enabled social links" on public.social_links;
create policy "Public read enabled social links" on public.social_links
for select using (enabled = true);

drop policy if exists "Authenticated manage social links" on public.social_links;
create policy "Authenticated manage social links" on public.social_links
for all to authenticated using (true) with check (true);

-- Optional starter records. The Facebook URL is intentionally blank/not invented;
-- enter the exact official profile URL from the Admin dashboard.

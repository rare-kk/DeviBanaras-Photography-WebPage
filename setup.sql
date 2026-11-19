-- Run in Supabase SQL Editor. Replace YOUR_EMAIL@example.com with your actual account email.
create extension if not exists pgcrypto;
create table if not exists public.posts (
 id uuid primary key default gen_random_uuid(), author_id uuid not null references auth.users(id) on delete cascade,
 kind text not null check(kind in ('photo','travel')), title text not null check(length(title) between 1 and 120),
 location text, body text, image_url text not null, image_path text not null,
 created_at timestamptz not null default now()
);
create table if not exists public.comments (
 id uuid primary key default gen_random_uuid(), post_id uuid not null references public.posts(id) on delete cascade,
 author_id uuid not null references auth.users(id) on delete cascade,
 display_name text, body text not null check(length(body) between 1 and 2000),
 created_at timestamptz not null default now()
);
create table if not exists public.inquiries (
 id uuid primary key default gen_random_uuid(), name text not null, email text not null,
 topic text not null, message text not null, created_at timestamptz not null default now()
);
alter table public.posts enable row level security;
alter table public.comments enable row level security;
alter table public.inquiries enable row level security;
create policy "Public may read posts" on public.posts for select to anon,authenticated using(true);
create policy "Signed-in users publish" on public.posts for insert to authenticated with check(author_id=auth.uid());
create policy "Authors delete posts" on public.posts for delete to authenticated using(author_id=auth.uid());
create policy "Public may read comments" on public.comments for select to anon,authenticated using(true);
create policy "Signed-in users comment" on public.comments for insert to authenticated with check(author_id=auth.uid());
create policy "Authors delete comments" on public.comments for delete to authenticated using(author_id=auth.uid());
create policy "Visitors can submit inquiries" on public.inquiries for insert to anon,authenticated with check(
 length(name) between 1 and 100 and length(email) between 3 and 254 and length(topic) between 1 and 100 and length(message) between 1 and 5000
);
-- Only owner can read inquiries in Supabase client; owner may also read them in SQL dashboard.
create policy "Owner can read inquiries" on public.inquiries for select to authenticated using((auth.jwt()->>'email')='YOUR_EMAIL@example.com');
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values('portfolio','portfolio',true,8388608,array['image/jpeg','image/png','image/webp'])
on conflict(id) do update set public=true,file_size_limit=8388608,allowed_mime_types=array['image/jpeg','image/png','image/webp'];
create policy "Public view portfolio images" on storage.objects for select to anon,authenticated using(bucket_id='portfolio');
create policy "Signed-in users upload to own folder" on storage.objects for insert to authenticated with check(bucket_id='portfolio' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "Authors remove their own images" on storage.objects for delete to authenticated using(bucket_id='portfolio' and (storage.foldername(name))[1]=auth.uid()::text);

alter table public.staff_profiles add column if not exists username text;

update public.staff_profiles set role = 'manager' where role in ('counter','admin');

update public.staff_profiles p
set username = lower(coalesce(nullif(u.raw_user_meta_data ->> 'username',''), split_part(u.email,'@',1)))
from auth.users u
where p.id = u.id and p.username is null;

create unique index if not exists staff_profiles_username_key
on public.staff_profiles(lower(username)) where username is not null;

drop policy if exists "manager can read staff profiles" on public.staff_profiles;
create policy "manager can read staff profiles" on public.staff_profiles
  for select to authenticated using (public.current_staff_role() = 'manager');

create or replace function public.handle_new_staff_user()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  insert into public.staff_profiles (id, full_name, username, role)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data ->> 'full_name',''), split_part(new.email,'@',1), 'Staff'),
    lower(coalesce(nullif(new.raw_user_meta_data ->> 'username',''), split_part(new.email,'@',1))),
    'server'
  )
  on conflict (id) do update set
    full_name = excluded.full_name,
    username = coalesce(public.staff_profiles.username, excluded.username);
  return new;
end;
$$;

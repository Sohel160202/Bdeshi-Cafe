-- Avoid RLS recursion when policies call current_staff_role().
-- The helper only returns the authenticated user's own role and is not exposed
-- as a general data access function.
create or replace function public.current_staff_role()
returns public.staff_role
language sql
stable
security definer
set search_path = public
as $$
  select role
  from public.staff_profiles
  where id = (select auth.uid())
    and active = true
$$;

revoke all on function public.current_staff_role() from public;
revoke execute on function public.current_staff_role() from anon;
grant execute on function public.current_staff_role() to authenticated;

drop policy if exists "staff can read menu" on public.menu_items;
create policy "staff can read menu" on public.menu_items
  for select to authenticated
  using (available = true or public.current_staff_role() in ('manager','counter','admin'));

drop policy if exists "servers and counter can read orders" on public.orders;
create policy "servers and counter can read orders" on public.orders
  for select to authenticated
  using (public.current_staff_role() in ('server','manager','counter','admin'));

drop policy if exists "servers can create orders" on public.orders;
create policy "servers can create orders" on public.orders
  for insert to authenticated
  with check (created_by = (select auth.uid()) and public.current_staff_role() in ('server','manager','counter','admin'));

drop policy if exists "counter can update orders" on public.orders;
create policy "counter can update orders" on public.orders
  for update to authenticated
  using (public.current_staff_role() in ('manager','counter','admin'))
  with check (public.current_staff_role() in ('manager','counter','admin'));

drop policy if exists "staff can read order items" on public.order_items;
create policy "staff can read order items" on public.order_items
  for select to authenticated
  using (public.current_staff_role() in ('server','manager','counter','admin'));

drop policy if exists "servers can create order items" on public.order_items;
create policy "servers can create order items" on public.order_items
  for insert to authenticated
  with check (public.current_staff_role() in ('server','manager','counter','admin'));

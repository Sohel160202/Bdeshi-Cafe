create index if not exists order_items_order_id_idx on public.order_items(order_id);
create index if not exists order_items_menu_item_id_idx on public.order_items(menu_item_id);
create index if not exists orders_created_by_idx on public.orders(created_by);

drop policy if exists "staff can read own profile" on public.staff_profiles;
create policy "staff can read own profile" on public.staff_profiles
  for select to authenticated
  using (id = (select auth.uid()));

drop policy if exists "servers can create orders" on public.orders;
create policy "servers can create orders" on public.orders
  for insert to authenticated
  with check (created_by = (select auth.uid()) and public.current_staff_role() in ('server','counter','admin'));

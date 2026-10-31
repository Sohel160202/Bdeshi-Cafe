-- Counter staff may edit an order only while it is still new.
drop policy if exists "counter can add order items before preparation" on public.order_items;
create policy "counter can add order items before preparation"
  on public.order_items for insert to authenticated
  with check (
    public.current_staff_role() in ('manager','counter','admin')
    and exists (select 1 from public.orders o where o.id = order_id and o.status = 'new')
  );

drop policy if exists "counter can edit order items before preparation" on public.order_items;
create policy "counter can edit order items before preparation"
  on public.order_items for update to authenticated
  using (
    public.current_staff_role() in ('manager','counter','admin')
    and exists (select 1 from public.orders o where o.id = order_id and o.status = 'new')
  )
  with check (
    public.current_staff_role() in ('manager','counter','admin')
    and exists (select 1 from public.orders o where o.id = order_id and o.status = 'new')
  );

drop policy if exists "counter can remove order items before preparation" on public.order_items;
create policy "counter can remove order items before preparation"
  on public.order_items for delete to authenticated
  using (
    public.current_staff_role() in ('manager','counter','admin')
    and exists (select 1 from public.orders o where o.id = order_id and o.status = 'new')
  );

drop policy if exists "manager can read staff profiles" on public.staff_profiles;
create policy "manager can read staff profiles"
  on public.staff_profiles for select to authenticated
  using (public.current_staff_role() in ('manager','admin'));

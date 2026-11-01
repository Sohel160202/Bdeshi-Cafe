-- Servers may adjust their own order while it is still new.
drop policy if exists "servers can create order items" on public.order_items;
create policy "servers can create order items"
  on public.order_items for insert to authenticated
  with check (
    (
      public.current_staff_role() = 'server'
      and exists (
        select 1 from public.orders o
        where o.id = order_id and o.created_by = (select auth.uid()) and o.status = 'new'
      )
    )
    or public.current_staff_role() in ('manager','counter','admin')
  );

drop policy if exists "server can edit own order items" on public.order_items;
create policy "server can edit own order items"
  on public.order_items for update to authenticated
  using (
    public.current_staff_role() = 'server'
    and exists (
      select 1 from public.orders o
      where o.id = order_id and o.created_by = (select auth.uid()) and o.status = 'new'
    )
  )
  with check (
    public.current_staff_role() = 'server'
    and exists (
      select 1 from public.orders o
      where o.id = order_id and o.created_by = (select auth.uid()) and o.status = 'new'
    )
  );

drop policy if exists "server can remove own order items" on public.order_items;
create policy "server can remove own order items"
  on public.order_items for delete to authenticated
  using (
    public.current_staff_role() = 'server'
    and exists (
      select 1 from public.orders o
      where o.id = order_id and o.created_by = (select auth.uid()) and o.status = 'new'
    )
  );

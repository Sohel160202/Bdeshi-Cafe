-- Managers can maintain the menu while preserving order history.
drop policy if exists "manager can insert menu items" on public.menu_items;
create policy "manager can insert menu items"
  on public.menu_items for insert to authenticated
  with check (public.current_staff_role() = 'manager');

drop policy if exists "manager can update menu items" on public.menu_items;
create policy "manager can update menu items"
  on public.menu_items for update to authenticated
  using (public.current_staff_role() = 'manager')
  with check (public.current_staff_role() = 'manager');

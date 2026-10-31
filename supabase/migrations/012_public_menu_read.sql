-- The public café website may display only currently available menu items.
drop policy if exists "public can read available menu" on public.menu_items;
create policy "public can read available menu"
  on public.menu_items for select to anon
  using (available = true);

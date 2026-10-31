-- Only managers/admins may permanently delete completed or cancelled orders.
-- order_items are removed automatically by the order foreign key's ON DELETE CASCADE.
drop policy if exists "manager can delete historical orders" on public.orders;
create policy "manager can delete historical orders"
  on public.orders for delete to authenticated
  using (
    public.current_staff_role() in ('manager','admin')
    and status in ('served','paid','cancelled')
  );

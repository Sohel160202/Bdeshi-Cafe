create policy "servers can empty active tables"
on public.orders
for update
to authenticated
using (
  current_staff_role() = 'server'::staff_role
  and status = any (array[
    'new'::order_status,
    'preparing'::order_status,
    'ready'::order_status
  ])
)
with check (
  current_staff_role() = 'server'::staff_role
  and status = 'served'::order_status
);

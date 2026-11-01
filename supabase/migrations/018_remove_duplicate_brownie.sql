-- Remove the duplicate cake-menu copy of Brownie with Ice Cream.
delete from public.menu_items
where name = 'Brownie with Ice Cream - Cake Menu'
  and not exists (
    select 1 from public.order_items oi where oi.menu_item_id = public.menu_items.id
  );
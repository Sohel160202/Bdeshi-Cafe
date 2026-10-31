-- The menu remains editable at runtime. Keep the historical item name and price on the order even when an item was entered from the offline fallback.
alter table public.order_items
  alter column menu_item_id drop not null;

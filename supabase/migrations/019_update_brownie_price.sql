-- Update Brownie to the cafe's corrected price.
update public.menu_items
set price = 170
where name = 'Brownie'
  and price = 160;

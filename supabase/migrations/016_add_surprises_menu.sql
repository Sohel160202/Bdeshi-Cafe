-- Restore the Surprises section from the café menu.
update public.menu_items
set category = 'Surprises', sort_order = 1510
where name = 'Creamy Chicken Mushroom Soup';

insert into public.menu_items (name, category, price, station, sort_order, available)
select v.name, 'Surprises', v.price, 'kitchen', v.sort_order, true
from (values
  ('Rice Chicken-Steak Mashed Potatoes & Mushrooms', 380, 1500),
  ('Creamy Chicken Mushroom Soup', 390, 1510),
  ('Chicken Cutlet', 300, 1520),
  ('Mexican High Protein Salad', 390, 1530)
) as v(name, price, sort_order)
where not exists (
  select 1 from public.menu_items m where lower(m.name) = lower(v.name)
);
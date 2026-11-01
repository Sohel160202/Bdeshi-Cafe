-- Correct menu variants and add missing Freddo items.
update public.menu_items
set name = 'Matcha Latte (Non Coffee)'
where name = 'Matcha Latte' and category = 'Non-Coffee';

update public.menu_items
set name = 'Dark Mocha (Flavour Based)'
where name = 'Dark Mocha' and category = 'Flavour Coffee';

insert into public.menu_items (name, category, price, station, sort_order, available)
select v.name, v.category, v.price, v.station::station_type, v.sort_order, true
from (values
  ('Spicy Garlic Mushroom', 'Specials', 350, 'kitchen', 150),
  ('Matcha Latte (Freddos / Iced Coffee)', 'Iced Freddos', 350, 'drinks', 560),
  ('Dark Mocha (Iced Freddos)', 'Iced Freddos', 350, 'drinks', 570),
  ('Irish Cream Freddo Latte', 'Iced Freddos', 290, 'drinks', 580),
  ('Iced Caramel Freddo', 'Iced Freddos', 270, 'drinks', 590),
  ('Freddo Latte Hazelnut', 'Iced Freddos', 270, 'drinks', 600)
) as v(name, category, price, station, sort_order)
where not exists (
  select 1 from public.menu_items m where lower(m.name) = lower(v.name)
);
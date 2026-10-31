insert into public.menu_items (name, category, price, station, sort_order) values
('Cappuccino','Coffee',210,'drinks',10),
('Americano','Coffee',160,'drinks',20),
('Cafe Latte','Coffee',210,'drinks',30),
('Espresso','Coffee',150,'drinks',40),
('Lemon Iced Tea','Drinks',220,'drinks',50),
('Mocha Freddo','Drinks',290,'drinks',60),
('Matcha Latte','Drinks',350,'drinks',70),
('Caramel Freddo','Drinks',270,'drinks',80),
('Beef Pepperoni Pizza','Food',600,'kitchen',100),
('Chicken Mushroom Pasta','Food',320,'kitchen',110),
('Chicken Wrap Shawarma','Food',290,'kitchen',120),
('Grilled Chicken Burger','Food',220,'kitchen',130),
('Traditional Club Sandwich','Sandwiches',300,'kitchen',140),
('B-deshi Special Beef Sandwich','Sandwiches',340,'kitchen',150),
('Cheesecake','Dessert',280,'kitchen',160),
('Brownie with Ice Cream','Dessert',230,'kitchen',170)
on conflict do nothing;

create or replace function public.set_updated_at() returns trigger
language plpgsql security invoker set search_path = public
as $$ begin new.updated_at = now(); return new; end; $$;

drop trigger if exists orders_set_updated_at on public.orders;
create trigger orders_set_updated_at before update on public.orders
for each row execute function public.set_updated_at();

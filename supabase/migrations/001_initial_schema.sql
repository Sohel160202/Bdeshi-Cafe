create type public.staff_role as enum ('server', 'counter', 'admin');
create type public.order_status as enum ('new', 'preparing', 'ready', 'served', 'paid', 'cancelled');
create type public.station_type as enum ('kitchen', 'drinks');

create table public.staff_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  role public.staff_role not null default 'server',
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.menu_items (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null,
  price integer not null check (price >= 0),
  station public.station_type not null,
  available boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number bigint generated always as identity unique,
  table_number integer not null check (table_number between 1 and 11),
  created_by uuid not null references public.staff_profiles(id),
  status public.order_status not null default 'new',
  note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  menu_item_id uuid not null references public.menu_items(id),
  item_name text not null,
  unit_price integer not null check (unit_price >= 0),
  quantity integer not null check (quantity > 0),
  station public.station_type not null,
  note text
);

alter table public.staff_profiles enable row level security;
alter table public.menu_items enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

create or replace function public.current_staff_role() returns public.staff_role
language sql stable security invoker set search_path = public
as $$ select role from public.staff_profiles where id = auth.uid() and active = true $$;

create policy "staff can read own profile" on public.staff_profiles for select to authenticated using (id = auth.uid());
create policy "staff can read menu" on public.menu_items for select to authenticated using (available = true or public.current_staff_role() in ('counter','admin'));
create policy "servers and counter can read orders" on public.orders for select to authenticated using (public.current_staff_role() in ('server','counter','admin'));
create policy "servers can create orders" on public.orders for insert to authenticated with check (created_by = auth.uid() and public.current_staff_role() in ('server','counter','admin'));
create policy "counter can update orders" on public.orders for update to authenticated using (public.current_staff_role() in ('counter','admin')) with check (public.current_staff_role() in ('counter','admin'));
create policy "staff can read order items" on public.order_items for select to authenticated using (public.current_staff_role() in ('server','counter','admin'));
create policy "servers can create order items" on public.order_items for insert to authenticated with check (public.current_staff_role() in ('server','counter','admin'));

alter publication supabase_realtime add table public.orders;
alter publication supabase_realtime add table public.order_items;

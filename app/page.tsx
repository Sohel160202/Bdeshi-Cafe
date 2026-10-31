"use client";

import { useMemo, useState } from "react";

type Station = "kitchen" | "drinks";
type MenuItem = { id: string; name: string; category: string; price: number; station: Station };
type CartLine = MenuItem & { quantity: number };

const menu: MenuItem[] = [
  { id:"cappuccino", name:"Cappuccino", category:"Coffee", price:210, station:"drinks" },
  { id:"americano", name:"Americano", category:"Coffee", price:160, station:"drinks" },
  { id:"lemon-tea", name:"Lemon Iced Tea", category:"Drinks", price:220, station:"drinks" },
  { id:"mocha-freddo", name:"Mocha Freddo", category:"Drinks", price:290, station:"drinks" },
  { id:"matcha", name:"Matcha Latte", category:"Drinks", price:350, station:"drinks" },
  { id:"pepperoni", name:"Beef Pepperoni Pizza", category:"Food", price:600, station:"kitchen" },
  { id:"pasta", name:"Chicken Mushroom Pasta", category:"Food", price:320, station:"kitchen" },
  { id:"shawarma", name:"Chicken Wrap Shawarma", category:"Food", price:290, station:"kitchen" },
  { id:"burger", name:"Grilled Chicken Burger", category:"Food", price:220, station:"kitchen" },
  { id:"club", name:"Traditional Club Sandwich", category:"Sandwiches", price:300, station:"kitchen" },
  { id:"cheesecake", name:"Cheesecake", category:"Dessert", price:280, station:"kitchen" },
];

const money = (n:number) => `৳${n.toLocaleString("en-BD")}`;

export default function Home() {
  const [table, setTable] = useState<number | null>(null);
  const [category, setCategory] = useState("All");
  const [cart, setCart] = useState<CartLine[]>([]);
  const [note, setNote] = useState("");
  const categories = ["All", ...Array.from(new Set(menu.map((item) => item.category)))];
  const filtered = useMemo(() => category === "All" ? menu : menu.filter((item) => item.category === category), [category]);
  const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);
  const add = (item: MenuItem) => setCart((lines) => lines.some((line) => line.id === item.id) ? lines.map((line) => line.id === item.id ? {...line, quantity:line.quantity+1} : line) : [...lines, {...item, quantity:1}]);
  const change = (id:string, delta:number) => setCart((lines) => lines.flatMap((line) => line.id === id ? (line.quantity + delta > 0 ? [{...line, quantity:line.quantity+delta}] : []) : [line]));
  const submit = () => { if (!table || cart.length === 0) return; alert(`Demo order submitted for Table ${table}. Next step is connecting this screen to Supabase.`); setCart([]); setNote(""); };

  return <div className="shell">
    <aside className="sidebar"><div className="brand">B-deshi <span>Café</span></div><div className="role">SERVER ORDERING</div><nav className="nav"><button className="active">New order</button><button>My active orders</button><button>Tables</button></nav></aside>
    <main className="main">
      <div className="topbar"><div><h1>Take an order</h1><div className="subtle">Choose a table, add items, then send the order to the counter.</div></div><div className="staff"><div className="avatar">SM</div><div><b>Sheikh Sohel</b><div className="subtle">Server</div></div></div></div>
      <div className="grid"><section className="panel"><h2>Select table</h2><div className="table-grid">{Array.from({length:11}, (_,i) => i+1).map((n)=><button key={n} onClick={()=>setTable(n)} className={`table-btn ${table===n?"selected":""}`}>Table {n}</button>)}</div><h2>Menu</h2><div className="categories">{categories.map((cat)=><button key={cat} onClick={()=>setCategory(cat)} className={`cat ${category===cat?"selected":""}`}>{cat}</button>)}</div><div className="menu">{filtered.map((item)=><div className="item" key={item.id}><div><div className="item-name">{item.name}</div><div className="item-station">{item.station === "drinks" ? "Coffee / Drinks" : "Kitchen"}</div></div><div><div className="price">{money(item.price)}</div><button className="add" onClick={()=>add(item)}>Add</button></div></div>)}</div></section>
      <aside className="panel"><div className="order-head"><h2>Current order</h2><span className="subtle">{table ? `Table ${table}` : "No table"}</span></div>{cart.length===0 ? <div className="empty">Select a table and add menu items.</div> : <>{cart.map((item)=><div className="cart-row" key={item.id}><div><div className="cart-name">{item.name}</div><div className="cart-meta">{money(item.price)} each · {item.station}</div></div><div className="qty"><button onClick={()=>change(item.id,-1)}>−</button><b>{item.quantity}</b><button onClick={()=>change(item.id,1)}>+</button></div></div>)}<div className="total"><span>Total</span><span>{money(total)}</span></div><textarea className="note" rows={3} placeholder="Order note (optional)" value={note} onChange={(e)=>setNote(e.target.value)} /><br/><br/><button className="submit" disabled={!table || cart.length===0} onClick={submit}>Send order to counter</button></>}</aside></div>
    </main>
  </div>;
}

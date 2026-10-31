# B-deshi Café POS

Initial foundation for a restaurant table-ordering and KOT system.

## Current foundation

- Next.js app deployed through Vercel-compatible structure
- Server ordering screen for tables 1–11
- Menu items assigned to either Kitchen or Coffee/Drinks
- Supabase schema with staff roles, orders, order items, RLS, and Realtime tables
- 80mm thermal-printing workflow planned for the counter dashboard

## Next implementation phase

1. Connect the app to the café's Supabase project.
2. Add individual staff authentication and role-aware routes.
3. Replace demo menu data with the menu database.
4. Build the live counter dashboard.
5. Add KOT print layouts for kitchen and drinks.
6. Test with the exact thermal printer model at the café.

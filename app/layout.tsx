import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "B-deshi Café POS",
  description: "Table ordering and kitchen KOT management for B-deshi Café",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}

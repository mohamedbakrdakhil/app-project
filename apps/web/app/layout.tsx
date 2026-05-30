import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Masteri",
  description: "Apprenez les matières médicales, niveau par niveau.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr">
      <body>{children}</body>
    </html>
  );
}

import type { Metadata, Viewport } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: { default: "Masteri", template: "%s | Masteri" },
  description: "Apprenez les matières médicales en sessions courtes, interactives et mesurables.",
  keywords: ["médecine", "anatomie", "apprentissage", "étudiants", "QCM", "révisions"],
  authors: [{ name: "Masteri" }],
  robots: { index: false, follow: false },
  manifest: "/manifest.json",
  appleWebApp: {
    capable: true,
    statusBarStyle: "black-translucent",
    title: "Masteri",
  },
  openGraph: {
    title: "Masteri",
    description: "Maîtrisez les sciences médicales, niveau par niveau.",
    type: "website",
    locale: "fr_FR",
  },
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  themeColor: "#ff4d6d",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr">
      <head>
        <script dangerouslySetInnerHTML={{__html: `
  if (typeof window !== 'undefined' && 'serviceWorker' in navigator) {
    window.addEventListener('load', function() {
      navigator.serviceWorker.register('/sw.js');
    });
  }
`}} />
      </head>
      <body>{children}</body>
    </html>
  );
}

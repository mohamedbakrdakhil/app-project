"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";

const NAV = [
  { href: "/home", label: "Accueil", icon: "🏠" },
  { href: "/league", label: "Ligue", icon: "🏆" },
  { href: "/reviews", label: "Révisions", icon: "🔄" },
  { href: "/stats", label: "Stats", icon: "📊" },
  { href: "/profile", label: "Profil", icon: "👤" },
];

export default function BottomNav() {
  const pathname = usePathname();
  return (
    <nav aria-label="Navigation principale" className="fixed bottom-0 left-0 right-0 flex border-t" style={{ backgroundColor: "var(--bg-secondary)", borderColor: "var(--border-soft)" }}>
      {NAV.map((item) => (
        <Link
          key={item.href}
          href={item.href}
          aria-current={pathname === item.href ? "page" : undefined}
          className="flex-1 flex flex-col items-center py-3 text-xs gap-1 transition-colors"
          style={{ color: pathname === item.href ? "var(--anatomy)" : "var(--text-muted)" }}
        >
          <span>{item.icon}</span>
          <span>{item.label}</span>
        </Link>
      ))}
    </nav>
  );
}

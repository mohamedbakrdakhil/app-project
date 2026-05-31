import Link from "next/link";
import NotificationBell from "./NotificationBell";

export default function Header() {
  return (
    <header className="sticky top-0 z-10 flex items-center justify-between px-4 py-3 border-b" style={{ backgroundColor: "var(--bg-secondary)", borderColor: "var(--border-soft)" }}>
      <Link href="/home" className="text-lg font-bold" style={{ color: "var(--anatomy)" }}>
        Masteri
      </Link>
      <NotificationBell />
    </header>
  );
}

import Link from "next/link";
import NotificationBell from "./NotificationBell";
import SearchBar from "./SearchBar";

export default function Header() {
  return (
    <header className="sticky top-0 z-10 flex items-center gap-3 px-4 py-3 border-b" style={{ backgroundColor: "var(--bg-secondary)", borderColor: "var(--border-soft)" }}>
      <Link href="/home" className="text-lg font-bold flex-shrink-0" style={{ color: "var(--anatomy)" }}>
        M
      </Link>
      <SearchBar />
      <NotificationBell />
    </header>
  );
}

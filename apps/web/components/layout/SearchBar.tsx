"use client";
import { useState, useEffect, useRef } from "react";
import { useRouter } from "next/navigation";

type SearchResult = {
  type: "subject" | "level";
  id: string;
  title: string;
  icon: string;
  href: string;
};

export default function SearchBar() {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<SearchResult[]>([]);
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const ref = useRef<HTMLDivElement>(null);
  const router = useRouter();

  useEffect(() => {
    if (query.length < 2) { setResults([]); return; }
    const t = setTimeout(async () => {
      setLoading(true);
      try {
        const res = await fetch(`/api/search?q=${encodeURIComponent(query)}`);
        if (!res.ok) { setResults([]); return; }
        const data = await res.json() as { results: SearchResult[] };
        setResults(data.results ?? []);
        setOpen(true);
      } catch {
        setResults([]);
      } finally {
        setLoading(false);
      }
    }, 300);
    return () => clearTimeout(t);
  }, [query]);

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, []);

  const handleSelect = (href: string) => {
    setQuery("");
    setOpen(false);
    router.push(href);
  };

  return (
    <div ref={ref} className="relative flex-1 max-w-xs">
      <input
        type="search"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        onFocus={() => results.length > 0 && setOpen(true)}
        placeholder="Rechercher..."
        className="w-full px-3 py-1.5 rounded-xl text-sm outline-none"
        style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)", color: "var(--text-primary)" }}
      />
      {open && results.length > 0 && (
        <div
          className="absolute top-full left-0 right-0 mt-1 rounded-xl overflow-hidden z-50 shadow-lg"
          style={{ backgroundColor: "var(--bg-secondary)", border: "1px solid var(--border-soft)" }}
        >
          {results.map((r) => (
            <button
              key={r.id}
              onClick={() => handleSelect(r.href)}
              className="w-full flex items-center gap-2 px-3 py-2 text-left text-sm hover:opacity-80 transition-opacity"
              style={{ color: "var(--text-primary)" }}
            >
              <span>{r.icon}</span>
              <span className="flex-1 truncate">{r.title}</span>
              <span className="text-xs flex-shrink-0" style={{ color: "var(--text-muted)" }}>
                {r.type === "subject" ? "Matière" : "Niveau"}
              </span>
            </button>
          ))}
        </div>
      )}
      {loading && (
        <div className="absolute right-2 top-1/2 -translate-y-1/2">
          <div className="w-3 h-3 rounded-full border-2 animate-spin" style={{ borderColor: "var(--anatomy)", borderTopColor: "transparent" }} />
        </div>
      )}
    </div>
  );
}

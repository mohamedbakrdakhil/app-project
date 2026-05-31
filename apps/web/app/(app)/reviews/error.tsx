"use client";
export default function Error({ error, reset }: { error: Error & { digest?: string }; reset: () => void }) {
  return (
    <div className="p-6 text-center space-y-3">
      <div className="text-3xl">⚠️</div>
      <p className="font-semibold" style={{ color: "var(--text-primary)" }}>Erreur de chargement</p>
      <p className="text-sm" style={{ color: "var(--text-muted)" }}>{error.message}</p>
      <button onClick={reset} className="text-sm px-4 py-2 rounded-xl" style={{ backgroundColor: "var(--bg-card)", color: "var(--anatomy)", border: "1px solid var(--border-soft)" }}>
        Réessayer
      </button>
    </div>
  );
}

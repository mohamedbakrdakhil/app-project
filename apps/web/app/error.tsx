"use client";
import { useEffect } from "react";

export default function GlobalError({ error, reset }: { error: Error & { digest?: string }; reset: () => void }) {
  useEffect(() => {
    console.error(error);
  }, [error]);

  return (
    <div className="min-h-screen flex items-center justify-center p-4" style={{ backgroundColor: "var(--bg-primary)" }}>
      <div className="text-center space-y-4 max-w-sm">
        <div className="text-5xl">💥</div>
        <h2 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>Quelque chose s&apos;est mal passé</h2>
        <p className="text-sm" style={{ color: "var(--text-muted)" }}>Une erreur inattendue est survenue.</p>

        <button
          onClick={reset}
          className="px-6 py-3 rounded-xl font-semibold text-white"
          style={{ backgroundColor: "var(--anatomy)" }}
        >
          Réessayer
        </button>
      </div>
    </div>
  );
}

import Link from "next/link";

export default function NotFound() {
  return (
    <div className="min-h-screen flex items-center justify-center p-4" style={{ backgroundColor: "var(--bg-primary)" }}>
      <div className="text-center space-y-4">
        <div className="text-6xl">🔍</div>
        <h2 className="text-2xl font-bold" style={{ color: "var(--text-primary)" }}>Page introuvable</h2>
        <p className="text-sm" style={{ color: "var(--text-muted)" }}>Cette page n&apos;existe pas.</p>
        <Link href="/home" className="inline-block px-6 py-3 rounded-xl font-semibold text-white" style={{ backgroundColor: "var(--anatomy)" }}>
          Retour à l&apos;accueil
        </Link>
      </div>
    </div>
  );
}

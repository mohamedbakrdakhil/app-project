import Link from "next/link";

export default function SubjectNotFound() {
  return (
    <div className="text-center space-y-4 py-16">
      <div className="text-4xl">🔍</div>
      <p className="font-semibold" style={{ color: "var(--text-primary)" }}>Matière introuvable</p>
      <Link href="/home" className="text-sm" style={{ color: "var(--anatomy)" }}>
        Retour à l&apos;accueil
      </Link>
    </div>
  );
}

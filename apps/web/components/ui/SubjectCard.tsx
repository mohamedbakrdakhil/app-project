import Link from "next/link";

interface SubjectCardProps {
  id: string;
  nameFr: string;
  icon: string;
  color: string;
  descriptionFr?: string | null;
}

export default function SubjectCard({ id, nameFr, icon, color, descriptionFr }: SubjectCardProps) {
  return (
    <Link href={`/subject/${id}`} className="block rounded-2xl p-4 transition-all hover:scale-[1.02]" style={{ backgroundColor: "var(--bg-card)", border: `1px solid ${color}33`, boxShadow: "var(--shadow-card)" }}>
      <div className="flex items-center gap-3 mb-2">
        <span className="text-2xl">{icon}</span>
        <span className="font-semibold" style={{ color }}>{nameFr}</span>
      </div>
      {descriptionFr && <p className="text-sm" style={{ color: "var(--text-muted)" }}>{descriptionFr}</p>}
    </Link>
  );
}

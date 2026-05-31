import Link from "next/link";

interface SubjectCardProps {
  id: string;
  nameFr: string;
  icon: string;
  color: string;
  descriptionFr?: string | null;
  progressPct?: number;
  levelCount?: number;
}

export default function SubjectCard({ id, nameFr, icon, color, descriptionFr, progressPct, levelCount }: SubjectCardProps) {
  return (
    <Link href={`/subject/${id}`} className="block rounded-2xl p-4 transition-all hover:scale-[1.02]" style={{ backgroundColor: "var(--bg-card)", border: `1px solid ${color}33`, boxShadow: "var(--shadow-card)" }}>
      <div className="flex items-center gap-3 mb-2">
        <span className="text-2xl">{icon}</span>
        <span className="font-semibold" style={{ color }}>{nameFr}</span>
        {levelCount !== undefined && (
          <span className="ml-auto text-xs" style={{ color: "var(--text-muted)" }}>{levelCount} niveau{levelCount !== 1 ? "x" : ""}</span>
        )}
      </div>
      {descriptionFr && <p className="text-sm mb-2" style={{ color: "var(--text-muted)" }}>{descriptionFr}</p>}
      {progressPct !== undefined && (
        <div className="space-y-1">
          <div className="h-1.5 rounded-full overflow-hidden" style={{ backgroundColor: "var(--bg-secondary)" }}>
            <div className="h-full rounded-full transition-all" style={{ width: `${progressPct}%`, backgroundColor: color }} />
          </div>
          <p className="text-xs" style={{ color: "var(--text-muted)" }}>{progressPct}%</p>
        </div>
      )}
    </Link>
  );
}

import Link from "next/link";

type LevelState = "completed" | "available" | "locked";

interface LevelNodeProps {
  id: string;
  titleFr: string;
  orderIndex: number;
  state: LevelState;
}

export default function LevelNode({ id, titleFr, orderIndex, state }: LevelNodeProps) {
  const colors: Record<LevelState, string> = {
    completed: "#00ff78",
    available: "var(--anatomy)",
    locked: "var(--text-muted)",
  };
  const icons: Record<LevelState, string> = {
    completed: "✓",
    available: `${orderIndex}`,
    locked: "🔒",
  };

  const inner = (
    <div className="flex items-center gap-3 rounded-2xl p-4 transition-all" style={{ backgroundColor: "var(--bg-card)", border: `1px solid ${colors[state]}44`, opacity: state === "locked" ? 0.5 : 1 }}>
      <div className="w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0" style={{ backgroundColor: `${colors[state]}22`, color: colors[state], border: `2px solid ${colors[state]}` }}>
        {icons[state]}
      </div>
      <span className="font-medium" style={{ color: state === "locked" ? "var(--text-muted)" : "var(--text-primary)" }}>{titleFr}</span>
    </div>
  );

  if (state === "locked") return inner;
  return <Link href={`/lesson/${id}`}>{inner}</Link>;
}

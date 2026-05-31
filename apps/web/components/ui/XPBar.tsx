interface XPBarProps {
  current: number;
  goal: number;
}

export default function XPBar({ current, goal }: XPBarProps) {
  const pct = Math.min(100, Math.round((current / Math.max(goal, 1)) * 100));
  return (
    <div className="space-y-1">
      <div className="flex justify-between text-xs" style={{ color: "var(--text-muted)" }}>
        <span>XP du jour</span>
        <span style={{ color: "var(--xp-color)" }}>{current} / {goal}</span>
      </div>
      <div
        role="progressbar"
        aria-valuenow={current}
        aria-valuemin={0}
        aria-valuemax={goal}
        aria-label="XP du jour"
        className="h-2 rounded-full overflow-hidden"
        style={{ backgroundColor: "var(--bg-card)" }}
      >
        <div className="h-full rounded-full transition-all" style={{ width: `${pct}%`, backgroundColor: "var(--xp-color)" }} />
      </div>
    </div>
  );
}

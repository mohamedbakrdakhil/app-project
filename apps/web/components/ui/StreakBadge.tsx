interface StreakBadgeProps {
  streak: number;
}

export default function StreakBadge({ streak }: StreakBadgeProps) {
  return (
    <div className="flex items-center gap-1 px-3 py-1 rounded-full text-sm font-semibold" style={{ backgroundColor: "rgba(255,77,109,0.15)", color: "var(--streak-color)" }}>
      <span>🔥</span>
      <span>{streak}</span>
    </div>
  );
}

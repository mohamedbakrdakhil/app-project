interface DayData {
  date: string;
  xp: number;
}

interface XPHistoryChartProps {
  days: DayData[];
}

export default function XPHistoryChart({ days }: XPHistoryChartProps) {
  if (days.length === 0) return null;
  const maxXp = Math.max(...days.map((d) => d.xp), 1);

  return (
    <div className="space-y-2">
      <p className="text-sm font-medium" style={{ color: "var(--text-secondary)" }}>XP des 7 derniers jours</p>
      <div className="flex items-end gap-1 h-16">
        {days.map((d, i) => {
          const heightPct = Math.max(4, Math.round((d.xp / maxXp) * 100));
          const date = new Date(d.date);
          const label = date.toLocaleDateString("fr-FR", { weekday: "short" }).slice(0, 2);
          return (
            <div key={i} className="flex-1 flex flex-col items-center gap-1">
              <div
                className="w-full rounded-t-md transition-all"
                style={{
                  height: `${heightPct}%`,
                  backgroundColor: d.xp > 0 ? "var(--xp-color)" : "var(--bg-card)",
                  minHeight: "4px",
                }}
                title={`${d.xp} XP`}
              />
              <span className="text-xs" style={{ color: "var(--text-muted)" }}>{label}</span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

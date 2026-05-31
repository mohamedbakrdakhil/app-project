import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import Card from "@/components/ui/Card";
import XPHistoryChart from "@/components/ui/XPHistoryChart";
import { getWeekStart } from "@masteri/core";

export const dynamic = "force-dynamic";
export const metadata = { title: "Statistiques" };

export default async function StatsPage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();

  const [profileRes, streakHistoryRes, progressRes, questionAttemptsRes, weeklyRes, allLevelsRes] = await Promise.all([
    admin.from("profiles").select("streak, total_xp, daily_goal").eq("id", user.id).single(),
    admin.from("streak_history").select("activity_date, xp_earned, levels_completed").eq("user_id", user.id).order("activity_date", { ascending: false }).limit(30),
    admin.from("user_progress").select("level_id, is_completed, best_score_percent, attempts_count").eq("user_id", user.id),
    admin.from("question_attempts").select("is_correct, answered_at").eq("user_id", user.id).order("answered_at", { ascending: false }).limit(200),
    admin.from("weekly_xp").select("xp_earned").eq("user_id", user.id).eq("week_start", getWeekStart()).maybeSingle(),
    admin.from("levels").select("id, chapter_id, chapters!inner(subject_id, subjects!inner(id, name_fr, icon, color))").eq("is_published", true),
  ]);

  const profile = profileRes.data;
  const streakHistory = streakHistoryRes.data ?? [];
  const progress = progressRes.data ?? [];
  const questionAttempts = questionAttemptsRes.data ?? [];
  const weeklyXp = weeklyRes.data?.xp_earned ?? 0;
  const allLevels = allLevelsRes.data ?? [];

  const days: { date: string; xp: number }[] = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date(Date.now() - i * 86400000).toISOString().split("T")[0]!;
    const found = streakHistory.find((s) => s.activity_date === d);
    days.push({ date: d, xp: found?.xp_earned ?? 0 });
  }

  const totalAnswers = questionAttempts.length;
  const correctAnswers = questionAttempts.filter((q) => q.is_correct).length;
  const accuracy = totalAnswers > 0 ? Math.round((correctAnswers / totalAnswers) * 100) : 0;

  const completedLevels = progress.filter((p) => p.is_completed).length;
  const totalAttempts = progress.reduce((sum, p) => sum + (p.attempts_count ?? 0), 0);
  const avgScore = progress.length > 0
    ? Math.round(progress.reduce((sum, p) => sum + (p.best_score_percent ?? 0), 0) / progress.length)
    : 0;

  const activityDates = new Set(streakHistory.map((s) => s.activity_date as string));

  // Per-subject progress
  const completedIds = new Set(progress.filter((p) => p.is_completed).map((p) => p.level_id));

  type SubjectStat = { id: string; name: string; icon: string; color: string; total: number; completed: number };
  const subjectStats = new Map<string, SubjectStat>();

  for (const level of allLevels) {
    const chapter = level.chapters as unknown as { subject_id: string; subjects: { id: string; name_fr: string; icon: string; color: string } } | null;
    if (!chapter) continue;
    const s = chapter.subjects;
    if (!subjectStats.has(s.id)) {
      subjectStats.set(s.id, { id: s.id, name: s.name_fr, icon: s.icon ?? "📚", color: s.color ?? "var(--anatomy)", total: 0, completed: 0 });
    }
    const stat = subjectStats.get(s.id)!;
    stat.total += 1;
    if (completedIds.has(level.id)) stat.completed += 1;
  }

  return (
    <div className="space-y-6">
      <h1 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>Statistiques</h1>

      <div className="grid grid-cols-2 gap-3">
        {[
          { label: "XP total", value: profile?.total_xp ?? 0, color: "var(--xp-color)" },
          { label: "XP cette semaine", value: weeklyXp, color: "var(--anatomy)" },
          { label: "Streak actuel", value: `🔥 ${profile?.streak ?? 0}j`, color: "var(--streak-color)" },
          { label: "Niveaux complétés", value: completedLevels, color: "var(--success)" },
          { label: "Précision", value: `${accuracy}%`, color: accuracy >= 80 ? "var(--success)" : "var(--warning)" },
          { label: "Score moyen", value: `${avgScore}%`, color: "var(--text-primary)" },
        ].map((m) => (
          <Card key={m.label} className="text-center space-y-1">
            <p className="text-2xl font-bold" style={{ color: m.color }}>{m.value}</p>
            <p className="text-xs" style={{ color: "var(--text-muted)" }}>{m.label}</p>
          </Card>
        ))}
      </div>

      <Card>
        <XPHistoryChart days={days} />
      </Card>

      <Card className="space-y-3">
        <h2 className="font-semibold text-sm" style={{ color: "var(--text-secondary)" }}>Progression par matière</h2>
        {Array.from(subjectStats.values()).map((s) => {
          const pct = s.total > 0 ? Math.round((s.completed / s.total) * 100) : 0;
          return (
            <div key={s.id} className="space-y-1">
              <div className="flex justify-between text-sm">
                <span style={{ color: "var(--text-primary)" }}>{s.icon} {s.name}</span>
                <span style={{ color: "var(--text-muted)" }}>{s.completed}/{s.total}</span>
              </div>
              <div className="h-2 rounded-full overflow-hidden" style={{ backgroundColor: "var(--bg-secondary)" }}>
                <div className="h-full rounded-full transition-all" style={{ width: `${pct}%`, backgroundColor: s.color }} />
              </div>
            </div>
          );
        })}
      </Card>

      <Card className="space-y-3">
        <h2 className="font-semibold text-sm" style={{ color: "var(--text-secondary)" }}>Activité — 30 derniers jours</h2>
        <div className="flex flex-wrap gap-1">
          {Array.from({ length: 30 }, (_, i) => {
            const d = new Date(Date.now() - (29 - i) * 86400000).toISOString().split("T")[0]!;
            const active = activityDates.has(d);
            return (
              <div
                key={d}
                className="w-6 h-6 rounded-sm"
                style={{ backgroundColor: active ? "var(--success)" : "var(--bg-secondary)" }}
                title={d}
              />
            );
          })}
        </div>
        <p className="text-xs" style={{ color: "var(--text-muted)" }}>
          {activityDates.size} jour{activityDates.size !== 1 ? "s" : ""} actif{activityDates.size !== 1 ? "s" : ""} sur 30
        </p>
      </Card>

      <Card className="space-y-2">
        <h2 className="font-semibold text-sm" style={{ color: "var(--text-secondary)" }}>Activité d&apos;apprentissage</h2>
        <div className="flex justify-between text-sm">
          <span style={{ color: "var(--text-muted)" }}>Total questions répondues</span>
          <span style={{ color: "var(--text-primary)" }}>{totalAnswers}</span>
        </div>
        <div className="flex justify-between text-sm">
          <span style={{ color: "var(--text-muted)" }}>Réponses correctes</span>
          <span style={{ color: "var(--success)" }}>{correctAnswers}</span>
        </div>
        <div className="flex justify-between text-sm">
          <span style={{ color: "var(--text-muted)" }}>Tentatives de niveaux</span>
          <span style={{ color: "var(--text-primary)" }}>{totalAttempts}</span>
        </div>
      </Card>
    </div>
  );
}

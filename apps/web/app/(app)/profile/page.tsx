import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import Card from "@/components/ui/Card";
import XPHistoryChart from "@/components/ui/XPHistoryChart";
import LogoutButton from "./LogoutButton";
import DailyGoalSetter from "./DailyGoalSetter";

export default async function ProfilePage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();

  const sevenDaysAgo = new Date(Date.now() - 6 * 86400000).toISOString().split("T")[0];

  const [profileRes, attemptsRes, userBadgesRes, streakHistoryRes] = await Promise.all([
    admin.from("profiles").select("full_name, email, streak, total_xp, current_league_tier, daily_goal").eq("id", user.id).single(),
    admin.from("question_attempts").select("question_key, is_correct").eq("user_id", user.id).limit(500),
    admin.from("user_badges").select("badge_id, earned_at, badges(name_fr, description_fr, icon)").eq("user_id", user.id).order("earned_at", { ascending: false }),
    admin.from("streak_history").select("activity_date, xp_earned").eq("user_id", user.id).gte("activity_date", sevenDaysAgo).order("activity_date"),
  ]);

  const profile = profileRes.data;
  const questionAttempts = attemptsRes.data ?? [];
  const userBadges = userBadgesRes.data ?? [];

  // Build 7-day array filling missing days with 0
  const days: { date: string; xp: number }[] = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date(Date.now() - i * 86400000).toISOString().split("T")[0]!;
    const found = (streakHistoryRes.data ?? []).find((s) => s.activity_date === d);
    days.push({ date: d, xp: found?.xp_earned ?? 0 });
  }

  const statsMap: Record<string, { total: number; wrong: number }> = {};
  for (const row of questionAttempts) {
    const key = row.question_key as string;
    if (!statsMap[key]) statsMap[key] = { total: 0, wrong: 0 };
    statsMap[key]!.total += 1;
    if (!row.is_correct) statsMap[key]!.wrong += 1;
  }
  const hardConcepts = Object.entries(statsMap)
    .filter(([, s]) => s.wrong > 0)
    .sort(([, a], [, b]) => b.wrong - a.wrong)
    .slice(0, 5)
    .map(([key, s]) => ({ key, rate: Math.round((s.wrong / s.total) * 100) }));

  return (
    <div className="space-y-6">
      <h1 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>Profil</h1>
      <Card className="space-y-4">
        <div>
          <p className="font-semibold text-lg" style={{ color: "var(--text-primary)" }}>{profile?.full_name ?? "Étudiant"}</p>
          <p className="text-sm" style={{ color: "var(--text-muted)" }}>{profile?.email ?? user.email}</p>
        </div>
        <div className="grid grid-cols-3 gap-4 text-center">
          <div>
            <p className="text-2xl font-bold" style={{ color: "var(--xp-color)" }}>{profile?.total_xp ?? 0}</p>
            <p className="text-xs" style={{ color: "var(--text-muted)" }}>XP total</p>
          </div>
          <div>
            <p className="text-2xl font-bold" style={{ color: "var(--streak-color)" }}>🔥 {profile?.streak ?? 0}</p>
            <p className="text-xs" style={{ color: "var(--text-muted)" }}>Streak</p>
          </div>
          <div>
            <p className="text-2xl font-bold" style={{ color: "var(--text-primary)" }}>{profile?.current_league_tier ?? "bronze"}</p>
            <p className="text-xs" style={{ color: "var(--text-muted)" }}>Ligue</p>
          </div>
        </div>
        <XPHistoryChart days={days} />
      </Card>

      <Card className="space-y-3">
        <h2 className="font-semibold" style={{ color: "var(--text-secondary)" }}>Objectif quotidien</h2>
        <DailyGoalSetter currentGoal={profile?.daily_goal ?? 5} />
      </Card>

      <Card className="space-y-3">
        <h2 className="font-semibold" style={{ color: "var(--text-secondary)" }}>Badges</h2>
        {userBadges.length === 0 ? (
          <p className="text-sm" style={{ color: "var(--text-muted)" }}>Aucun badge encore — complète une leçon !</p>
        ) : (
          <div className="grid grid-cols-2 gap-2">
            {userBadges.map((ub) => {
              const badge = ub.badges as unknown as { name_fr: string; description_fr: string; icon: string } | null;
              return (
                <div key={ub.badge_id} className="p-3 rounded-xl text-center space-y-1" style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)" }}>
                  <div className="text-2xl">{badge?.icon ?? "🏅"}</div>
                  <p className="text-xs font-semibold" style={{ color: "var(--text-primary)" }}>{badge?.name_fr ?? ub.badge_id}</p>
                  <p className="text-xs" style={{ color: "var(--text-muted)" }}>{badge?.description_fr}</p>
                </div>
              );
            })}
          </div>
        )}
      </Card>

      {hardConcepts.length > 0 && (
        <Card className="space-y-3">
          <h2 className="font-semibold" style={{ color: "var(--text-secondary)" }}>Concepts difficiles</h2>
          {hardConcepts.map((c) => (
            <div key={c.key} className="flex justify-between items-center text-sm">
              <span style={{ color: "var(--text-primary)" }}>{c.key}</span>
              <span className="px-2 py-0.5 rounded-full text-xs font-bold" style={{ backgroundColor: "rgba(255,85,85,0.15)", color: "var(--error)" }}>{c.rate}% erreurs</span>
            </div>
          ))}
        </Card>
      )}
      <LogoutButton />
    </div>
  );
}

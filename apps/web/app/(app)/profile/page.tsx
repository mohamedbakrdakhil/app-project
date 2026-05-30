import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import Card from "@/components/ui/Card";
import LogoutButton from "./LogoutButton";

export default async function ProfilePage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();
  const [profileRes, attemptsRes] = await Promise.all([
    admin.from("profiles").select("full_name, email, streak, total_xp, current_league_tier").eq("id", user.id).single(),
    admin.from("question_attempts").select("question_key, is_correct").eq("user_id", user.id).limit(500),
  ]);

  const profile = profileRes.data;
  const questionAttempts = attemptsRes.data ?? [];

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

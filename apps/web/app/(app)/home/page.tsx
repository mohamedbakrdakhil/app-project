export const metadata = { title: "Accueil" };
export const dynamic = "force-dynamic";

import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import StreakBadge from "@/components/ui/StreakBadge";
import XPBar from "@/components/ui/XPBar";
import SubjectCard from "@/components/ui/SubjectCard";
import Card from "@/components/ui/Card";
import Link from "next/link";

export default async function HomePage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();

  const todayStr = new Date().toISOString().split("T")[0]!;
  const [profileRes, subjectsRes, allLevelsRes, progressRes, dueRes, todayActivityRes] = await Promise.all([
    admin.from("profiles").select("full_name, email, streak, total_xp, daily_goal").eq("id", user.id).single(),
    admin.from("subjects").select("id, name_fr, icon, color, description_fr").eq("is_published", true).order("order_index"),
    admin.from("levels").select("id, chapter_id, title_fr, order_index").eq("is_published", true).order("order_index"),
    admin.from("user_progress").select("level_id, is_completed").eq("user_id", user.id),
    admin.from("spaced_rep_cards").select("id", { count: "exact", head: true }).eq("user_id", user.id).lte("next_review_date", todayStr),
    admin.from("streak_history").select("xp_earned, levels_completed").eq("user_id", user.id).eq("activity_date", todayStr).maybeSingle(),
  ]);

  const profile = profileRes.data;
  const subjects = subjectsRes.data ?? [];
  const dueCount = dueRes.count;
  const todayActivity = todayActivityRes.data;
  const todayXp = todayActivity?.xp_earned ?? 0;
  const goalXp = (profile?.daily_goal ?? 5) * 15;

  // Find next incomplete level
  const allLevels = allLevelsRes.data ?? [];
  const progressData = progressRes.data ?? [];
  const completedSet = new Set(progressData.filter((p) => p.is_completed).map((p) => p.level_id));

  const byChapter = new Map<string, Array<{ id: string; title_fr: string; order_index: number }>>();
  for (const l of allLevels) {
    if (!byChapter.has(l.chapter_id)) byChapter.set(l.chapter_id, []);
    byChapter.get(l.chapter_id)!.push(l);
  }

  let nextLevel: { id: string; titleFr: string } | null = null;
  for (const levels of byChapter.values()) {
    const sorted = levels.sort((a, b) => a.order_index - b.order_index);
    for (let i = 0; i < sorted.length; i++) {
      const l = sorted[i]!;
      const prevCompleted = i === 0 || completedSet.has(sorted[i - 1]!.id);
      if (!completedSet.has(l.id) && prevCompleted) {
        nextLevel = { id: l.id, titleFr: l.title_fr };
        break;
      }
    }
    if (nextLevel) break;
  }

  const displayName = profile?.full_name ?? profile?.email ?? "Étudiant";

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>
            Bonjour, {displayName.split(" ")[0]} 👋
          </h1>
          <p className="text-sm" style={{ color: "var(--text-muted)" }}>Continue ton apprentissage</p>
        </div>
        <StreakBadge streak={profile?.streak ?? 0} />
      </div>

      <XPBar current={todayXp} goal={goalXp} />
      <div className="flex items-center gap-2 text-sm" style={{ color: "var(--text-secondary)" }}>
        <span>🎯</span>
        <span>{todayActivity?.levels_completed ?? 0} / {profile?.daily_goal ?? 5} niveaux aujourd&apos;hui</span>
      </div>

      {nextLevel && (
        <Link href={`/lesson/${nextLevel.id}`}>
          <Card className="flex items-center justify-between hover:scale-[1.01] transition-transform" style={{ border: "1px solid rgba(255,77,109,0.4)" }}>
            <div>
              <p className="text-xs font-medium mb-1" style={{ color: "var(--anatomy)" }}>CONTINUER</p>
              <p className="font-semibold" style={{ color: "var(--text-primary)" }}>{nextLevel.titleFr}</p>
            </div>
            <span className="text-2xl">▶️</span>
          </Card>
        </Link>
      )}

      {(dueCount ?? 0) > 0 && (
        <Link href="/reviews">
          <Card className="flex items-center justify-between hover:scale-[1.01] transition-transform cursor-pointer">
            <div>
              <p className="font-semibold" style={{ color: "var(--text-primary)" }}>Révisions du jour</p>
              <p className="text-sm" style={{ color: "var(--text-muted)" }}>{dueCount} carte{(dueCount ?? 0) > 1 ? "s" : ""} à revoir</p>
            </div>
            <span className="text-2xl">🔄</span>
          </Card>
        </Link>
      )}

      <div>
        <h2 className="text-lg font-semibold mb-3" style={{ color: "var(--text-secondary)" }}>Matières</h2>
        <div className="space-y-3">
          {subjects.map((s) => (
            <SubjectCard
              key={s.id}
              id={s.id}
              nameFr={s.name_fr}
              icon={s.icon ?? "📚"}
              color={s.color ?? "var(--anatomy)"}
              descriptionFr={s.description_fr}
            />
          ))}
          {subjects.length === 0 && (
            <p className="text-sm text-center py-8" style={{ color: "var(--text-muted)" }}>Aucune matière disponible pour le moment.</p>
          )}
        </div>
      </div>
    </div>
  );
}

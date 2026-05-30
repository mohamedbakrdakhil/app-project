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

  const [profileRes, subjectsRes] = await Promise.all([
    admin.from("profiles").select("full_name, email, streak, total_xp, daily_goal").eq("id", user.id).single(),
    admin.from("subjects").select("id, name_fr, icon, color, description_fr").eq("is_published", true).order("order_index"),
  ]);

  const profile = profileRes.data;
  const subjects = subjectsRes.data ?? [];

  const today = new Date().toISOString().split("T")[0];
  const { count: dueCount } = await admin
    .from("spaced_rep_cards")
    .select("id", { count: "exact", head: true })
    .eq("user_id", user.id)
    .lte("next_review_date", today);

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

      <XPBar current={profile?.total_xp ?? 0} goal={(profile?.daily_goal ?? 5) * 15} />

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

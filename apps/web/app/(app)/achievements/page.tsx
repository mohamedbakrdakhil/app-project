export const metadata = { title: "Mes Récompenses" };
export const dynamic = "force-dynamic";

import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import Card from "@/components/ui/Card";

const BADGE_ICONS: Record<string, string> = {
  first_steps: "🐣",
  perfectionist: "⭐",
  streak_3: "🔥",
  streak_7: "🔥🔥",
  xp_100: "💰",
  xp_500: "💎",
  levels_3: "📚",
  levels_6: "🎓",
  curious: "🔍",
  xp_1000: "👑",
  streak_14: "🏅",
};

export default async function AchievementsPage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const supabase = await createSupabaseServerClient();

  const [badgesRes, userBadgesRes] = await Promise.all([
    supabase.from("badges").select("*").order("id"),
    supabase.from("user_badges").select("badge_id").eq("user_id", user.id),
  ]);

  const badges = badgesRes.data ?? [];
  const earnedIds = new Set((userBadgesRes.data ?? []).map((ub) => ub.badge_id));
  const earnedCount = earnedIds.size;
  const totalCount = badges.length;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>
          🏆 Mes Récompenses
        </h1>
        <p className="text-sm mt-1" style={{ color: "var(--text-muted)" }}>
          {earnedCount} / {totalCount} badges débloqués
        </p>
      </div>

      <div className="grid grid-cols-2 gap-3">
        {badges.map((badge) => {
          const earned = earnedIds.has(badge.id as string);
          const icon = BADGE_ICONS[badge.id as string] ?? badge.icon ?? "🏅";
          return (
            <Card
              key={badge.id as string}
              className={`p-4 text-center space-y-2 relative${earned ? "" : " opacity-40"}`}
            >
              {!earned && (
                <div className="absolute inset-0 flex items-center justify-center text-2xl">
                  🔒
                </div>
              )}
              <div className="text-3xl">{icon}</div>
              <p className="text-xs font-semibold" style={{ color: "var(--text-primary)" }}>
                {badge.name_fr as string}
              </p>
              <p className="text-xs" style={{ color: "var(--text-muted)" }}>
                {badge.description_fr as string}
              </p>
            </Card>
          );
        })}
      </div>
    </div>
  );
}

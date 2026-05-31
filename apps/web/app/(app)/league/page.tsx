import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import { getWeekStart, rankLeagueEntries, TIER_COLORS, TIER_ICONS, type LeagueTier } from "@masteri/core";
import Card from "@/components/ui/Card";

export const dynamic = "force-dynamic";
export const metadata = { title: "Ligue" };

export default async function LeaguePage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();
  const weekStart = getWeekStart();

  const { data: profile } = await admin
    .from("profiles")
    .select("current_league_tier, full_name, email")
    .eq("id", user.id)
    .single();

  const tier = (profile?.current_league_tier ?? "bronze") as LeagueTier;
  const tierColor = TIER_COLORS[tier];
  const tierIcon = TIER_ICONS[tier];

  const { data: weeklyRows } = await admin
    .from("weekly_xp")
    .select("user_id, xp_earned")
    .eq("week_start", weekStart)
    .order("xp_earned", { ascending: false })
    .limit(30);

  const userIds = (weeklyRows ?? []).map((r) => r.user_id as string);
  const { data: profileRows } = userIds.length
    ? await admin.from("profiles").select("id, full_name, email").in("id", userIds)
    : { data: [] };

  const nameMap = new Map((profileRows ?? []).map((p) => [p.id, p.full_name ?? p.email ?? "Étudiant"]));

  const { data: myWeekly } = await admin
    .from("weekly_xp")
    .select("xp_earned")
    .eq("user_id", user.id)
    .eq("week_start", weekStart)
    .maybeSingle();

  const entriesMap = new Map<string, { userId: string; displayName: string; xpThisWeek: number; tier: LeagueTier }>();
  for (const row of weeklyRows ?? []) {
    entriesMap.set(row.user_id as string, {
      userId: row.user_id as string,
      displayName: nameMap.get(row.user_id as string) ?? "Étudiant",
      xpThisWeek: row.xp_earned as number,
      tier,
    });
  }
  if (!entriesMap.has(user.id)) {
    entriesMap.set(user.id, {
      userId: user.id,
      displayName: profile?.full_name ?? profile?.email ?? "Étudiant",
      xpThisWeek: myWeekly?.xp_earned ?? 0,
      tier,
    });
  }

  const ranked = rankLeagueEntries(Array.from(entriesMap.values()));
  const myEntry = ranked.find((e) => e.userId === user.id);
  const top10 = ranked.slice(0, 10);

  const ws = new Date(weekStart);
  const weekEnd = new Date(ws);
  weekEnd.setUTCDate(ws.getUTCDate() + 6);
  const daysLeft = Math.max(0, Math.ceil((weekEnd.getTime() - Date.now()) / 86400000));

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>Ligue</h1>
        <p className="text-sm" style={{ color: "var(--text-muted)" }}>{daysLeft} jour{daysLeft !== 1 ? "s" : ""} restant{daysLeft !== 1 ? "s" : ""} cette semaine</p>
      </div>

      <Card className="text-center space-y-2" style={{ border: `1px solid ${tierColor}44` }}>
        <div className="text-4xl">{tierIcon}</div>
        <p className="font-bold text-lg" style={{ color: tierColor }}>
          Ligue {tier.charAt(0).toUpperCase() + tier.slice(1)}
        </p>
        <p className="text-sm" style={{ color: "var(--text-muted)" }}>
          Rang #{myEntry?.rank ?? "—"} · {myEntry?.xpThisWeek ?? 0} XP cette semaine
        </p>
        <div className="text-xs px-3 py-1 rounded-full inline-block" style={{ backgroundColor: "rgba(255,77,109,0.1)", color: "var(--anatomy)" }}>
          Top 5 → promotion · Bottom 5 → rétrogradation
        </div>
      </Card>

      <div className="space-y-2">
        {top10.map((entry) => {
          const isMe = entry.userId === user.id;
          const rankEmojis: Record<number, string> = { 1: "🥇", 2: "🥈", 3: "🥉" };
          const rankDisplay = rankEmojis[entry.rank] ?? `#${entry.rank}`;
          return (
            <div
              key={entry.userId}
              className="flex items-center gap-3 px-4 py-3 rounded-xl transition-all"
              style={{
                backgroundColor: isMe ? `${tierColor}18` : "var(--bg-card)",
                border: `1px solid ${isMe ? tierColor + "44" : "var(--border-soft)"}`,
              }}
            >
              <span className="text-lg w-8 text-center flex-shrink-0">{rankDisplay}</span>
              <span className="flex-1 font-medium truncate" style={{ color: isMe ? tierColor : "var(--text-primary)" }}>
                {entry.displayName}{isMe ? " (toi)" : ""}
              </span>
              <span className="text-sm font-semibold flex-shrink-0" style={{ color: "var(--xp-color)" }}>
                {entry.xpThisWeek} XP
              </span>
            </div>
          );
        })}
        {top10.length === 0 && (
          <p className="text-center py-8 text-sm" style={{ color: "var(--text-muted)" }}>
            Personne n&apos;a encore gagné d&apos;XP cette semaine. Sois le premier !
          </p>
        )}
      </div>
    </div>
  );
}

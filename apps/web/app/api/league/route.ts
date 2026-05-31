import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import { getWeekStart, rankLeagueEntries, type LeagueTier } from "@masteri/core";

export const dynamic = "force-dynamic";

export async function GET() {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const admin = createSupabaseAdminClient();
  const weekStart = getWeekStart();

  const { data: profile } = await admin
    .from("profiles")
    .select("current_league_tier, full_name, email")
    .eq("id", user.id)
    .single();

  const tier = (profile?.current_league_tier ?? "bronze") as LeagueTier;
  const displayName = profile?.full_name ?? profile?.email ?? "Étudiant";

  const { data: weeklyXpRows } = await admin
    .from("weekly_xp")
    .select("user_id, xp_earned")
    .eq("week_start", weekStart)
    .order("xp_earned", { ascending: false })
    .limit(30);

  const userIds = (weeklyXpRows ?? []).map((r) => r.user_id as string);
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

  const myXp = myWeekly?.xp_earned ?? 0;

  const entriesMap = new Map<string, { userId: string; displayName: string; xpThisWeek: number; tier: LeagueTier }>();
  for (const row of weeklyXpRows ?? []) {
    entriesMap.set(row.user_id as string, {
      userId: row.user_id as string,
      displayName: nameMap.get(row.user_id as string) ?? "Étudiant",
      xpThisWeek: row.xp_earned as number,
      tier,
    });
  }
  if (!entriesMap.has(user.id)) {
    entriesMap.set(user.id, { userId: user.id, displayName, xpThisWeek: myXp, tier });
  }

  const ranked = rankLeagueEntries(Array.from(entriesMap.values()));
  const myEntry = ranked.find((e) => e.userId === user.id);

  return NextResponse.json({
    weekStart,
    tier,
    myRank: myEntry?.rank ?? ranked.length,
    myXpThisWeek: myXp,
    leaderboard: ranked.slice(0, 10),
  });
}
